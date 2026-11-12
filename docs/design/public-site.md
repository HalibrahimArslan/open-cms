# Ekranlar: Public site

> Sahibi: designer · Görev: TASK-016
>
> Bağımlılıklar: `tokens.md`, `components.md` (SiteHeader §25, SiteFooter §26, PostCard §27, SimplePagination §28, Prose §29, SkipLink §18 — bu görevde eklendi/yeniden kullanıldı).
> API: TASK-017 (yalnız `published` içerik, slug ile getirme, blog sayfalama).
> Tipografi: yalnız **Inter** (tokens.md §2). Serif font eklenmez.

---

## 1. Amaç ve rota haritası

Yayındaki sayfa ve blog yazılarını ziyaretçilere okunaklı, hızlı ve erişilebilir biçimde göstermek. Ziyaretçi giriş yapmaz; site salt okunurdur.

| Ekran | Rota | Kaynak |
|-------|------|--------|
| Ana sayfa | `/` | Site adı/açıklaması + son 6 blog yazısı |
| Blog listesi | `/blog`, `/blog?page=2` | Yayındaki yazılar, en yeni önce, sayfa başı 10 |
| Yazı detayı | `/blog/<slug>` | Tek yazı (`type=post`) |
| Statik sayfa | `/<slug>` | Tek sayfa (`type=page`) |
| 404 | Eşleşmeyen her yol | — |

Kurallar:
- Taslak, var olmayan veya yayından kaldırılmış içerik → **404** (yetkili kullanıcı için bile; önizleme MVP dışı).
- `?page` geçersizse (sayı değil, < 1) → `/blog`'a yönlendir; aralık dışıysa (> son sayfa) → 404.
- Sayfa slug'ları `blog`, `admin`, `login`, `api` ve framework yollarıyla çakışmamalı (bkz. AÇIK SORU — backend'de rezerve liste).

### Site kimliği

Site adı ve kısa açıklama (`{SITE_ADI}`, `{SITE_ACIKLAMASI}`) içerik değildir; MVP'de ortam değişkeni/yapılandırmadan gelir (bkz. AÇIK SORU). Logo görseli yok: site adı metin olarak logo görevi görür.

---

## 2. Ortak kabuk

### 2.1 Masaüstü

```
┌────────────────────────────────────────────────────────────────────────────┐
│  İçeriğe atla (yalnız odakta görünür)                                      │
├────────────────────────────────────────────────────────────────────────────┤
│  {SITE_ADI}                                                   Blog         │ ← SiteHeader 64px, bg gray-0,
│                                                               ‾‾‾‾         │   alt kenarlık border-default
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│                         (sayfa içeriği, max-w-site)                        │
│                                                                            │
├────────────────────────────────────────────────────────────────────────────┤
│  {SITE_ADI}                                    Hakkımızda · İletişim · ... │ ← SiteFooter: bg gray-50,
│  © 2026 {SITE_ADI}                                                         │   üst kenarlık border-default
└────────────────────────────────────────────────────────────────────────────┘
```

- **Header navigasyonu:** Yalnız "Blog". Aktifken altı 2px brand-600 çizgi + `aria-current="page"`.
- **Footer navigasyonu:** Yayındaki tüm **sayfalar** (`type=page`), başlığa göre alfabetik. Sayfa yoksa liste gösterilmez.
- Header **yapışkan değil** (okuma alanını daraltmaz).
- Arka plan: sayfa gövdesi gray-0 (admin'den farklı olarak gray-50 değil), footer gray-50.

### 2.2 Mobil (< `sm`)

Header'da yalnız site adı ve "Blog" var; hamburger menü **gerekmez**. Footer linkleri alt alta, her biri 44px dokunma yüksekliğinde.

---

## 3. Ana sayfa (`/`)

```
┌─ SiteHeader ───────────────────────────────────────────────────────────────┐
│                                                                            │
│   {SITE_ADI}                                                               │ ← h1 text-5xl/bold, tracking-tight
│   {SITE_ACIKLAMASI}                                                        │ ← text-xl gray-600, max 60ch
│                                                                            │   dikey padding 80px (hero)
│ ─────────────────────────────────────────────────────────────────────────  │
│                                                                            │
│   Son yazılar                                          Tüm yazılar →       │ ← h2 text-3xl/semibold + link
│                                                                            │
│   ┌──────────────────────┐ ┌──────────────────────┐ ┌──────────────────────┐
│   │ 12 Kasım 2026        │ │ 8 Kasım 2026         │ │ 1 Kasım 2026         │ ← PostCard
│   │ Yazı başlığı iki     │ │ Başka bir başlık     │ │ ...                  │
│   │ satıra kadar         │ │                      │ │                      │
│   │ Özet metni üç        │ │ Özet ...             │ │                      │
│   │ satıra kadar…        │ │                      │ │                      │
│   └──────────────────────┘ └──────────────────────┘ └──────────────────────┘
│   (ikinci satır: 3 kart daha)                                              │
│                                                                            │
└─ SiteFooter ───────────────────────────────────────────────────────────────┘
```

- Son 6 yazı; 6'dan az varsa olduğu kadar. "Tüm yazılar →" yalnız 6'dan fazla yazı varsa gösterilir.
- Hero dekorsuzdur (görsel/arka plan rengi yok); bölüm arası 64px (mobil 48px).

### Durumlar

| Durum | Görünüm |
|-------|---------|
| Yazı yok | Hero kalır; "Son yazılar" bölümü yerine EmptyState `default` (ikonlu, butonsuz): h2 "Henüz yazı yayınlanmadı", metin "Yeni yazılar burada görünecek." |
| Hata (API ulaşılamıyor) | Bkz. §8 "Sunucu hatası" sayfası |

---

## 4. Blog listesi (`/blog`)

```
┌─ SiteHeader ───────────────────────────────────────────────────────────────┐
│                                                                            │
│   Blog                                                                     │ ← h1 text-4xl/semibold
│   Tüm yazılar, en yeniden eskiye.                                          │ ← text-lg gray-600
│                                                                            │
│   ┌──────────────────────────────────────────────────────────────┐        │
│   │ 12 Kasım 2026 · Ayşe Yılmaz                                  │        │ ← PostCard `list` varyantı
│   │ Yazı başlığı                                                 │        │   max-w-prose-lg, sola yaslı
│   │ Özet metni üç satıra kadar kırpılır…                         │        │
│   └──────────────────────────────────────────────────────────────┘        │
│   ────────────────────────────────────────────── (ayırıcı)                 │
│   ┌──────────────────────────────────────────────────────────────┐        │
│   │ ...                                                          │        │
│   └──────────────────────────────────────────────────────────────┘        │
│                                                                            │
│   [‹ Önceki]            Sayfa 2 / 6             [Sonraki ›]                │ ← SimplePagination
│                                                                            │
└─ SiteFooter ───────────────────────────────────────────────────────────────┘
```

- Sayfa başı 10 yazı. URL: `/blog?page=N` (1. sayfa parametresiz, `?page=1` → `/blog`'a kanonik yönlendirme).
- Sayfa başlığı (`<title>`): 1. sayfada "Blog — {SITE_ADI}", sonrakilerde "Blog (Sayfa 2) — {SITE_ADI}".
- Liste görünümü tek sütun (okunabilirlik); kartlar arası ayırıcı çizgi, kart kutusu yok.

### Durumlar

| Durum | Görünüm |
|-------|---------|
| Yazı yok | Başlık kalır; EmptyState: "Henüz yazı yayınlanmadı" / "Yeni yazılar burada görünecek." + secondary link "Ana sayfaya dön". Pagination gizli |
| Tek sayfa | Pagination gizli |
| İlk sayfa | "‹ Önceki" gösterilmez (disabled değil, yok); yerinde boşluk kalır, "Sayfa 1 / 6" ortada kalır |
| Son sayfa | "Sonraki ›" gösterilmez |
| Sayfa aralık dışı | 404 |
| Yükleniyor (istemci navigasyonu) | Sunucu render'ı esastır. Next.js `loading` durumunda: başlık + 3 PostCard skeleton'u (tarih satırı 30%, başlık 70%, özet 2 satır) |

---

## 5. Yazı detayı (`/blog/<slug>`)

```
┌─ SiteHeader ───────────────────────────────────────────────────────────────┐
│                                                                            │
│            ← Blog                                                          │ ← geri linki text-sm, brand-600
│                                                                            │
│            Yazı başlığı burada uzun olursa                                 │ ← h1 text-4xl/semibold (mobil text-3xl)
│            iki satıra iner                                                 │
│            Ayşe Yılmaz · 12 Kasım 2026                                     │ ← meta text-sm gray-600, <time datetime>
│                                                                            │
│            ─────────────────────────────────────────                       │
│                                                                            │
│            Gövde metni 18px / 32px satır yüksekliği. Paragraflar           │ ← Prose, max-w-prose-lg (70ch)
│            arası 24px. [link] altı çizili brand-600.                       │   yatayda ortalı
│                                                                            │
│            ## Ara başlık                                                   │
│            ┌─────────────────────────────────────────┐                     │
│            │            görsel (rounded-lg)          │                     │
│            └─────────────────────────────────────────┘                     │
│            > alıntı                                                        │
│            `kod`  ve kod bloğu                                             │
│                                                                            │
│            ─────────────────────────────────────────                       │
│            ← Tüm yazılar                                                   │ ← secondary link
│                                                                            │
└─ SiteFooter ───────────────────────────────────────────────────────────────┘
```

- Kapsayıcı `<article>`; başlık, meta ve gövde aynı 70ch sütunda.
- Meta: yazar adı (API döndürüyorsa) · yayın tarihi. Tarih biçimi Türkçe uzun: "12 Kasım 2026" (`Intl.DateTimeFormat('tr-TR', { dateStyle: 'long' })`). Saat gösterilmez.
- Önceki/sonraki yazı gezintisi MVP'de yok.
- `<title>`: "{Yazı başlığı} — {SITE_ADI}"; `meta description`: özet (§9).

---

## 6. Statik sayfa (`/<slug>`)

Yazı detayıyla aynı düzen, şu farklarla:
- "← Blog" geri linki ve alttaki "Tüm yazılar" linki **yok**.
- Meta satırı (yazar, tarih) **yok**.
- Başlıktan sonra ayırıcı çizgi yok; doğrudan gövde (32px boşluk).
- Footer'daki ilgili sayfa linki `aria-current="page"` + altı çizili.

---

## 7. 404

```
┌─ SiteHeader ───────────────────────────────────────────────────────────────┐
│                                                                            │
│                                  404                                       │ ← text-5xl/bold gray-300, aria-hidden
│                          Sayfa bulunamadı                                  │ ← h1 text-3xl/semibold
│            Aradığınız sayfa kaldırılmış, adı değişmiş ya da                │ ← text-lg gray-600
│            hiç var olmamış olabilir.                                       │
│                                                                            │
│                [Ana sayfaya dön]   [Blog'a git]                            │ ← primary lg (link) + secondary lg (link)
│                                                                            │
└─ SiteFooter ───────────────────────────────────────────────────────────────┘
```

- HTTP durum kodu gerçekten `404` olmalı (SEO; TASK-018 kabul kriteri).
- `<title>`: "Sayfa bulunamadı — {SITE_ADI}"; `noindex`.
- Header ve footer normal görünür (ziyaretçi yolunu bulabilsin).
- "404" rakamı dekoratiftir (`aria-hidden`, gray-300 → kontrast muaf; anlam h1'dedir).

---

## 8. Sunucu hatası (500)

404 ile aynı düzen: rakam "500" yerine yok; h1 "Bir sorun oluştu", metin "Sayfa şu anda görüntülenemiyor. Lütfen biraz sonra tekrar deneyin.", butonlar "Tekrar dene" (primary, sayfayı yeniler) + "Ana sayfaya dön" (secondary). HTTP `500`/`503`.

---

## 9. İçerik türetme kuralları

Content modelinde özet ve kapak görseli alanı yok (TASK-003). Bu nedenle:

| Veri | Kaynak |
|------|--------|
| Özet (PostCard, meta description) | Gövdenin Markdown'dan arındırılmış düz metninin ilk ~160 karakteri, kelime sınırında kesilir + "…". Başlıklar, görseller, kod blokları atlanır. Üretim yeri (backend/ frontend) API sözleşmesinde netleşir |
| Kapak görseli | **Yok.** PostCard görselsiz tasarlandı; gövdedeki ilk görsel kart görseli olarak kullanılmaz |
| Tarih | Yayın tarihi (`publishedAt`); alan yoksa bkz. AÇIK SORU |
| Yazar | Görünen ad; API'de yoksa meta satırında yalnız tarih gösterilir |

---

## 10. Bileşenler

| Bileşen | Kaynak |
|---------|--------|
| SkipLink | §18 |
| SiteHeader | §25 (yeni) |
| SiteFooter | §26 (yeni) |
| PostCard (`grid`, `list`) | §27 (yeni) |
| SimplePagination | §28 (yeni) |
| Prose | §29 (yeni) |
| Button (link olarak) | §1 — 404/500 aksiyonları `<a>` |
| Link | §12 |
| EmptyState | §8 |
| Skeleton | §9 |

---

## 11. Responsive

| Kırılım | Davranış |
|---------|----------|
| < `sm` | Yatay padding 16px. Hero h1 text-4xl, açıklama text-lg, dikey padding 48px. PostCard grid tek sütun. Yazı h1 text-3xl. Prose 17px / 1.7. Pagination: "‹ Önceki" / "Sonraki ›" butonları, ortadaki "Sayfa 2 / 6" küçük metin; butonlar 44px yüksek. Footer dikey yığın |
| `sm`–`lg` | Padding 24px; PostCard grid 2 sütun |
| ≥ `lg` | Padding 32px; PostCard grid 3 sütun; içerik `max-w-site` (1152px) ortalı |
| Prose görselleri | `max-width: 100%`, `height: auto`; geniş tablolar ve kod blokları kendi içinde yatay kayar (`overflow-x-auto`), sayfa kaymaz |
| 320px / %200 zoom | Uzun slug'lı linkler ve URL'ler `overflow-wrap: anywhere` ile kırılır |

---

## 12. Erişilebilirlik ve SEO

- `<html lang="tr">`. Landmark'lar: `<header>`, `<nav aria-label="Ana menü">` (header), `<main id="main">`, `<footer>` içinde `<nav aria-label="Sayfalar">`.
- Her sayfada tek `h1`. Prose içindeki Markdown `#` başlıkları **h2'den başlar** (gövde h1 üretmez; `#` → h2'ye kaydırılır) — başlık hiyerarşisi bozulmasın.
- PostCard'da tek link başlıktadır; kartın tamamı tıklanabilir görünür (`::after` ile genişletilmiş tıklama alanı) ama erişilebilir adı yalnız başlıktır.
- Tarihler `<time datetime="2026-11-12">`.
- Gövde görselleri alt metnini Markdown'dan alır; boş alt (`![](url)`) dekoratif kabul edilir.
- Prose linkleri altı çizili; harici linklere otomatik ikon eklenmez (yazarın kontrolü).
- Pagination `<nav aria-label="Sayfalama">`; "Sayfa 2 / 6" metni `aria-current` yerine sayfa başlığıyla bağlam verir.
- Kontrast: gövde gray-900/gray-0 17.9:1; meta gray-600/gray-0 7.6:1; footer metni gray-600/gray-50 ~7.2:1; link brand-600 6.3:1.
- Odak: standart focus ring; skip link ilk odak.
- **SEO:** Her sayfada `<title>` ve `meta description` (yazı/sayfa: özet; liste/ana sayfa: `{SITE_ACIKLAMASI}`), kanonik URL, `og:title` / `og:description`. 404 ve 500 `noindex`.
- **Performans:** Sayfalar sunucuda render edilir; Inter `next/font` ile self-host (tokens.md §2.1). Prose görselleri `loading="lazy"`, ilk ekrandaki yoksa.
