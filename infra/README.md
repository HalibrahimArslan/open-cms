# Altyapı ve Çalıştırma Sözleşmesi

Bu belge `backend/` (TASK-003) ve `frontend/` (TASK-006) uygulamalarının, `infra/`
altındaki Docker Compose kurulumu ve CI (TASK-020) ile uyumlu çalışabilmesi için
**uyması zorunlu** kuralları tanımlar. Sözleşmede değişiklik gerekiyorsa
uygulamayı sözleşmeye göre eğmek yerine PM üzerinden devops'a bildirin.

## Dosyalar

| Dosya | Amaç |
|-------|------|
| `compose.yaml` (kök) | Kökten `docker compose ...` çalıştırmak için giriş noktası; `infra/docker-compose.yml`'i include eder ve kökteki `.env`'i okur |
| `infra/docker-compose.yml` | Servis tanımları: `postgres` (varsayılan), `backend` + `frontend` (`app` profili) |
| `infra/backend.Dockerfile` | Backend **dev** imajı (hot reload). Build context: `backend/` |
| `infra/frontend.Dockerfile` | Frontend **dev** imajı (Next.js dev server). Build context: `frontend/` |
| `infra/*.Dockerfile.dockerignore` | İlgili imaj için dockerignore (BuildKit) |
| `.env.example` (kök) | Tüm değişkenlerin açıklamalı şablonu. **Tek kaynak budur.** |

Prod imajları bu dosyalar değildir; TASK-021 kapsamında ayrıca hazırlanacak.

## 1. Ortak kurallar

- **Node sürümü:** Node.js **20 LTS** (Docker imajı `node:20-alpine`). Her iki
  uygulama `package.json` içinde `"engines": { "node": ">=20 <21" }` belirtmeli;
  kökte bir `.nvmrc` (`20`) eklenmesi önerilir.
- **Paket yöneticisi:** **npm**. `package-lock.json` repoya commit edilmeli
  (Dockerfile ve CI `npm ci` kullanır; lockfile yoksa build kırılır).
- **Dizin:** her uygulama kendi klasöründe bağımsız bir npm projesidir
  (`backend/package.json`, `frontend/package.json`). Kökte workspace yok.
- **Dinleme adresi:** sunucular `0.0.0.0` üzerinde dinlemeli (`localhost`
  dinleyen bir süreç container dışından erişilemez).
- **Port:** `PORT` env değişkeni okunmalı; yoksa varsayılan aşağıdaki gibi.
- **Hot reload:** dev script'i dosya değişikliklerini izlemeli. Kod volume ile
  `/app`'e bağlanır; macOS'te izleme için `CHOKIDAR_USEPOLLING` /
  `WATCHPACK_POLLING` set edilir. `node_modules` container içinde ayrı volume'dadır;
  host'taki `node_modules` kullanılmaz.
- **Secret:** kod içinde secret/şifre sabiti olmaz; her şey env'den okunur.
  Zorunlu env eksikse uygulama açılışta anlaşılır bir hata ile durmalı.

## 2. Backend (`backend/`, Fastify + TypeScript + Prisma)

### Port
`4000` (`PORT`, varsayılan 4000). Host: `HOST` (varsayılan `0.0.0.0`).

### Zorunlu npm script'leri

| Script | Beklenen davranış | Kim kullanır |
|--------|-------------------|--------------|
| `dev` | Hot reload ile sunucuyu başlatır (ör. `tsx watch src/server.ts`) | Docker dev imajı, lokal geliştirme |
| `build` | TypeScript'i derler (`dist/`) | CI, prod imajı |
| `start` | Derlenmiş çıktıyı çalıştırır (`node dist/server.js`) | Prod imajı |
| `lint` | ESLint, hata varsa non-zero çıkış | CI |
| `typecheck` | `tsc --noEmit` | CI |
| `test` | Vitest, **tek seferlik** (watch değil: `vitest run`) | CI |
| `db:migrate` | **Etkileşimsiz** `prisma migrate deploy` (`migrate dev` değil) | Docker dev imajı açılışı, CI |
| `db:migrate:dev` | `prisma migrate dev` (yeni migration üretmek için, geliştirici elle) | Geliştirici |
| `db:seed` | Seed'i çalıştırır; **idempotent** olmalı (tekrar çalışınca çoğaltmaz) | Geliştirici, CI/e2e |
| `db:reset` | `prisma migrate reset --force` — **yalnızca lokal**, veriyi siler | Geliştirici (elle) |

Not: Docker imajı açılışta `npm run db:migrate && npm run dev` çalıştırır, bu
yüzden `db:migrate` etkileşimsiz olmalı ve prompt beklememeli.

Prisma şeması `backend/prisma/schema.prisma` konumunda olmalı (imaj build'de
varsa `prisma generate` çalıştırır). Prisma seed, `package.json` içinde
`"prisma": { "seed": "..." }` ile de tanımlanabilir; ama `db:seed` script'i şart.

### Okunacak env değişkenleri

| Değişken | Zorunlu | Açıklama |
|----------|---------|----------|
| `DATABASE_URL` | evet | Prisma bağlantısı. Docker'da compose üretir (`@postgres:5432`), host'ta `.env`'deki `@localhost` |
| `JWT_SECRET` | evet | JWT imzalama; eksikse açılışta hata |
| `PORT` | hayır (4000) | Dinleme portu |
| `HOST` | hayır (`0.0.0.0`) | Dinleme adresi |
| `CORS_ORIGIN` | hayır (`http://localhost:3000`) | Frontend origin'i |
| `UPLOAD_DIR` | hayır (`./uploads`) | Medya yükleme dizini; Docker'da `/app/uploads` (named volume `uploads`). Yoksa uygulama oluşturmalı |
| `MAX_UPLOAD_SIZE_MB` | hayır (10) | Azami dosya boyutu |
| `SEED_ADMIN_EMAIL` / `SEED_ADMIN_PASSWORD` | yalnızca seed | İlk admin kullanıcı |
| `NODE_ENV` | hayır | `development` / `test` / `production` |

Yeni bir env değişkeni eklenirse kökteki `.env.example`'a açıklamasıyla eklenmesi
için PM üzerinden devops'a bildirilmeli.

### Healthcheck
- `GET /health` → `200`, gövde `{"status":"ok"}`. Kimlik doğrulama gerektirmez,
  `/api` önekinin **dışındadır**.
- Mümkünse veritabanına basit bir sorgu (`SELECT 1`) yapmalı; DB erişilemiyorsa
  `503` dönmeli.
- Docker healthcheck bunu container içinden `wget http://127.0.0.1:$PORT/health`
  ile çağırır (alpine'da busybox `wget` mevcut).

### API öneki
Uygulama endpoint'leri `/api/...` altında (bkz. `docs/api.md`). Medya dosyalarının
nasıl sunulacağı (ör. `GET /uploads/...` statik) backend tarafından `docs/api.md`'de
belirtilmeli.

## 3. Frontend (`frontend/`, Next.js + TypeScript + Tailwind)

### Port
`3000` (`PORT`, varsayılan 3000). `next dev` `0.0.0.0`'da dinlemeli:
ör. `"dev": "next dev -H 0.0.0.0 -p ${PORT:-3000}"` veya `next dev -H 0.0.0.0`
(Next, `PORT` env'ini kendisi okur).

### Zorunlu npm script'leri

| Script | Beklenen davranış |
|--------|-------------------|
| `dev` | `next dev`, `0.0.0.0` üzerinde, hot reload |
| `build` | `next build` |
| `start` | `next start` |
| `lint` | ESLint (`next lint` veya `eslint .`), hata varsa non-zero |
| `typecheck` | `tsc --noEmit` |
| `test` | Vitest, tek seferlik (`vitest run`) |

Playwright e2e testleri `tests/` altında (qa sahipliğinde) yaşar; frontend
`package.json`'ına konulmaz. CI'da çalıştırma şekli TASK-020'de belirlenecek.

### Okunacak env değişkenleri

| Değişken | Nerede | Açıklama |
|----------|--------|----------|
| `NEXT_PUBLIC_API_BASE_URL` | tarayıcı | API kök adresi (`http://localhost:4000`). Client bundle'a gömülür; secret içermez |
| `API_INTERNAL_URL` | yalnızca server (SSR, route handler) | Docker içinde `http://backend:4000`. Tanımlı değilse `NEXT_PUBLIC_API_BASE_URL` kullanılmalı |
| `PORT` | server | Dinleme portu |

Önemli: Docker'da SSR tarafı `localhost:4000`'e erişemez (o, frontend
container'ının kendisidir). Sunucu tarafı fetch'ler `API_INTERNAL_URL`'i
kullanmalı.

### Healthcheck
Ayrı bir endpoint zorunlu değil; ana sayfanın `200` dönmesi yeterli.

## 4. Komutlar (kök dizinden)

```bash
cp .env.example .env              # ilk kez; değerleri gözden geçirin
docker compose up -d              # yalnızca postgres
docker compose ps                 # postgres "healthy" olmalı
docker compose --profile app up --build   # postgres + backend + frontend
docker compose --profile app exec backend npm run db:seed
docker compose logs -f backend
docker compose --profile app down # durdurur; veri (volume) korunur
```

`infra/` dosyasını doğrudan kullanmak isterseniz:
`docker compose -f infra/docker-compose.yml --env-file .env up -d`.

**Dikkat:** `docker compose down -v` tüm volume'ları (veritabanı, yüklenen
medya) **kalıcı olarak siler**. Yalnızca bilerek kullanın.

## 5. Bilinen sınırlamalar

- Backend/frontend servisleri, ilgili dizinler (`package.json` + `package-lock.json`)
  oluşana kadar build edilemez; `--profile app` o zamana kadar hata verir.
- `JWT_SECRET` compose'ta zorunlu tanımlıdır; `.env`'de yoksa varsayılan
  `docker compose up` bile interpolasyon hatası verir.
- `package.json` değiştiğinde (yeni bağımlılık) `node_modules` named volume'u
  eski kalır (`--build` tek başına yetmez). Güncellemek için:
  `docker compose --profile app exec backend npm install` (frontend için aynı şekilde).
- `POSTGRES_*` değerleri yalnızca volume ilk oluşturulurken uygulanır.
