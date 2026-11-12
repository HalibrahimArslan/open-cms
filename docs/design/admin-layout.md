# Ekran: Admin Layout (kabuk)

> Sahibi: designer · Görev: TASK-004 · Rotalar: `/admin/*`
>
> Bağımlılıklar: `tokens.md`, `components.md` (Sidebar, Topbar, UserMenu, DropdownMenu, SkipLink — §14–§18 bu görevde eklendi), `login.md`.
> API: `GET /api/auth/me`, `POST /api/auth/logout` (TASK-005).

---

## 1. Amaç

Tüm admin ekranlarını (içerik, medya) saran ortak kabuk: gezinme, kullanıcı bilgisi, çıkış, oturum ve yetki kontrolü. İçerik ekranları (TASK-008) ve medya (TASK-012, `media.md`) bu kabuğun `main` alanına yerleşir.

## 2. Kullanıcı akışları

### 2.1 Kabuğun açılışı

```
/admin/* isteği
   │
   ├─ GET /api/auth/me
   │     ├─ 200 → kullanıcı + rol alınır → menü role göre çizilir → sayfa içeriği yüklenir
   │     ├─ 401 → /login?next=<yol>            (oturumsuz erişim; mesaj yok)
   │     └─ ağ/5xx → tam sayfa hata durumu (§5)
   │
   └─ /admin (kök) → /admin/content'e yönlendirilir (MVP'de pano/dashboard yok)
```

- Oturum kontrolü mümkünse **sunucu tarafında** (Next.js middleware / server component) yapılır; böylece oturumsuz kullanıcı korumalı sayfanın iskeletini bile görmez.
- Panel içinde herhangi bir API çağrısı `401` dönerse: `/login?next=<mevcut yol>&reason=expired` (bkz. `login.md` §2.3).

### 2.2 Yetkisiz erişim (403)

İki farklı durum vardır:

| Durum | Örnek | Davranış |
|-------|-------|----------|
| **Sayfa** düzeyinde yetkisiz | Author, başkasına ait bir içeriğin düzenleme URL'sini doğrudan açar; API `403` döner | Kabuk (sidebar/topbar) kalır, `main` alanında **403 durumu** (§3.4). URL değişmez. Menüde aktif öğe, URL'nin ait olduğu bölümdür |
| **Aksiyon** düzeyinde yetkisiz | Sayfa açık, ama bir buton aksiyonu `403` döner (ör. rol arada değişti) | `error` Toast: "Bu işlem için yetkiniz yok." Sayfa yerinde kalır. Form ekranlarında Toast yerine formun üstündeki `error` Alert kullanılır (FormField kuralı) |

Kural: Kullanıcının yetkisi olmayan aksiyonların butonları **hiç gösterilmez** veya disabled + açıklama ile gösterilir (hangisi olduğu ekran dokümanında belirtilir). 403 durumu yalnızca doğrudan URL veya yarış durumları için güvenlik ağıdır.

### 2.3 Bulunamadı (404, admin içi)

Var olmayan bir admin yolu veya silinmiş içerik ID'si: kabuk kalır, `main`'de EmptyState `error` varyantı: "Sayfa bulunamadı" + "İçeriklere dön". (Public 404'ten ayrıdır; bkz. `public-site.md`.)

### 2.4 Çıkış

1. Topbar → UserMenu → "Çıkış yap".
2. Menü öğesi loading olmaz; tıklanınca `POST /api/auth/logout` gönderilir ve hemen `/login?reason=logged_out`'a gidilir.
3. Logout isteği hata verse bile istemci oturum durumu temizlenir ve login'e gidilir (kullanıcı "çıkamadım" durumunda kalmaz).

### 2.5 Mobil gezinme

Hamburger → çekmece (drawer) açılır → bir menü öğesi seçilir → çekmece kapanır, sayfa değişir, odak yeni sayfanın `h1`'ine taşınır.

---

## 3. Yerleşim

### 3.1 Masaüstü (≥ `md`)

```
┌──────────────┬─────────────────────────────────────────────────────────────┐
│ ◆ CMS        │                                 Siteyi görüntüle ↗   (AY) ▾ │ ← Topbar 64px, bg-surface,
│              │                                                  Ayşe Yılmaz│   alt kenarlık border-default
├──────────────┼─────────────────────────────────────────────────────────────┤
│              │                                                             │
│ ▣ İçerikler  │  İçerikler                                   [+ Yeni içerik]│ ← sayfa başlığı (ekrana ait)
│   (aktif)    │                                                             │
│ ▢ Medya      │  ┌───────────────────────────────────────────────────────┐  │
│              │  │                                                       │  │
│              │  │            sayfa içeriği (main)                       │  │
│              │  │            max-w-admin, bg-app                        │  │
│              │  │                                                       │  │
│              │  └───────────────────────────────────────────────────────┘  │
│              │                                                             │
│              │                                                             │
│──────────────│                                                             │
│ Ayşe Yılmaz  │                                                             │
│ [Editör]     │                                                             │
└──────────────┴─────────────────────────────────────────────────────────────┘
  Sidebar 256px, gray-800, tam yükseklik, sabit (sayfa kayarken yerinde kalır)
```

| Bölge | Değer |
|-------|-------|
| Sidebar | `w-sidebar` 256px, bg gray-800, `position: sticky; top: 0; height: 100vh`, kendi içinde kayar |
| Sidebar üst (marka) | 64px yükseklik (topbar ile hizalı), padding 0 16px, ürün adı text-lg/semibold gray-0; `/admin`'e link |
| Menü | Üstten 8px; öğeler 40px yükseklik, 8px yatay iç kenar boşluğu, öğeler arası 4px |
| Sidebar alt | Kullanıcı adı (text-sm gray-0) + rol badge (`info`) — salt bilgi; aksiyonlar UserMenu'de |
| Topbar | `h-topbar` 64px, bg-surface, alt 1px border-default, `position: sticky; top: 0; z-header`; padding yatay sayfa padding'iyle aynı |
| Main | bg-app, padding: `md` 24px, `lg` 32px; içerik `max-w-admin` (1280px), sola yaslı |
| Sayfa başlığı satırı | Ekrana aittir ama kalıbı ortaktır: `h1` text-2xl/semibold solda, birincil aksiyon sağda; altında 32px (`8`) boşluk |

Sayfa başlığı topbar'da değil `main` içinde durur (her ekranın tek `h1`'i).

### 3.2 Mobil (< `md`)

```
┌──────────────────────────────┐        ┌───────────────────────┬──────┐
│ ☰  ◆ CMS              (AY) ▾ │        │ ◆ CMS             [X] │░░░░░░│
├──────────────────────────────┤        │                       │░░░░░░│
│                              │        │ ▣ İçerikler           │░░░░░░│
│ İçerikler                    │  ☰ ──▶ │ ▢ Medya               │░░░░░░│
│ [+ Yeni içerik]              │        │                       │░░░░░░│
│                              │        │ ───────────────────── │░░░░░░│
│ (içerik)                     │        │ Siteyi görüntüle ↗    │░░░░░░│
│                              │        │                       │░░░░░░│
│                              │        │ Ayşe Yılmaz [Editör]  │░░░░░░│
└──────────────────────────────┘        └───────────────────────┴──────┘
                                          drawer 280px (maks %85)  overlay
```

- Topbar: solda hamburger (`ghost` icon-only, 44×44 dokunma alanı), yanında ürün adı; sağda UserMenu tetikleyicisi yalnız avatar (isim gizli).
- "Siteyi görüntüle" topbar'dan kalkar, çekmecenin menü listesinin altına taşınır.
- Sayfa başlığı satırı: `h1` üstte, birincil aksiyon altında tam genişlik değil, sola yaslı `md` buton.
- Main padding 16px.

### 3.3 Menü öğesi

```
 ┌─────────────────────────────┐
 │ ▣  İçerikler                │   aktif: bg brand-50, metin + ikon brand-700, font-medium
 └─────────────────────────────┘
   ▢  Medya                        pasif: metin gray-300, ikon gray-400; hover bg gray-700 + metin gray-0
```

- İkon 20px (Lucide: `FileText` İçerikler, `Image` Medya, `ExternalLink` Siteyi görüntüle).
- Aktiflik ön ek eşleşmesiyle belirlenir: `/admin/content/*` → İçerikler, `/admin/media/*` → Medya.

### 3.4 403 ve tam sayfa hata durumları (main içinde)

```
                 ┌────────┐
                 │  (🔒)  │                ← EmptyState error: bg error-50, ikon Lock error-600
                 └────────┘
          Bu sayfaya erişim yetkiniz yok     ← h1 (sayfanın başlığı olur), text-lg/semibold
     Bu içerik başka bir kullanıcıya ait veya  ← text-sm gray-600
     rolünüz bu işlem için yeterli değil.
             [İçeriklere dön]                ← secondary; bölümün listesine link
```

- 403 sayfasında `<title>`: "Erişim yok — CMS".
- Metin hangi rolün gerektiğini söylemez (bilgi sızıntısını sınırlamak için) ama ne yapılabileceğini söyler: "Erişim gerekiyorsa site yöneticinize başvurun." (yalnız author/editor için; admin 403 almaz).

---

## 4. Rol bazlı menü görünürlüğü

| Menü öğesi | Rota | admin | editor | author | Not |
|------------|------|:-----:|:------:|:------:|-----|
| İçerikler | `/admin/content` | ✓ | ✓ | ✓ | Author listede yalnız kendi içeriklerini görür (TASK-009 kuralı; liste davranışı TASK-008'de) |
| Medya | `/admin/media` | ✓ | ✓ | ✓ | Rol bazlı aksiyon farkları `media.md` §4'te (varsayım, bkz. AÇIK SORU) |
| Siteyi görüntüle ↗ | `/` (yeni sekme) | ✓ | ✓ | ✓ | Harici link |

Notlar:
- **Kullanıcı yönetimi** ekranı MVP'de yok (Açık karar #4). Menüde yer tutucu, disabled öğe veya "Yakında" etiketi **konmaz**. Karar "evet" olursa yalnız `admin` rolüne görünen "Kullanıcılar" öğesi (ikon `Users`) Medya'nın altına eklenecek; menü yapısı buna hazırdır (yalnız admin öğeleri listenin sonunda, ayırıcı çizgiyle).
- MVP'de üç rolün menüsü aynıdır; rol farkı **aksiyon** düzeyindedir (yayınla, başkasının içeriğini düzenle/sil). Yine de frontend menüyü rol → öğe tablosundan üretmelidir; görünürlük yalnız arayüz kolaylığıdır, gerçek yetki API'dedir.
- Rol adlarının Türkçe karşılıkları (badge ve UserMenu'de): `admin` → "Yönetici", `editor` → "Editör", `author` → "Yazar".

---

## 5. Bileşenler ve durumlar

| Bileşen | Kaynak |
|---------|--------|
| SkipLink | components.md §18 (yeni) |
| Sidebar (+ mobil drawer) | §14 (yeni) |
| Topbar | §15 (yeni) |
| UserMenu | §16 (yeni) — DropdownMenu §17 üzerine kurulu |
| Badge `info` | §6 (rol) |
| EmptyState `error` | §8 (403 / 404 / yükleme hatası) |
| Spinner `lg` | §9 (ilk yükleme) |
| Toast | §11 (aksiyon 403) |

### Kabuk durumları

| Durum | Görünüm | Davranış |
|-------|---------|----------|
| İlk yükleme (oturum kontrolü) | Sunucu tarafında kontrol ediliyorsa durum yok. İstemcide yapılıyorsa: `bg-app` tam sayfa, ortada Spinner `lg` (300ms gecikmeli) | Sidebar/topbar kullanıcı bilinmeden çizilmez (yanlış menü yanıp sönmesin) |
| Hazır | §3 | Sayfa içeriği kendi yükleniyor durumunu yönetir (Skeleton) |
| Oturum kontrolü başarısız (ağ/5xx) | Kabuksuz tam sayfa EmptyState `error`: "Panel yüklenemedi" / "Sunucuya ulaşılamadı. Bağlantınızı kontrol edip tekrar deneyin." + primary "Tekrar dene" | "Tekrar dene" `GET /me`'yi yeniden çağırır |
| Oturumsuz | — | `/login?next=…` yönlendirmesi |
| Oturum süresi doldu | — | `/login?next=…&reason=expired` |
| 403 sayfa | §3.4 | — |
| 404 admin | §2.3 | — |
| Çevrimdışı (opsiyonel, MVP dışı) | — | Uygulanmaz |

---

## 6. Responsive

| Kırılım | Sidebar | Topbar | Main padding |
|---------|---------|--------|--------------|
| < `md` | Gizli; hamburger ile soldan drawer (280px, maks %85 genişlik), overlay `overlay` rengi, `z-sidebar`, `duration-slow` kayma | Hamburger + ürün adı + avatar | 16px |
| `md`–`lg` | Kalıcı, 256px | "Siteyi görüntüle" + avatar + ad | 24px |
| ≥ `lg` | Kalıcı, 256px | Aynı | 32px |

- Daraltılmış sidebar (`w-sidebar-collapsed`) MVP'de **kullanılmaz** (iki menü öğesi için gereksiz karmaşıklık).
- Drawer açıkken body scroll kilitli. Pencere `md` üstüne büyütülürse drawer otomatik kapanır.

---

## 7. Erişilebilirlik

- **Landmark'lar:** `<header>` (topbar, banner), `<nav aria-label="Ana menü">` (sidebar), `<main id="main" tabindex="-1">`.
- **SkipLink:** Sayfadaki ilk odaklanabilir öğe "İçeriğe atla" → `#main`.
- **Aktif menü:** `aria-current="page"`; renk dışında `font-medium` ve arka plan farkı ile de belirtilir.
- **Sayfa değişimi (istemci yönlendirmesi):** Odak yeni sayfanın `h1`'ine taşınır; `document.title` güncellenir ("İçerikler — CMS"). Next.js route announcer korunur.
- **Drawer:** Hamburger `aria-expanded`, `aria-controls="mobile-nav"`, `aria-label="Menüyü aç"`. Drawer `role="dialog"`, `aria-modal="true"`, `aria-label="Ana menü"`; açılınca odak ilk menü öğesine; focus trap; Escape ve kapat (X, `aria-label="Menüyü kapat"`) kapatır; kapanınca odak hamburger'a döner.
- **Sidebar odak:** Koyu zeminde focus ring `brand-300`, offset rengi gray-800 (tokens.md §5).
- **Kontrast:** Pasif menü metni gray-300/gray-800 9.9:1; aktif brand-700/brand-50 7.1:1; hover gray-0/gray-700 ≈10.4:1.
- **Klavye:** Menü öğeleri sıradan linklerdir (Tab ile gezilir; ok tuşu yönetimi gerekmez). UserMenu, DropdownMenu klavye modelini izler (§17).
