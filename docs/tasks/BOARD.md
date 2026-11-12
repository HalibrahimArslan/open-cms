# Görev Panosu

Durumlar: `Todo` · `In Progress` · `Review (QA)` · `Done` · `Blocked`

> Kural: `qa` onay vermeden hiçbir görev `Done` olmaz. API sözleşmesi `docs/api.md`, tasarımlar `docs/design/` altında yaşar.

## Faz 0 — Temel

| ID | Başlık | Sahibi | Durum | Bağımlılık | Kabul kriterleri |
|----|--------|--------|-------|------------|------------------|
| TASK-001 | Design system ve token'lar | designer | Review (QA) | — | `docs/design/tokens.md` var; renk, tipografi, spacing, radius tanımlı; temel bileşenler (buton, input, tablo, badge, modal, toast) ve durumları (hover, disabled, hata, yükleniyor) belgelenmiş |
| TASK-002 | Dev altyapısı: docker-compose + çalıştırma sözleşmesi | devops | Blocked (Docker kapalı; postgres healthy doğrulaması bekliyor) | — | `infra/docker-compose.yml` ile PostgreSQL tek komutla ayağa kalkıyor; backend/frontend servisleri tanımlı ama uygulama kodu gelene kadar ayrı profilde; `infra/README.md`'de uygulamaların uyması gereken sözleşme (portlar, npm script'leri, env değişkenleri) yazılı; `.env.example` mevcut; kök `README.md`'de çalıştırma adımları var. Uygulama kodu yazılmaz |
| TASK-003 | Backend iskeleti + veritabanı şeması (Prisma) + seed | backend | Todo | TASK-002 | `backend/` iskeleti (Fastify + TS) `infra/README.md` sözleşmesine uyuyor; `User` (rol: admin/editor/author), `Content` (tip: page/post, başlık, slug, gövde, durum: draft/published, yazar, tarihler), `Media` modelleri; migration çalışıyor; seed bir admin kullanıcı oluşturuyor; slug tip bazında benzersiz |

## Faz 1 — Kimlik doğrulama ve roller

| ID | Başlık | Sahibi | Durum | Bağımlılık | Kabul kriterleri |
|----|--------|--------|-------|------------|------------------|
| TASK-004 | Login ve admin layout tasarımı | designer | Review (QA) | TASK-001 | `docs/design/login.md` ve `docs/design/admin-layout.md` var; hata, yükleniyor ve yetkisiz erişim durumları tanımlı; rol bazlı menü görünürlüğü belirtilmiş |
| TASK-005 | Auth API + rol middleware | backend | Todo | TASK-003 | `POST /api/auth/login`, `POST /api/auth/logout`, `GET /api/auth/me` çalışıyor; şifreler hash'li; rol kontrol middleware'i var; tüm endpoint'ler `docs/api.md`'de; unit testler geçiyor |
| TASK-006 | Frontend iskeleti + login ekranı + korumalı admin rotaları | frontend | Todo | TASK-004, TASK-005 | `frontend/` iskeleti (Next.js + TS + Tailwind, token'lar config'de) `infra/README.md` sözleşmesine uyuyor; tasarıma uygun login; başarılı girişte admin paneline yönlendirme; oturumsuz kullanıcı `/admin/*`'a erişemiyor; rol bazlı menü |
| TASK-007 | Auth ve rol e2e testleri | qa | Todo | TASK-006 | Playwright: geçerli/geçersiz giriş, çıkış, korumalı rota, her rolün yetki sınırı test edilmiş; bulgular `docs/tasks/BUGS.md`'de |

## Faz 2 — İçerik yönetimi (sayfa + blog yazısı)

| ID | Başlık | Sahibi | Durum | Bağımlılık | Kabul kriterleri |
|----|--------|--------|-------|------------|------------------|
| TASK-008 | İçerik liste / form ekranları tasarımı | designer | Todo | TASK-001 | `docs/design/content.md` var; liste (filtre: tip, durum), oluştur/düzenle formu, silme onayı, boş durum, doğrulama hataları tanımlı |
| TASK-009 | İçerik CRUD API | backend | Todo | TASK-005 | Listele/getir/oluştur/güncelle/sil endpoint'leri; slug otomatik üretim + benzersizlik; yetki: author yalnızca kendi içeriği, editor ve admin tümü; yalnızca editor/admin yayınlayabilir (bkz. karar #1); `docs/api.md` güncel; unit testler geçiyor |
| TASK-010 | Admin içerik CRUD ekranları | frontend | Todo | TASK-008, TASK-009 | Tasarıma uygun liste/oluştur/düzenle/sil; taslak/yayında geçişi; API hataları kullanıcıya gösteriliyor; rol bazlı buton görünürlüğü |
| TASK-011 | İçerik CRUD e2e testleri | qa | Todo | TASK-010 | Her rol için CRUD senaryoları, slug çakışması, yetkisiz düzenleme denemesi test edilmiş |

## Faz 3 — Medya

| ID | Başlık | Sahibi | Durum | Bağımlılık | Kabul kriterleri |
|----|--------|--------|-------|------------|------------------|
| TASK-012 | Medya kütüphanesi tasarımı | designer | Review (QA) | TASK-001 | `docs/design/media.md` var; yükleme (sürükle-bırak, ilerleme), grid görünüm, silme, içerik formundan medya seçme akışı tanımlı |
| TASK-013 | Medya yükleme API | backend | Todo | TASK-005 | Yükle/listele/sil endpoint'leri; dosya tipi (görsel) ve boyut sınırı; depolama yerel volume (bkz. karar #2); `docs/api.md` güncel; unit testler geçiyor |
| TASK-014 | Medya ekranı + içerik formuna entegrasyon | frontend | Todo | TASK-012, TASK-013, TASK-010 | Medya yükleme/listeleme/silme; içerik gövdesine görsel ekleme; hatalı tip/boyut uyarısı |
| TASK-015 | Medya e2e testleri | qa | Todo | TASK-014 | Geçerli/geçersiz yükleme, silme, içerikte görsel kullanımı test edilmiş |

## Faz 4 — Public site

| ID | Başlık | Sahibi | Durum | Bağımlılık | Kabul kriterleri |
|----|--------|--------|-------|------------|------------------|
| TASK-016 | Public site tasarımı | designer | Review (QA) | TASK-001 | `docs/design/public-site.md` var; ana sayfa, blog listesi, yazı detayı, statik sayfa, 404 ekranları; mobil uyumlu |
| TASK-017 | Public okuma API | backend | Todo | TASK-009 | Yalnızca `published` içerik döner; slug ile getirme; blog listesi sayfalama; `docs/api.md` güncel |
| TASK-018 | Public site ekranları | frontend | Todo | TASK-016, TASK-017 | Tasarıma uygun sayfalar; taslak içerik ve olmayan slug → 404; temel SEO (title, meta description) |
| TASK-019 | Public site e2e testleri | qa | Todo | TASK-018 | Yayındaki içerik görünüyor, taslak görünmüyor, yayından kaldırılan içerik 404 veriyor |

## Faz 5 — CI ve dağıtım

| ID | Başlık | Sahibi | Durum | Bağımlılık | Kabul kriterleri |
|----|--------|--------|-------|------------|------------------|
| TASK-020 | GitHub Actions CI | devops | Todo | TASK-002 | `.github/workflows/ci.yml`: lint, typecheck, Vitest, Playwright (postgres servisiyle); PR'larda çalışıyor |
| TASK-021 | Prod Docker imajları + deploy dokümanı | devops | Todo | TASK-019 | Prod Dockerfile'lar (multi-stage); migration adımı; `infra/DEPLOY.md`; **gerçek prod deploy kullanıcı onayı olmadan yapılmaz** |
| TASK-022 | MVP regresyon turu | qa | Todo | TASK-020, TASK-021 | Tüm e2e testleri CI'da yeşil; açık kritik bug yok; MVP onayı `BUGS.md`'de kayıtlı |

## Paralel çalışma dalgaları

1. **Dalga 1:** TASK-001 (designer) ∥ TASK-002 (devops)
2. **Dalga 2:** TASK-003 (backend) ∥ TASK-004, TASK-008, TASK-012, TASK-016 (designer) ∥ TASK-020 (devops)
3. **Dalga 3:** TASK-005 → TASK-009 → TASK-013 / TASK-017 (backend), frontend tasarım + API hazır oldukça başlar
4. Her fazın sonunda ilgili QA görevi; QA onayı sonrası `Done`

## Açık kararlar (kullanıcı onayı bekliyor)

1. **Yayınlama yetkisi:** Author kendi yazısını yayınlayabilir mi, yoksa yalnızca editor/admin mi? (Varsayılan: yalnızca editor/admin.)
2. **Medya depolama:** Yerel disk/volume mı, S3 uyumlu depolama mı? (Varsayılan: yerel volume.)
3. **Gövde editörü:** Markdown mı, WYSIWYG (ör. TipTap) mi? (Varsayılan: Markdown.)
4. **Kullanıcı yönetimi ekranı:** Admin'in kullanıcı ekleyip rol atadığı bir ekran MVP'ye girsin mi? (Şu an kapsam dışı; kullanıcılar seed ile oluşturuluyor.)
5. **Deploy hedefi:** Nereye deploy edilecek (VPS, Fly.io, Render vb.)?

## Alınan kararlar (PM, geri alınabilir teknik kararlar)

- **D-01:** `compose.yaml` kökte kalır; `.env.example` kökte tek kaynaktır. Sözleşmede `typecheck` script'i zorunludur. (TASK-002)
- **D-02:** Fontlar `next/font` ile self-host edilir; public site da Inter kullanır. (TASK-001)
- **D-03:** Giriş e-posta + şifre ile yapılır. "Beni hatırla" ve "Şifremi unuttum" MVP dışıdır. Login endpoint'i rate limit uygular ve 429 döner. (TASK-004/005)
- **D-04:** MVP'de dashboard yok; `/admin` → `/admin/content` yönlendirir. Public önizleme MVP dışıdır. (TASK-004/016)
- **D-05:** Medya yetkisi: üç rol de yükler ve görüntüler; admin ve editor tümünü, author yalnızca kendi yüklediğini siler. `Media` modelinde `uploadedById` alanı bulunur. (TASK-003/013)
- **D-06:** Medya sınırı: JPG, PNG, WebP, GIF; en fazla 5 MB. SVG kabul edilmez (XSS riski). (TASK-012/013)
- **D-07:** Site adı ve açıklaması env/config'ten gelir. (TASK-002/017)
- **D-08:** `Content` modelinde `publishedAt` alanı bulunur; API yazarın görünen adını döner. Özet gövdeden otomatik üretilir (~160 karakter); kapak görseli MVP dışıdır. (TASK-003/009/017)
- **D-09:** Sayfa slug'larında `blog`, `admin`, `login`, `api`, `health` rezervedir; backend reddeder. (TASK-009)
- **D-10:** Oturum düşerse içerik formundaki kaydedilmemiş veri tarayıcıda (localStorage) taslak olarak saklanır ve yeniden girişte geri yüklenir. (TASK-008/010)
