# CMS

Basit bir içerik yönetim sistemi (MVP): kullanıcı ve roller, sayfa ve blog
yazısı, medya yükleme, admin paneli ve public site.

- **Frontend:** Next.js + TypeScript + Tailwind (`frontend/`)
- **Backend:** Fastify + TypeScript + Prisma + PostgreSQL (`backend/`)
- **Test:** Vitest (unit), Playwright (e2e, `tests/`)
- **Altyapı:** Docker Compose (`infra/`), GitHub Actions (`.github/`)

Görev durumu: [`docs/tasks/BOARD.md`](docs/tasks/BOARD.md) · API sözleşmesi:
`docs/api.md` · Altyapı sözleşmesi: [`infra/README.md`](infra/README.md)

## Gereksinimler

- Docker Desktop veya OrbStack (Docker Compose v2.20+; `include` desteği gerekli)
- Uygulamaları Docker dışında çalıştırmak için: Node.js 20 LTS + npm

## Lokal kurulum

```bash
# 1) Ortam değişkenleri (ilk kez)
cp .env.example .env
#    JWT_SECRET'ı değiştirin:  openssl rand -base64 48

# 2) Veritabanı
docker compose up -d
docker compose ps        # postgres -> (healthy)
```

PostgreSQL `localhost:5432`'de çalışır (kullanıcı/şifre/DB `.env`'den).

### Uygulamalarla birlikte (backend/ ve frontend/ eklendikten sonra)

Uygulama kodu henüz yok. `backend/` ve `frontend/` oluştuğunda:

```bash
docker compose --profile app up --build
docker compose --profile app exec backend npm run db:seed   # ilk admin kullanıcı
```

| Servis | Adres |
|--------|-------|
| Frontend | http://localhost:3000 |
| Backend API | http://localhost:4000 (sağlık: `/health`) |
| PostgreSQL | localhost:5432 |

### Durdurma

```bash
docker compose --profile app down     # veriler korunur
```

> `docker compose down -v` veritabanını ve yüklenen medyayı **siler**.
