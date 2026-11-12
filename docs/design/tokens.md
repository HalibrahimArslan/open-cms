# Design Token'ları

> Sahibi: designer · Görev: TASK-001 · Tema: yalnızca light (dark tema MVP dışı)
>
> Bu dosya admin paneli **ve** public site için tek kaynaktır. Frontend bu değerleri `tailwind.config` içine aynen taşır. Token adları Tailwind anahtarlarıyla birebir eşleşecek şekilde seçildi (ör. `colors.brand.600` → `bg-brand-600`).
>
> Kural: Bileşenlerde ham hex kullanılmaz; her zaman token adı kullanılır. Yeni bir değere ihtiyaç olursa önce bu dosyaya eklenir.

---

## 1. Renkler

### 1.1 Marka (`brand`) — indigo

| Token | Hex | Kullanım |
|-------|-----|----------|
| `brand-50` | `#EEF2FF` | Seçili satır / aktif menü arka planı |
| `brand-100` | `#E0E7FF` | Hover arka planı (ghost/secondary üzerinde marka vurgusu) |
| `brand-200` | `#C7D2FE` | Sürükle-bırak alanı aktif kenarlığı (dekoratif) |
| `brand-300` | `#A5B4FC` | Dekoratif |
| `brand-400` | `#818CF8` | Dekoratif (metin için **kullanılmaz**) |
| `brand-500` | `#6366F1` | Dekoratif, ilerleme çubuğu dolgusu (metin için **kullanılmaz**) |
| `brand-600` | `#4F46E5` | **Ana marka rengi**: primary buton, link, focus ring |
| `brand-700` | `#4338CA` | Primary buton hover, link hover, aktif menü metni |
| `brand-800` | `#3730A3` | Primary buton active (basılı) |
| `brand-900` | `#312E81` | Koyu vurgu (public site header'da isteğe bağlı) |

### 1.2 Nötr (`gray`) — slate tabanlı

| Token | Hex | Kullanım |
|-------|-----|----------|
| `gray-0` | `#FFFFFF` | Yüzey (kart, modal, input arka planı) |
| `gray-50` | `#F8FAFC` | Uygulama arka planı (admin içerik alanı), tablo zebra |
| `gray-100` | `#F1F5F9` | Tablo başlığı arka planı, disabled arka plan, taslak badge |
| `gray-200` | `#E2E8F0` | Ayırıcı çizgi, kart kenarlığı, tablo satır çizgisi (dekoratif) |
| `gray-300` | `#CBD5E1` | Disabled kenarlık, skeleton parlaması |
| `gray-400` | `#94A3B8` | Disabled metin (kontrast muafiyeti), dekoratif ikon |
| `gray-500` | `#64748B` | **Form kontrol kenarlığı**, placeholder, ikincil ikon |
| `gray-600` | `#475569` | İkincil metin (yardım metni, meta bilgi, tarih) |
| `gray-700` | `#334155` | Etiket metni, secondary buton metni |
| `gray-800` | `#1E293B` | Admin sidebar arka planı |
| `gray-900` | `#0F172A` | **Ana metin rengi**, başlıklar |

### 1.3 Semantik

Her semantik renk 4 tonla gelir: `-50` (yumuşak arka plan), `-200` (kenarlık), `-600` (ikon / solid dolgu), `-700` (yumuşak arka plan üstünde metin).

| Rol | `-50` (bg) | `-200` (border) | `-600` (icon/solid) | `-700` (text) |
|-----|-----------|-----------------|---------------------|---------------|
| `success` | `#F0FDF4` | `#BBF7D0` | `#16A34A` | `#15803D` |
| `warning` | `#FFFBEB` | `#FDE68A` | `#D97706` | `#92400E` |
| `error` | `#FEF2F2` | `#FECACA` | `#DC2626` | `#B91C1C` |
| `info` | `#EFF6FF` | `#BFDBFE` | `#2563EB` | `#1D4ED8` |

Notlar:
- `warning-700` bilinçli olarak amber-800 (`#92400E`) seçildi; amber-700 açık arka planda sınırda kalıyor.
- `success-600` (`#16A34A`) üzerine beyaz metin **AA'yı geçmez** (≈3.3:1). Yeşil solid buton gerekiyorsa `success-700` kullanılır.
- Danger buton dolgusu `error-600`, hover `error-700`.

### 1.4 İçerik durumu (badge)

| Durum | Token | Metin | Arka plan | Kenarlık | Kontrast |
|-------|-------|-------|-----------|----------|----------|
| Taslak (`draft`) | `status-draft` | `#334155` (gray-700) | `#F1F5F9` (gray-100) | `#CBD5E1` (gray-300) | 9.4:1 |
| Yayında (`published`) | `status-published` | `#166534` | `#DCFCE7` | `#86EFAC` | 6.5:1 |

Badge'de renk tek başına anlam taşımaz; her zaman metin etiketi ("Taslak" / "Yayında") ve önünde durum noktası (●) bulunur.

### 1.5 Fonksiyonel takma adlar (alias)

Bileşen dokümanları bu adları kullanır. Tailwind'de `colors` altına ayrıca tanımlanabilir veya doğrudan karşılığı kullanılabilir.

| Alias | Değer | Açıklama |
|-------|-------|----------|
| `bg-app` | gray-50 | Admin sayfa arka planı |
| `bg-surface` | gray-0 | Kart, modal, tablo, input |
| `bg-subtle` | gray-100 | Tablo başlığı, disabled |
| `text-primary` | gray-900 | Ana metin |
| `text-secondary` | gray-600 | Yardım metni, meta |
| `text-disabled` | gray-400 | Disabled metin |
| `text-inverse` | gray-0 | Koyu/solid zemin üstü metin |
| `text-link` | brand-600 (hover brand-700) | Link |
| `border-default` | gray-200 | Kart, ayırıcı (dekoratif) |
| `border-control` | gray-500 | Input/select/checkbox kenarlığı (3:1 kuralı için) |
| `border-strong` | gray-700 | Hover'daki form kontrol kenarlığı |
| `focus-ring` | brand-600 | Tüm odaklanabilir öğeler |
| `overlay` | `rgba(15, 23, 42, 0.5)` | Modal arkası (gray-900 %50) |

### 1.6 Onaylı metin / arka plan çiftleri (WCAG AA)

AA eşiği: normal metin **4.5:1**, büyük metin (≥24px veya ≥18.66px kalın) ve UI bileşen sınırları / ikonlar **3:1**. Aşağıdaki oranlar sRGB göreli parlaklık formülüyle hesaplandı (yaklaşık değerler).

**Normal metin için onaylı çiftler (≥4.5:1):**

| Metin | Arka plan | Oran | Nerede |
|-------|-----------|------|--------|
| gray-900 | gray-0 | 17.9:1 | Ana metin |
| gray-900 | gray-50 | 17.1:1 | Admin içerik alanı |
| gray-700 | gray-0 / gray-50 / gray-100 | 10.4 / 9.9 / 9.4:1 | Etiket, tablo başlığı |
| gray-600 | gray-0 | 7.6:1 | Yardım metni |
| gray-600 | gray-100 | 6.9:1 | Tablo başlığı ikincil metin |
| gray-500 | gray-0 | 4.8:1 | Placeholder (yalnızca beyaz zeminde) |
| gray-500 | gray-50 | 4.55:1 | Sınırda; yalnızca placeholder. Meta bilgi için gray-600 kullan |
| gray-0 | brand-600 | 6.3:1 | Primary buton |
| gray-0 | brand-700 | 7.9:1 | Primary buton hover |
| gray-0 | error-600 | 4.8:1 | Danger buton |
| gray-0 | error-700 | 6.5:1 | Danger buton hover |
| gray-0 | gray-800 | 14.6:1 | Sidebar metni |
| gray-300 | gray-800 | 9.9:1 | Sidebar ikincil metin |
| brand-600 | gray-0 | 6.3:1 | Link |
| brand-700 | brand-50 | 7.1:1 | Aktif menü / seçili öğe |
| success-700 | success-50 | 4.8:1 | Başarı alert/toast |
| warning-700 | warning-50 | 6.8:1 | Uyarı alert/toast |
| error-700 | error-50 | 5.9:1 | Hata alert/toast |
| error-700 | gray-0 | 6.5:1 | Form alanı hata mesajı |
| info-700 | info-50 | 6.2:1 | Bilgi alert/toast |
| `#166534` | `#DCFCE7` | 6.5:1 | Yayında badge |
| gray-700 | gray-100 | 9.4:1 | Taslak badge |
| gray-600 | gray-50 | 7.2:1 | Public footer metni, login yardım metni (TASK-004/016) |
| brand-700 | brand-100 | 6.4:1 | UserMenu avatar baş harfleri (TASK-004) |
| gray-0 | gray-700 | 10.4:1 | Sidebar menü öğesi hover (TASK-004) |
| gray-50 | gray-900 | 17.1:1 | Public kod bloğu (TASK-016) |

**Yasaklı çiftler (normal metinde kullanılmaz):**

| Metin | Arka plan | Oran | Neden |
|-------|-----------|------|-------|
| gray-500 | gray-100 | 4.3:1 | AA altı → gray-600 kullan |
| gray-400 | herhangi açık zemin | ≤2.6:1 | Yalnızca disabled (muaf) / dekoratif |
| brand-500 | gray-0 | 4.47:1 | Eşiğin hemen altı; metin için brand-600+ |
| gray-0 | success-600 | 3.3:1 | Solid yeşil zeminde success-700 kullan |
| gray-0 | warning-600 | 3.2:1 | Uyarı rengi solid zeminde metin taşımaz |

**UI bileşen / ikon (≥3:1):**

| Öğe | Renk | Zemin | Oran |
|-----|------|-------|------|
| Form kontrol kenarlığı | gray-500 | gray-0 | 4.8:1 |
| Focus ring | brand-600 | gray-0 / gray-50 | 6.3 / 6.0:1 |
| Focus ring (sidebar) | brand-300 | gray-800 | ≈7.0:1 |
| Uyarı ikonu | warning-600 | gray-0 / warning-50 | 3.2 / 3.1:1 |
| Hata ikonu | error-600 | gray-0 | 4.8:1 |
| Başarı ikonu | success-600 | gray-0 | 3.3:1 |
| Bilgi ikonu | info-600 | gray-0 | 5.2:1 |

`gray-200` kenarlıklar (kart, tablo çizgisi) dekoratiftir; bilgi taşıyan sınır olarak kullanılmaz.

---

## 2. Tipografi

### 2.1 Font aileleri

| Token | Değer | Kullanım |
|-------|-------|----------|
| `font-sans` | `"Inter", ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif` | Tüm UI ve public site |
| `font-mono` | `"JetBrains Mono", ui-monospace, SFMono-Regular, Menlo, Consolas, monospace` | Markdown editörü, slug alanı, kod blokları |

- Inter `next/font` ile self-host edilir; `latin` + `latin-ext` alt kümeleri zorunlu (Türkçe karakterler: ç ğ ı İ ö ş ü).
- `font-display: swap`.

### 2.2 Boyut skalası (font-size / line-height)

| Token | Boyut | Satır yüksekliği | Kullanım |
|-------|-------|------------------|----------|
| `text-xs` | 12px / 0.75rem | 16px / 1rem | Badge, tablo meta, toast zaman damgası |
| `text-sm` | 14px / 0.875rem | 20px / 1.25rem | **Admin varsayılan gövde**, form etiketi, tablo hücresi, buton |
| `text-base` | 16px / 1rem | 24px / 1.5rem | Input içi metin, public site arayüz metni |
| `text-lg` | 18px / 1.125rem | 28px / 1.75rem | Modal başlığı, kart başlığı |
| `text-xl` | 20px / 1.25rem | 28px / 1.75rem | Bölüm başlığı (admin) |
| `text-2xl` | 24px / 1.5rem | 32px / 2rem | Admin sayfa başlığı (H1) |
| `text-3xl` | 30px / 1.875rem | 36px / 2.25rem | Public H2 |
| `text-4xl` | 36px / 2.25rem | 40px / 2.5rem | Public yazı başlığı (H1, mobil üstü) |
| `text-5xl` | 48px / 3rem | 52px / 3.25rem | Public ana sayfa hero |

Public site yazı gövdesi (`prose`): **18px / 1.75 (32px)**, maksimum genişlik 70ch (`max-w-prose-lg`, bkz. 6). Mobilde 17px / 1.7.

Input metni **en az 16px** (iOS Safari'nin otomatik zoom yapmasını önler).

### 2.3 Ağırlıklar

| Token | Değer | Kullanım |
|-------|-------|----------|
| `font-normal` | 400 | Gövde metni |
| `font-medium` | 500 | Buton, etiket, tablo başlığı, badge |
| `font-semibold` | 600 | Başlıklar (H1–H3), modal başlığı |
| `font-bold` | 700 | Yalnızca public hero / logo |

### 2.4 Diğer

| Token | Değer |
|-------|-------|
| `tracking-tight` | -0.015em (≥ text-2xl başlıklar) |
| `tracking-normal` | 0 |
| `tracking-wide` | 0.025em (büyük harfli tablo başlığı kullanılırsa) |

---

## 3. Spacing skalası

Taban birim **4px**. Tailwind varsayılan skalası ile birebir uyumlu; ek tanım gerekmez.

| Token | px | rem | Tipik kullanım |
|-------|----|-----|----------------|
| `0` | 0 | 0 | — |
| `0.5` | 2 | 0.125 | Focus ring offset |
| `1` | 4 | 0.25 | İkon–metin arası (sıkı) |
| `1.5` | 6 | 0.375 | Etiket ile input arası |
| `2` | 8 | 0.5 | Buton içi ikon–metin, badge yatay padding |
| `3` | 12 | 0.75 | Buton yatay padding (sm), tablo hücre dikey padding |
| `4` | 16 | 1 | Buton yatay padding (md), kart iç boşluğu (mobil), form alanları arası |
| `5` | 20 | 1.25 | — |
| `6` | 24 | 1.5 | Kart / modal iç boşluğu, form bölümleri arası |
| `8` | 32 | 2 | Sayfa başlığı ile içerik arası |
| `10` | 40 | 2.5 | — |
| `12` | 48 | 3 | Public site bölüm arası (mobil) |
| `16` | 64 | 4 | Public site bölüm arası (masaüstü) |
| `20` | 80 | 5 | Hero dikey boşluk |
| `24` | 96 | 6 | — |

### Kontrol yükseklikleri

| Token | Değer | Kullanım |
|-------|-------|----------|
| `h-control-sm` | 32px | Tablo içi aksiyon butonu, filtre |
| `h-control-md` | 40px | **Varsayılan** buton / input / select |
| `h-control-lg` | 48px | Login butonu, public site CTA |

Dokunmatik hedef: mobilde (< `md`) tıklanabilir alan en az **44×44px** olmalı; `sm` boyutlu butonlar mobilde görünmez padding ile genişletilir.

---

## 4. Radius

| Token | Değer | Kullanım |
|-------|-------|----------|
| `rounded-none` | 0 | — |
| `rounded-sm` | 4px | Checkbox, küçük etiketler, kod satır içi |
| `rounded-md` | 6px | **Buton, input, select, textarea** |
| `rounded-lg` | 8px | Kart, tablo kapsayıcısı, toast, dropdown |
| `rounded-xl` | 12px | Modal, medya grid kartı, public kart |
| `rounded-full` | 9999px | Badge (pill), avatar, spinner |

---

## 5. Gölge (elevation)

| Token | Değer | Kullanım |
|-------|-------|----------|
| `shadow-none` | none | Düz kart (kenarlıkla) |
| `shadow-sm` | `0 1px 2px 0 rgba(15, 23, 42, 0.06)` | Buton (secondary), input |
| `shadow-md` | `0 4px 8px -2px rgba(15, 23, 42, 0.10), 0 2px 4px -2px rgba(15, 23, 42, 0.06)` | Kart hover, dropdown |
| `shadow-lg` | `0 12px 24px -4px rgba(15, 23, 42, 0.12), 0 4px 8px -4px rgba(15, 23, 42, 0.06)` | Toast, popover |
| `shadow-xl` | `0 24px 48px -12px rgba(15, 23, 42, 0.25)` | Modal |

### Focus ring

Tek bir focus stili tüm projede kullanılır:

- `outline: 2px solid brand-600` + `outline-offset: 2px`
- Tailwind karşılığı: `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-600 focus-visible:ring-offset-2 focus-visible:ring-offset-white`
- Koyu zeminde (sidebar `gray-800`): ring `brand-300`, offset rengi `gray-800`.
- Yalnızca `:focus-visible` ile gösterilir; fare tıklamasında gösterilmez. Odak halkası **asla** kaldırılmaz.

---

## 6. Layout ve breakpoint'ler

### 6.1 Breakpoint'ler (Tailwind varsayılanı, mobile-first)

| Token | Min genişlik | Hedef |
|-------|-------------|-------|
| (taban) | 0 | Mobil (≥ 320px desteklenir) |
| `sm` | 640px | Büyük telefon |
| `md` | 768px | Tablet — admin sidebar kalıcı olur |
| `lg` | 1024px | Küçük laptop |
| `xl` | 1280px | Masaüstü |
| `2xl` | 1536px | Geniş ekran |

### 6.2 Genişlikler

| Token | Değer | Kullanım |
|-------|-------|----------|
| `w-sidebar` | 256px (16rem) | Admin sidebar (`md` ve üstü) |
| `w-sidebar-collapsed` | 72px | Daraltılmış sidebar (isteğe bağlı, `md`–`lg`) |
| `h-topbar` | 64px | Admin üst bar / public header |
| `max-w-admin` | 1280px | Admin içerik alanı maksimum |
| `max-w-site` | 1152px (72rem) | Public site kapsayıcı |
| `max-w-prose-lg` | 70ch (~720px) | Public yazı gövdesi |
| `max-w-form` | 768px | Admin içerik formu |
| `max-w-auth` | 400px | Login kartı |
| Modal `sm` / `md` / `lg` | 400 / 560 / 800px | Onay / form / medya seçici |

Sayfa yatay padding: mobil 16px (`px-4`), `md` 24px (`px-6`), `lg` 32px (`px-8`).

---

## 7. Z-index

| Token | Değer | Kullanım |
|-------|-------|----------|
| `z-base` | 0 | — |
| `z-sticky` | 10 | Yapışkan tablo başlığı, form aksiyon çubuğu |
| `z-header` | 20 | Topbar |
| `z-sidebar` | 30 | Mobil çekmece sidebar |
| `z-dropdown` | 40 | Dropdown, popover |
| `z-overlay` | 50 | Modal arka planı + modal |
| `z-toast` | 60 | Toast (modalın da üstünde) |

---

## 8. Hareket (motion)

| Token | Değer | Kullanım |
|-------|-------|----------|
| `duration-fast` | 120ms | Hover, renk geçişi |
| `duration-base` | 200ms | Modal/toast giriş, dropdown |
| `duration-slow` | 300ms | Sidebar çekmece |
| `ease-standard` | `cubic-bezier(0.2, 0, 0, 1)` | Varsayılan |
| `ease-exit` | `cubic-bezier(0.4, 0, 1, 1)` | Çıkış animasyonları |

`prefers-reduced-motion: reduce` aktifse tüm geçişler 0ms'ye iner; spinner dönmeye devam edebilir ama skeleton parlaması (shimmer) kapatılır.

---

## 9. Tailwind eşleme özeti (frontend için)

| Tailwind anahtarı | Bu dosyadaki bölüm | Not |
|-------------------|--------------------|-----|
| `theme.extend.colors.brand` | 1.1 | 50–900 |
| `theme.extend.colors.gray` | 1.2 | Tailwind `gray`'in **yerine** geçer (`0` anahtarı eklenir) |
| `theme.extend.colors.success/warning/error/info` | 1.3 | 50, 200, 600, 700 |
| `theme.extend.colors.status.draft/published` | 1.4 | `fg`, `bg`, `border` alt anahtarları |
| `theme.fontFamily.sans/mono` | 2.1 | |
| `theme.fontSize` | 2.2 | `[size, lineHeight]` çiftleri |
| `theme.spacing` | 3 | Tailwind varsayılanı yeterli |
| `theme.extend.height` | 3 (kontrol yükseklikleri) | `control-sm/md/lg` |
| `theme.borderRadius` | 4 | `md` = 6px (Tailwind varsayılanıyla aynı) |
| `theme.boxShadow` | 5 | |
| `theme.screens` | 6.1 | Tailwind varsayılanı |
| `theme.extend.maxWidth` | 6.2 | `admin`, `site`, `prose-lg`, `form`, `auth` |
| `theme.extend.zIndex` | 7 | |
| `theme.extend.transitionDuration/TimingFunction` | 8 | |
| Prose (yazı gövdesi) | 2.2 | `@tailwindcss/typography` önerilir; renkler `gray-900`/`brand-600`'e ayarlanır |
