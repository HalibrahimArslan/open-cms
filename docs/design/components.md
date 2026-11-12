# Bileşen Kataloğu

> Sahibi: designer · Görev: TASK-001
>
> Tüm değerler `docs/design/tokens.md` içindeki token adlarıyla verilir. Ekran tasarımları (TASK-004/008/012/016) yalnızca bu bileşenleri kullanır; yeni bileşen gerekirse önce buraya eklenir.

## Genel kurallar (tüm bileşenler)

- **Focus:** Odaklanabilir her öğe `:focus-visible`'da standart focus ring'i gösterir (tokens.md §5). Ring asla kaldırılmaz.
- **Disabled:** Görsel olarak `opacity` yerine açık token'lar kullanılır (`bg-subtle`, `text-disabled`, `border gray-300`); `cursor: not-allowed`. Disabled öğeler kontrast kuralından muaftır ama yine de okunabilir olmalıdır.
- **Yükleniyor:** Aksiyon sürerken bileşen genişliği değişmez (layout shift yok); `aria-busy="true"` verilir.
- **Renk tek başına anlam taşımaz:** Hata, durum ve başarı mesajları her zaman metin + ikonla verilir.
- **Dil:** Tüm UI metinleri Türkçe; `<html lang="tr">`. Büyük harf dönüşümü (`uppercase`) Türkçe'de "i→İ" sorununa yol açtığı için kullanılmaz.
- **İkon seti:** Lucide (outline, 1.5px stroke). Boyutlar: 16px (`sm` kontrol, tablo), 20px (varsayılan), 24px (boş durum dışında büyük kullanım yok). Dekoratif ikonlara `aria-hidden="true"`; yalnız ikon içeren butonlara `aria-label`.

---

## 1. Button

### Varyantlar

| Varyant | Arka plan | Metin | Kenarlık | Hover | Active (basılı) | Kullanım |
|---------|-----------|-------|----------|-------|-----------------|----------|
| `primary` | brand-600 | gray-0 | — | bg brand-700 | bg brand-800 | Sayfadaki ana aksiyon (Kaydet, Giriş yap, Yayınla). Bir görünümde **en fazla bir** primary |
| `secondary` | gray-0 | gray-700 | 1px gray-300 + shadow-sm | bg gray-50, border gray-400 | bg gray-100 | İkincil aksiyon (İptal, Taslak olarak kaydet, Önizle) |
| `danger` | error-600 | gray-0 | — | bg error-700 | bg error-700 + inset gölge | Geri alınamaz aksiyon (Sil). Yalnızca onay modalında ve detay sayfasında |
| `ghost` | şeffaf | gray-700 | — | bg gray-100 | bg gray-200 | Tablo satırı aksiyonları, toolbar, modal kapatma (X) |
| `ghost-danger` | şeffaf | error-700 | — | bg error-50 | bg error-50 | Tablo satırındaki "Sil" (onay modalını açar) |

Not: Secondary butonun kenarlığı (gray-300) 3:1'in altındadır; buton metni ve gölge sınırı yeterince belirginleştirir — buton etiketi her zaman metindir, bu nedenle kabul edilebilir.

### Boyutlar

| Boyut | Yükseklik | Yatay padding | Font | İkon |
|-------|-----------|---------------|------|------|
| `sm` | 32px (`h-control-sm`) | 12px | text-sm / medium | 16px |
| `md` (varsayılan) | 40px (`h-control-md`) | 16px | text-sm / medium | 20px |
| `lg` | 48px (`h-control-lg`) | 20px | text-base / medium | 20px |

Radius `rounded-md`. İkon–metin arası 8px. `icon-only` varyantında kare (32/40/48px) ve `aria-label` zorunlu.

### Durumlar

| Durum | Görünüm | Davranış |
|-------|---------|----------|
| default | Yukarıdaki tablo | — |
| hover | Yukarıdaki tablo, `duration-fast` geçiş | — |
| focus-visible | Standart focus ring (brand-600, 2px, offset 2px). Danger'da da aynı ring | — |
| active | Yukarıdaki tablo | — |
| disabled | bg gray-100, metin gray-400, kenarlık gray-200 (tüm varyantlar için aynı) | `disabled` attribute; tooltip ile neden disabled olduğu açıklanabilir (ör. "Yayınlama yetkiniz yok") |
| loading | Metin yerinde kalır ama görünmez olur (`invisible`), ortada 16px spinner; renkler korunur | `aria-busy="true"`, `aria-disabled="true"`; çift tıklama engellenir. Ekran okuyucu için buton etiketi değişmez, durum toast/live region ile bildirilir |

### Erişilebilirlik

- Her zaman `<button>` (navigasyon için `<a>` — görünümü buton olsa bile).
- `type` açıkça verilir (`submit` / `button`).
- Kontrast: primary 6.3:1, danger 4.8:1, secondary/ghost 10.4:1.
- Enter ve Space ile tetiklenir (native).

---

## 2. Input, Textarea, Select

Ortak stil:

| Özellik | Değer |
|---------|-------|
| Yükseklik | 40px (input/select), textarea min 120px, dikey yeniden boyutlanabilir |
| Padding | yatay 12px; textarea dikey 8px |
| Font | text-base (16px) — iOS zoom'u önler; Markdown gövde ve slug alanında `font-mono` |
| Arka plan | gray-0 |
| Kenarlık | 1px `border-control` (gray-500) |
| Radius | rounded-md |
| Placeholder | gray-500 (yalnızca örnek; etiket yerine **asla** kullanılmaz) |

### Durumlar

| Durum | Kenarlık | Arka plan | Diğer |
|-------|----------|-----------|-------|
| default | gray-500 | gray-0 | — |
| hover | gray-700 | gray-0 | — |
| focus | brand-600 (1px) + standart focus ring | gray-0 | Input'larda `:focus` (yalnız `focus-visible` değil) ring gösterir |
| disabled | gray-300 | gray-100 | Metin gray-400; `disabled` |
| read-only | gray-200 | gray-50 | Metin gray-900; `readonly`, odaklanabilir ve kopyalanabilir |
| error | error-600 (2px görünüm için `ring-1 ring-error-600`) | gray-0 | Sağda 16px hata ikonu (error-600); altında hata mesajı (bkz. §3); `aria-invalid="true"` |
| success (opsiyonel) | Kenarlık değişmez | — | Yalnızca async doğrulamalarda (ör. "Slug kullanılabilir") yardım metni satırında success-700 metin + ikon |

### Varyant notları

- **Input öne/arka ek (adornment):** Sol ikon (ör. arama) veya ön ek metni (ör. slug alanında `/blog/`) gri (`bg-subtle`, gray-600) kutu olarak; input'un parçasıdır, etiket değildir.
- **Şifre input'u:** Sağda "Göster/Gizle" ghost icon-only buton, `aria-label="Şifreyi göster"` / `"Şifreyi gizle"`, `aria-pressed`.
- **Arama input'u:** `type="search"`, solda büyüteç ikonu, doluyken sağda temizle (X) butonu.
- **Select:** Native `<select>` kullanılır (MVP). Sağda chevron ikonu (gray-500). Özel listbox MVP dışı.
- **Textarea:** İsteğe bağlı karakter sayacı sağ altta (text-xs, gray-600); limit aşılınca error-700 ve `aria-live="polite"` ile duyurulur.

### Erişilebilirlik

- Her kontrolün görünür `<label for>`'u vardır (bkz. §3). Yalnızca arama kutusunda görünmez etiket (`sr-only`) kabul edilir.
- Kenarlık kontrastı gray-500 → 4.8:1 (≥3:1 non-text).
- `autocomplete` değerleri verilir (login: `username`/`email`, `current-password`).

---

## 3. FormField (etiket + kontrol + yardım + hata)

Tüm form kontrolleri bu sarmalayıcıyla kullanılır.

```
Başlık *                         ← label: text-sm, medium, gray-700; zorunluysa "*" (error-700) + sr-only "(zorunlu)"
┌───────────────────────────────┐
│ Hakkımızda                    │ ← kontrol (§2)
└───────────────────────────────┘
Sayfanın menüde görünen adı.     ← yardım: text-sm, gray-600
⚠ Başlık en fazla 120 karakter.  ← hata: text-sm, error-700, ikon error-600
```

| Parça | Stil | Boşluk |
|-------|------|--------|
| Etiket | text-sm / medium / gray-700 | Kontrole 6px (`1.5`) |
| Zorunlu işareti | `*` error-700, `aria-hidden`; etikete `sr-only` " (zorunlu)" eklenir; kontrolde `required` / `aria-required` | — |
| Opsiyonel işareti (alternatif) | Formların çoğu zorunluysa "(opsiyonel)" gray-600 kullanılır; bir formda yalnızca biri | — |
| Yardım metni | text-sm / gray-600 | Kontrolden 6px |
| Hata mesajı | text-sm / error-700 + 16px uyarı ikonu | Kontrolden 6px; yardım metni varsa onun **yerine** gösterilir |
| Alanlar arası | 16px (`4`); form bölümleri arası 24px (`6`) | — |

### Durumlar

- **default / focus / disabled:** Kontrolün durumunu izler; disabled'da etiket gray-600.
- **error:** Kontrol `aria-invalid="true"`, `aria-describedby` → hata mesajı id'si (yardım metni de varsa ikisi birden).
- **Doğrulama zamanı:** İlk gönderimden önce yalnızca `blur` sonrası; gönderim sonrası her değişiklikte anlık.

### Form seviyesinde hata

Gönderim başarısız olduğunda:
1. Formun üstünde `error` **Alert** (§10): "Form kaydedilemedi. 2 alanı düzeltin." + hatalı alanlara anchor linkleri.
2. Odak bu Alert'e taşınır (`tabindex="-1"`, `role="alert"`).
3. Sunucu hatası (500, ağ) da aynı Alert ile gösterilir; alan hataları (ör. "Bu slug zaten kullanılıyor") ilgili alanın altına yazılır.

---

## 4. Checkbox ve Switch (yardımcı)

Login'deki "Beni hatırla" ve tablo toplu seçimi için.

| Özellik | Checkbox | Switch |
|---------|----------|--------|
| Boyut | 16px kutu, tıklama alanı etiketle birlikte ≥ 24px | 36×20px |
| Kapalı | gray-0 bg, 1px gray-500 kenarlık, rounded-sm | gray-300 iz, beyaz tutamaç |
| Açık | brand-600 bg, beyaz tik | brand-600 iz |
| Indeterminate | brand-600 bg, beyaz çizgi | — |
| Disabled | gray-100 bg, gray-300 kenarlık | gray-200 iz |
| Focus | Standart ring | Standart ring |

Native `<input type="checkbox">`; switch için `role="switch"` + `aria-checked`. Etiket her zaman tıklanabilir.

Not: MVP'de içerik durumu (taslak/yayında) switch ile **değil**, açık metinli butonlarla değiştirilir (bkz. TASK-008).

---

## 5. Table

Admin içerik ve (liste görünümünde) medya listeleri için.

### Yapı

```
┌──────────────────────────────────────────────────────────────────────┐
│ Başlık ▲          Tip      Durum        Yazar      Güncellendi   ⋯   │ ← thead: bg-subtle, text-xs/medium, gray-700
├──────────────────────────────────────────────────────────────────────┤
│ Hakkımızda        Sayfa    ● Yayında    Ayşe K.    2 saat önce  [✎][🗑]│ ← satır: 52px, text-sm, gray-900
│ /hakkimizda                                                           │   ikinci satır: text-xs gray-600 (slug)
├──────────────────────────────────────────────────────────────────────┤
│ ...                                                                   │
└──────────────────────────────────────────────────────────────────────┘
  1–20 / 57                                        [‹ Önceki] [Sonraki ›]  ← pagination
```

| Parça | Stil |
|-------|------|
| Kapsayıcı | bg-surface, 1px border-default, rounded-lg, yatay taşmada `overflow-x-auto` |
| Başlık hücresi | bg gray-100, text-xs / medium / gray-700, padding 12px 16px, sola hizalı (sayılar sağa) |
| Gövde hücresi | text-sm / gray-900, padding 12px 16px, min satır yüksekliği 52px |
| Satır ayırıcı | 1px gray-200 |
| Satır hover | bg gray-50 |
| Seçili satır | bg brand-50 + sol 2px brand-600 iç çizgi |
| Birincil hücre | Başlık bir **link**tir (düzenleme sayfasına), gray-900 → hover brand-700 + underline |
| Aksiyon hücresi | Sağa hizalı; `ghost` / `ghost-danger` `sm` icon-only butonlar, `aria-label="'Hakkımızda' sayfasını sil"` |

### Sıralama

Sıralanabilir başlık bir `<button>` içerir; ikon: ▲/▼ (aktif, gray-700) veya ⇅ (pasif, gray-400). `<th aria-sort="ascending|descending|none">`.

### Durumlar

| Durum | Görünüm |
|-------|---------|
| loading (ilk) | Başlık satırı gerçek; gövdede 5 **Skeleton** satırı (§9) |
| loading (yeniden filtre/sayfa) | Mevcut satırlar kalır, `opacity-60`, tablo üstünde 2px brand-500 ilerleme çizgisi; `aria-busy="true"` |
| empty (hiç içerik yok) | Tablo yerine **EmptyState** (§8): "Henüz içerik yok" + primary "Yeni içerik" |
| empty (filtre sonucu yok) | Tablo başlığı kalır, gövdede tek satır EmptyState (compact): "Filtrelere uyan içerik bulunamadı" + secondary "Filtreleri temizle" |
| error | Gövde yerine `error` Alert: "İçerikler yüklenemedi." + secondary "Tekrar dene" |

### Responsive

- `md` ve üstü: tam tablo.
- `md` altı: Tablo **kart listesine** dönüşür; her satır bir kart (başlık + badge üst satır, meta alt satır, aksiyonlar sağda "⋯" menüsü). Sütun gizleme yerine bu tercih edilir.

### Erişilebilirlik

- Semantik `<table>`, `<caption class="sr-only">` (ör. "İçerik listesi").
- Satırın tamamı tıklanabilir yapılmaz; tek link başlık hücresindedir (klavye sırası öngörülebilir kalır).
- Pagination: `<nav aria-label="Sayfalama">`, mevcut sayfa `aria-current="page"`.

---

## 6. Badge

Pill şeklinde, salt bilgi; etkileşimli değildir.

| Özellik | Değer |
|---------|-------|
| Yükseklik | 22px |
| Padding | 0 8px |
| Font | text-xs / medium |
| Radius | rounded-full |
| Kenarlık | 1px (aşağıdaki tabloya göre) |
| Durum noktası | 6px daire, metnin solunda, 6px boşluk (opsiyonel; durum badge'lerinde zorunlu) |

### Varyantlar

| Varyant | Metin | Arka plan | Kenarlık | Nokta | Örnek |
|---------|-------|-----------|----------|-------|-------|
| `draft` | gray-700 | gray-100 | gray-300 | gray-500 | ● Taslak |
| `published` | `#166534` | `#DCFCE7` | `#86EFAC` | success-600 | ● Yayında |
| `neutral` | gray-700 | gray-100 | gray-300 | — | Sayfa / Blog yazısı (içerik tipi) |
| `info` | info-700 | info-50 | info-200 | — | Rol: Editör |
| `success` | success-700 | success-50 | success-200 | — | — |
| `warning` | warning-700 | warning-50 | warning-200 | — | — |
| `error` | error-700 | error-50 | error-200 | — | Yükleme başarısız |

Rol badge'leri (admin/editor/author) için MVP'de tek varyant `info` kullanılır; ayırt edici olan metindir.

### Erişilebilirlik

- Metin her zaman görünür; renk ek ipucudur.
- Tablo içinde ekran okuyucu bağlamı için sütun başlığı yeterlidir; tek başına kullanıldığında `sr-only` önek ("Durum: ").

---

## 7. Modal ve ConfirmDialog

### Modal (genel)

```
          ┌─────────────────────────────────────────┐
          │ Başlık                              [X] │ ← header: text-lg/semibold, padding 24px
          ├─────────────────────────────────────────┤
          │                                         │
          │ İçerik                                  │ ← body: text-sm, gray-700, padding 0 24px
          │                                         │
          ├─────────────────────────────────────────┤
          │                    [İptal]  [Kaydet]    │ ← footer: sağa hizalı, 12px boşluk, padding 24px
          └─────────────────────────────────────────┘
   overlay: rgba(15,23,42,0.5)
```

| Özellik | Değer |
|---------|-------|
| Genişlik | `sm` 400px · `md` 560px (varsayılan) · `lg` 800px (medya seçici) |
| Maks. yükseklik | 85vh; body kaydırılır, header/footer sabit |
| Yüzey | bg-surface, rounded-xl, shadow-xl |
| Giriş animasyonu | opacity 0→1 + scale 0.97→1, `duration-base`; reduced-motion'da yok |
| Footer buton sırası | İkincil solda, birincil **en sağda** |

### ConfirmDialog (silme onayı)

`sm` boyutunda, `role="alertdialog"`.

```
┌──────────────────────────────────────┐
│ (!)  "Hakkımızda" silinsin mi?       │ ← error-600 ikon 24px (bg error-50 daire içinde), başlık
│                                      │
│      Bu işlem geri alınamaz. Sayfa   │ ← açıklama: text-sm, gray-600
│      public sitede de kaldırılır.    │
│                                      │
│                 [Vazgeç]  [Sil]      │ ← secondary + danger
└──────────────────────────────────────┘
```

- Başlık nesnenin adını içerir; buton fiili tekrarlar ("Sil", "Kalıcı olarak sil") — "Tamam/Evet" kullanılmaz.
- **İlk odak "Vazgeç" butonundadır** (yıkıcı aksiyon varsayılan olmaz).
- Silme sürerken: "Sil" butonu loading; "Vazgeç" ve X disabled; overlay tıklaması/Escape devre dışı.
- Başarı: modal kapanır, `success` toast "“Hakkımızda” silindi.", odak listede bir sonraki satırın başlık linkine (yoksa sayfa başlığına) taşınır.
- Hata: modal açık kalır; body'nin üstünde `error` Alert (inline) "Silinemedi: <sebep>". "Sil" tekrar etkin.

### Durumlar (genel)

| Durum | Davranış |
|-------|----------|
| açılış | Odak modal içindeki ilk anlamlı öğeye (form ise ilk alan, onay ise iptal) |
| loading (içerik) | Body'de Spinner veya Skeleton; footer birincil buton disabled |
| submitting | Birincil buton loading; diğer kontroller disabled |
| error | Body üstünde inline `error` Alert |

### Erişilebilirlik

- `role="dialog"` (onayda `alertdialog`), `aria-modal="true"`, `aria-labelledby` → başlık, `aria-describedby` → açıklama.
- Odak modal içinde hapsedilir (focus trap); Tab/Shift+Tab döngüsel.
- Escape kapatır (submitting değilse). Overlay tıklaması: genel modalda kapatır, **form modalında kaydedilmemiş değişiklik varsa kapatmaz**, ConfirmDialog'da kapatmaz.
- Kapanınca odak modalı açan öğeye geri döner.
- Arka plan `inert` / `aria-hidden`; body scroll kilitli.
- Mobil (< `sm`): Modal tam genişlik, alttan açılan sheet (üst köşeler rounded-xl), footer butonları tam genişlik ve dikey yığılmış (birincil üstte).

---

## 8. EmptyState

```
            ┌────────┐
            │  ikon  │          ← 48px daire bg gray-100, içinde 24px ikon gray-500
            └────────┘
         Henüz içerik yok       ← text-lg / semibold / gray-900
  İlk sayfanı veya blog yazını  ← text-sm / gray-600, max 360px, ortalı
       oluşturarak başla.
          [+ Yeni içerik]        ← primary (opsiyonel) + secondary (opsiyonel)
```

| Varyant | Kullanım | Padding |
|---------|----------|---------|
| `default` | Liste tamamen boş, medya kütüphanesi boş | dikey 48px |
| `compact` | Filtre/arama sonucu yok, tablo içinde | dikey 24px, ikon yok |
| `error` | Yükleme hatası tam sayfa (ör. içerik bulunamadı) | ikon error-600 / bg error-50 |

Kurallar:
- Metin ne olduğunu **ve** ne yapılabileceğini söyler.
- Yetkisi olmayan kullanıcıya oluşturma butonu gösterilmez; metin buna göre değişir (ör. "Henüz içerik yok.").
- Başlık uygun seviyede heading (`h2`) olarak işaretlenir.

---

## 9. Yükleniyor: Spinner ve Skeleton

### Spinner

| Boyut | Çap | Çizgi | Kullanım |
|-------|-----|-------|----------|
| `sm` | 16px | 2px | Buton içi, inline |
| `md` | 24px | 2.5px | Kart / modal body |
| `lg` | 40px | 3px | Tam sayfa (yalnızca ilk uygulama yüklemesi) |

- Renk: iz gray-200, dönen yay brand-600 (solid buton içinde iz %30 beyaz, yay beyaz).
- Dönüş: 800ms linear sonsuz.
- `role="status"` + `sr-only` "Yükleniyor…" metni (buton içindeyse metin eklenmez; buton `aria-busy` taşır).
- 300ms'den kısa işlemlerde gösterilmez (yanıp sönmeyi önlemek için gecikmeli gösterim).

### Skeleton

- Renk: bg gray-200, rounded-md (metin satırı) / rounded-lg (kart, görsel).
- Shimmer: gray-200 → gray-100 → gray-200, 1.5s; `prefers-reduced-motion`'da statik.
- Şekiller gerçek içeriği taklit eder: tablo satırı (başlık %40 genişlik + badge 64px + meta 96px), medya grid kartı (1:1 kutu + tek satır), yazı detayı (başlık 2 satır + paragraf 6 satır).
- Kapsayıcıda `aria-busy="true"` ve tek bir `sr-only` "Yükleniyor…"; skeleton öğelerinin kendisi `aria-hidden="true"`.

### Ne zaman hangisi

| Durum | Bileşen |
|-------|---------|
| Liste / grid / sayfa içeriği ilk yükleme | Skeleton |
| Buton aksiyonu (kaydet, sil, giriş) | Buton loading (Spinner `sm`) |
| Modal içi veri | Spinner `md` veya Skeleton |
| Yeniden yükleme (filtre, sayfalama) | Mevcut içerik + üst ilerleme çizgisi |
| Dosya yükleme | ProgressBar (§20) |

---

## 10. Alert (inline banner)

Form seviyesinde hata, sayfa içi uyarılar ve login hatası için. Toast'tan farkı: kalıcıdır ve bağlamın içindedir.

| Özellik | Değer |
|---------|-------|
| Yapı | Sol 20px ikon · başlık (text-sm/medium) · açıklama (text-sm) · opsiyonel aksiyon linki/butonu · opsiyonel kapat (X) |
| Padding | 12px 16px |
| Radius | rounded-lg |
| Kenarlık | 1px `<rol>-200` |
| Arka plan / metin / ikon | `<rol>-50` / `<rol>-700` / `<rol>-600` |
| Roller | `info`, `success`, `warning`, `error` |

İkonlar: info → Info, success → CheckCircle, warning → AlertTriangle, error → AlertCircle.

Erişilebilirlik: `error` → `role="alert"`; diğerleri `role="status"`. Sayfa yüklenirken zaten görünen Alert'te role verilmez (gereksiz duyuru olmasın).

---

## 11. Toast

Kısa süreli geri bildirim (kaydetme, silme, yükleme sonucu).

```
                                     ┌──────────────────────────────────┐
                                     │ ✓  İçerik kaydedildi.        [X] │
                                     │    Görüntüle                     │ ← opsiyonel aksiyon (link)
                                     └──────────────────────────────────┘
```

| Özellik | Değer |
|---------|-------|
| Konum | Masaüstü: sağ alt, kenarlardan 24px; mobil (< `sm`): alt, tam genişlik − 16px kenar |
| Genişlik | 360px (maks.) |
| Yüzey | bg-surface, 1px border-default, rounded-lg, shadow-lg; solda 4px `<rol>-600` şerit |
| Metin | Başlık text-sm/medium gray-900; açıklama text-sm gray-600 |
| İkon | 20px, `<rol>-600` |
| Yığın | En fazla 3 toast; yenisi altta; 8px aralık |
| Giriş/çıkış | Aşağıdan 8px kayarak + fade, `duration-base` |
| z-index | `z-toast` (modalın üstünde) |

### Varyantlar ve süreler

| Varyant | Otomatik kapanma | Örnek |
|---------|------------------|-------|
| `success` | 5 sn | "İçerik yayınlandı." |
| `info` | 5 sn | "Taslak otomatik kaydedildi." |
| `warning` | 8 sn | "Görsel 2 MB'tan büyük, sıkıştırıldı." |
| `error` | **Otomatik kapanmaz** | "Kaydedilemedi. Bağlantınızı kontrol edin." + "Tekrar dene" |

- Fare üzerindeyken veya toast içinde odak varken zamanlayıcı durur (WCAG 2.2.1).
- Aksiyon içeren toast otomatik kapanma süresi en az 10 sn.

### Erişilebilirlik

- Kalıcı bir live region kapsayıcısı sayfa yüklenince DOM'da bulunur: success/info/warning için `role="status"` (`aria-live="polite"`), error için `role="alert"` (`aria-live="assertive"`).
- Toast odağı **çalmaz**. Kritik bilgi yalnızca toast'ta bırakılmaz (form hataları Alert + alan altında da gösterilir).
- Kapat butonu `aria-label="Bildirimi kapat"`.
- Kontrast: gray-900 / gray-600 metin beyaz yüzeyde (17.9 / 7.6:1).

---

## 12. Link

| Durum | Stil |
|-------|------|
| default | brand-600, gövde metninde `underline` (offset 2px); navigasyon/menüde altı çizgisiz |
| hover | brand-700, underline |
| visited | Değişmez (public sitede de aynı) |
| focus-visible | Standart focus ring, rounded-sm |

Yeni sekmede açılan linkler (ör. "Sitede görüntüle") yanında 14px dış bağlantı ikonu ve `sr-only` "(yeni sekmede açılır)".

---

## 13. AuthCard (TASK-004)

Login gibi kabuksuz, tek amaçlı formların kapsayıcısı. Bkz. `login.md`.

| Özellik | Değer |
|---------|-------|
| Sayfa | bg-app, içerik yatay + dikey ortalı; kısa viewport'ta üstten 48px ve kayar |
| Marka satırı | Kartın 32px üstünde, ürün adı text-xl/semibold gray-900 |
| Kart | bg-surface, 1px border-default, rounded-xl, shadow-sm, padding 32px, `max-w-auth` (400px), tam genişlik |
| Başlık | h1 text-2xl/semibold tracking-tight + açıklama text-sm gray-600; forma 24px |
| Alt not | Kartın 24px altında, text-sm gray-600, ortalı |
| < `sm` | Kart görünümü kalkar (kenarlık/gölge yok, bg-surface sayfa), padding 16px, marka sola hizalı |

---

## 14. Sidebar (TASK-004)

Admin ana gezinmesi. Bkz. `admin-layout.md` §3.

| Parça | Stil |
|-------|------|
| Kapsayıcı | `w-sidebar` 256px, bg gray-800, sticky tam yükseklik, kendi içinde kayar |
| Marka | 64px yükseklik, padding 0 16px, text-lg/semibold gray-0, `/admin`'e link |
| Menü öğesi | 40px yükseklik, padding 0 12px, margin 0 8px, rounded-md, ikon 20px + 12px boşluk + text-sm |
| Pasif | Metin gray-300, ikon gray-400 (dekoratif) |
| Hover | bg gray-700, metin gray-0 |
| Aktif | bg brand-50, metin + ikon brand-700, font-medium, `aria-current="page"` |
| Focus | Ring brand-300, offset rengi gray-800 |
| Ayırıcı | 1px gray-700, margin 8px 16px |
| Alt bölüm | Kullanıcı adı text-sm gray-0 + rol Badge `info`; padding 16px; üst ayırıcı |
| Harici öğe | Sonda 14px `ExternalLink` ikonu + sr-only "(yeni sekmede açılır)" |

**Mobil drawer varyantı (< `md`):** Soldan kayan 280px (maks %85) panel, `z-sidebar`, overlay `overlay`, `duration-slow` + `ease-standard` (çıkışta `ease-exit`); başlıkta kapat butonu (ghost icon-only, gray-300, `aria-label="Menüyü kapat"`). `role="dialog"`, `aria-modal="true"`, focus trap, Escape kapatır, odak tetikleyiciye döner; bir öğe seçilince kapanır. Reduced-motion'da animasyon yok.

Menü öğeleri bir **rol → öğe** tablosundan üretilir; yalnız admin öğeleri listenin sonunda ayırıcıyla gruplanır.

---

## 15. Topbar (TASK-004)

| Özellik | Değer |
|---------|-------|
| Yükseklik / yüzey | `h-topbar` 64px, bg-surface, alt 1px border-default, sticky, `z-header` |
| Sol | < `md`: hamburger (ghost icon-only `md`, 44px dokunma alanı, `aria-expanded`, `aria-controls`) + ürün adı. ≥ `md`: boş (sayfa başlığı main'dedir) |
| Sağ | ≥ `md`: "Siteyi görüntüle" Link (harici) + 16px + UserMenu tetikleyicisi. < `md`: yalnız UserMenu (avatar) |
| Padding | Yatayda main ile aynı (16 / 24 / 32px) |
| Landmark | `<header>` |

---

## 16. UserMenu (TASK-004)

DropdownMenu (§17) üzerine kurulu kullanıcı menüsü.

```
 (AY) Ayşe Yılmaz ▾           ← tetikleyici: ghost buton; avatar 32px + ad (≥ md) + chevron
┌────────────────────────────┐
│ Ayşe Yılmaz                │ ← başlık: text-sm/medium gray-900 (etkileşimsiz)
│ ayse@site.com              │ ← text-xs gray-600
│ [Editör]                   │ ← Badge info
├────────────────────────────┤
│ ⎋ Çıkış yap                │ ← menuitem
└────────────────────────────┘
```

| Parça | Stil |
|-------|------|
| Avatar | 32px daire, bg brand-100, baş harfler text-xs/semibold brand-700 (brand-700/brand-100 ≈ 6.4:1), `aria-hidden` |
| Tetikleyici adı | `aria-label="Kullanıcı menüsü: Ayşe Yılmaz"` (mobilde ad görünmediğinde de anlamlı) |
| Ad yoksa | Baş harf yerine e-postanın ilk harfi; menü başlığında e-posta |

MVP'de menüde yalnız "Çıkış yap" vardır (profil/şifre değiştirme yok).

---

## 17. DropdownMenu (TASK-004)

UserMenu ve Table mobil kartlarındaki "⋯" menüsü için genel menü.

| Özellik | Değer |
|---------|-------|
| Panel | bg-surface, 1px border-default, rounded-lg, shadow-md, min 200px, padding 4px, `z-dropdown`; tetikleyiciye 4px mesafe, sağa hizalı |
| Öğe | 36px (mobilde 44px), padding 0 12px, rounded-md, text-sm gray-700, ikon 16px |
| Öğe hover / odak | bg gray-100, metin gray-900 |
| Tehlikeli öğe | Metin error-700, hover bg error-50 |
| Ayırıcı | 1px gray-200, margin 4px 0 |
| Giriş | opacity + 4px kayma, `duration-base`; reduced-motion'da yok |

Erişilebilirlik (ARIA menu button kalıbı): tetikleyici `aria-haspopup="menu"`, `aria-expanded`; panel `role="menu"`, öğeler `role="menuitem"`. Açılınca odak ilk öğeye; ↑/↓ öğeler arası (döngüsel), Home/End, Escape kapatır ve odağı tetikleyiciye döndürür, Tab menüyü kapatır. Dışarı tıklama kapatır. Etkileşimsiz başlık bloğu `role="none"` / `presentation`.

---

## 18. SkipLink (TASK-004, TASK-016)

"İçeriğe atla" — sayfanın ilk odaklanabilir öğesi; `#main`'e gider.

- Varsayılanda `sr-only`; odaklanınca sol üstte 16px içeride görünür: bg-surface, brand-700 metin, text-sm/medium, padding 8px 12px, rounded-md, shadow-md, standart focus ring, `z-toast`.
- Hedef `<main id="main" tabindex="-1">`.

---

## 19. Dropzone (TASK-012)

Dosya bırakma ve seçme alanı. Gerçek bir `<input type="file">`'a bağlıdır.

| Varyant | Yükseklik | İçerik |
|---------|-----------|--------|
| `compact` | min 96px | Tek satır: `Upload` ikon 20px + "Görselleri buraya sürükleyin veya **dosya seçin**" (dosya seçin = buton görünümlü link, brand-600, altı çizili) + alt satır "{TIPLER} · en fazla {MAKS}" text-xs gray-600 |
| `large` | min 280px | EmptyState düzeni: 48px daire içinde `ImagePlus` 24px, h2 başlık, açıklama, secondary "Dosya seç" butonu |

| Durum | Görünüm |
|-------|---------|
| default | bg gray-0, 2px kesikli gray-500 kenarlık, rounded-xl |
| hover (fare alan üzerinde) | bg gray-50 |
| drag-over (dosya sürükleniyor) | bg brand-50, 2px kesikli brand-600, metin "Bırakarak yükleyin" brand-700 |
| focus-visible (içindeki buton) | Standart ring butonda |
| disabled | bg gray-100, kenarlık gray-300, metin gray-400; ör. yükleme yetkisi yok |
| reject (sürüklenen öğe dosya değil) | Değişiklik yok; bırakılırsa yok sayılır |

- `multiple`; `accept` MIME listesi yapılandırmadan gelir.
- Dokunmatik cihazlarda (`pointer: coarse`) sürükle metni gizlenir; yalnız "Dosya seç" butonu ve kısıt satırı.
- Sürükle-bırak yalnız kolaylıktır; buton klavye ile tam kullanılabilir.

---

## 20. ProgressBar (TASK-012)

| Özellik | Değer |
|---------|-------|
| İz | 6px yükseklik, bg gray-200, rounded-full |
| Dolgu | brand-500 (dekoratif; yüzde metni ayrıca yazılır), rounded-full, genişlik geçişi `duration-fast` |
| Belirsiz (indeterminate) | %30 genişlikte dolgu soldan sağa 1.2s döngü; reduced-motion'da %100 genişlik, opacity 0.5, sabit |
| Hata | Dolgu error-600 (yanında metin + ikon zorunlu) |
| Etiket | Yanında veya üstünde text-xs gray-600 yüzde ("%64") |

`role="progressbar"`, `aria-valuemin="0"`, `aria-valuemax="100"`, `aria-valuenow` (belirsizde verilmez), `aria-label="kapak.jpg yükleniyor"`. Yüzde değişimleri live region'a gönderilmez.

---

## 21. UploadItem / UploadQueue (TASK-012)

```
┌──────────────────────────────────────────────────────────────────────┐
│ Yüklemeler (1/3)                                 [Listeyi temizle]   │ ← başlık text-sm/medium + ghost sm
├──────────────────────────────────────────────────────────────────────┤
│ [▢] kapak.jpg   1,2 MB   ██████████░░░░░  %64              [İptal]   │ ← UploadItem 56px
│ [▢] logo.png    0,3 MB   ✓ Yüklendi                                  │
│ [⚠] video.mp4   12 MB    Bu dosya türü desteklenmiyor. …   [Kaldır]  │
└──────────────────────────────────────────────────────────────────────┘
```

| Parça | Stil |
|-------|------|
| Kuyruk kapsayıcı | bg-surface, 1px border-default, rounded-lg; satırlar arası 1px gray-200; `<ul>` |
| Önizleme | 40px kare, rounded-md, object-cover; görsel değilse (hata) `FileX` ikonu bg gray-100 |
| Ad | text-sm gray-900, tek satır, ortadan kırpma ("ekip-toplant…-01.jpg"), tam ad `title` + erişilebilir ad |
| Boyut | text-xs gray-600, `tr-TR` biçimi ("1,2 MB") |
| Durum alanı | ProgressBar (§20) veya ikon + mesaj (success-700 / error-700, text-sm) |
| Aksiyonlar | ghost `sm`: "İptal" (yükleniyor), "Tekrar dene" (ağ hatası), "Kaldır" (hata) |

Durumlar: sırada · yükleniyor · işleniyor · tamamlandı · hata (tür / boyut / ağ / yetki) · iptal. Mesaj metinleri `media.md` §6.2'de. Durum değişimleri tek bir `role="status"` live region'a yazılır (hata dahil; `alert` kullanılmaz ki çoklu yüklemede gürültü olmasın).

---

## 22. MediaCard (TASK-012)

```
┌──────────────┐
│              │  ← 1:1, object-cover, bg gray-100, rounded-t-xl
│    görsel    │
│              │
├──────────────┤
│ kapak.jpg    │  ← text-sm gray-900, tek satır ortadan kırpma
│ 1,2 MB       │  ← text-xs gray-600 (picker modunda yok)
└──────────────┘
```

| Mod | Etkileşim | Rol |
|-----|-----------|-----|
| `link` (kütüphane) | Tıklama detay modalını açar | `<button>`, erişilebilir ad "kapak.jpg, 1,2 MB" |
| `selectable` (picker) | Tıklama/Space seçer | `role="radio"` + `aria-checked` |

| Durum | Görünüm |
|-------|---------|
| default | bg-surface, 1px border-default, rounded-xl, overflow hidden |
| hover | shadow-md, kenarlık gray-300 |
| focus-visible | Standart focus ring (rounded-xl) |
| selected (picker) | 2px brand-600 halka (ring, layout kaymaz) + sol üstte 24px brand-600 daire içinde beyaz ✓ |
| loading | Skeleton: 1:1 kutu + tek satır |
| görsel kırık | `ImageOff` ikon gray-500 ortada, sr-only "Önizleme yüklenemedi" |
| yeni eklendi | 1 kez brand-50 arka plan vurgusu, 1s sonra söner (reduced-motion'da yok) |

Görsel `alt=""` (ad metin olarak kartta), `loading="lazy"`, `decoding="async"`. Önizleme API'nin döndürdüğü `url` (ileride küçük resim URL'si dönerse o) kullanılır; depolama yeri varsayılmaz.

---

## 23. MediaPicker (TASK-012)

İçerik formundan görsel seçmek için Modal `lg` (§7). Düzen ve akış: `media.md` §2.4, §3.3, §6.4.

| Bölge | İçerik |
|-------|--------|
| Header | "Görsel seç" + kapat (X) |
| Body (kayar) | Dropzone `compact` · UploadQueue (varsa) · MediaCard grid (`selectable`, min 120px, `role="radiogroup"`) · "Daha fazla yükle" |
| Footer (sabit) | FormField "Alternatif metin" (seçim yokken disabled) · "İptal" secondary + "Ekle" primary (seçim yokken disabled) |

**Sözleşme (editörden bağımsız):** Açılırken opsiyonel `onSelect` geri çağrısı alır; "Ekle"de `{ id, url, alt, width?, height? }` döndürür ve kapanır. Ekleme biçimi (Markdown `![alt](url)` vb.) çağıranın sorumluluğundadır. Kapanınca odak çağıran öğeye/editöre döner. Picker'da silme aksiyonu yoktur.

Kaydedilmemiş durum: Seçim veya alt metin varken overlay tıklaması kapatmaz (§7 form modalı kuralı); Escape ve "İptal" kapatır.

Mobil: alttan 95vh sheet, grid 3 sütun, footer sabit.

---

## 24. CopyField (TASK-012)

Salt okunur değer + kopyala butonu (ör. medya URL'si). Input §2 `read-only` durumu + sağ adornment.

| Parça | Değer |
|-------|-------|
| Alan | Input read-only (bg gray-50, kenarlık gray-200), text-sm `font-mono`, tek satır, taşan kısım kaydırılabilir; odaklanınca tümü seçilir |
| Buton | Sağda bitişik secondary `md` buton: `Copy` ikon + "Kopyala" (< `sm` yalnız ikon + `aria-label="URL'yi kopyala"`) |
| Başarı | Buton 2 sn: `Check` ikon (success-600) + "Kopyalandı"; `role="status"` duyurur |
| Hata | Alan metni seçilir; altında error-700 metin "Kopyalanamadı, metni elle kopyalayın." |

FormField ile etiketlenir ("URL").

---

## 25. SiteHeader (TASK-016)

| Özellik | Değer |
|---------|-------|
| Yüzey | 64px, bg gray-0, alt 1px border-default, **yapışkan değil** |
| Kapsayıcı | `max-w-site` ortalı, yatay padding 16/24/32px |
| Sol | Site adı: text-lg/bold gray-900, `/`'e link (ana sayfada da link) |
| Sağ | `<nav aria-label="Ana menü">`: "Blog" text-base/medium gray-700; hover gray-900; aktif: gray-900 + 2px brand-600 alt çizgi (header'ın alt kenarına oturur), `aria-current="page"` (`/blog` ve `/blog/*`'da aktif) |
| Dokunma | Linkler 44px yükseklik |

---

## 26. SiteFooter (TASK-016)

| Özellik | Değer |
|---------|-------|
| Yüzey | bg gray-50, üst 1px border-default, dikey padding 48px (mobil 32px) |
| Düzen (≥ `sm`) | Sol: site adı text-base/semibold gray-900 + altında "© {yıl} {SITE_ADI}" text-sm gray-600. Sağ: `<nav aria-label="Sayfalar">` yatay link listesi, 24px aralık |
| Düzen (< `sm`) | Dikey yığın; linkler alt alta, 44px satır |
| Link | text-sm gray-700, hover brand-700 + underline; aktif sayfada underline + `aria-current="page"` |
| Boş | Yayındaki sayfa yoksa `nav` hiç render edilmez |

---

## 27. PostCard (TASK-016)

| Varyant | Kullanım | Düzen |
|---------|----------|-------|
| `grid` | Ana sayfa "Son yazılar" | Kart: bg-surface, 1px border-default, rounded-xl, padding 24px; hover shadow-md + kenarlık gray-300 |
| `list` | Blog listesi | Kutusuz; dikey padding 24px; aralarda 1px gray-200 ayırıcı |

İçerik sırası (her iki varyant):
1. Meta: `<time>` tarih ("12 Kasım 2026") · yazar (varsa) — text-sm gray-600
2. Başlık: seviye parametredir — blog listesinde `h2` (sayfa h1'i "Blog"), ana sayfada `h3` (bölüm h2'si "Son yazılar" altında); text-xl/semibold gray-900 (`list`'te text-2xl); en fazla 2 satır (`grid`) — `list`'te kırpılmaz. Başlık bir linktir; hover'da brand-700 + underline
3. Özet: text-base gray-600, en fazla 3 satır (`line-clamp-3`)

- Kapak görseli yok (model desteklemiyor; bkz. `public-site.md` §9).
- Tıklama alanı: başlık linkinin `::after`'ı kartı kaplar; odak halkası kartın tamamında görünür (`focus-within` ile kart kenarına ring).
- Loading: Skeleton (tarih %30, başlık %70, özet 2 satır).

---

## 28. SimplePagination (TASK-016)

Public blog listesi için önceki/sonraki sayfalama. (Admin Table §5 pagination'ından ayrı: sayı aralığı yerine sayfa numarası gösterir.)

```
[‹ Önceki]            Sayfa 2 / 6            [Sonraki ›]
```

| Parça | Değer |
|-------|-------|
| Kapsayıcı | `<nav aria-label="Sayfalama">`, üstte 48px boşluk, üç sütun (sol / orta / sağ) |
| Önceki / Sonraki | Button `secondary` `md` görünümlü **`<a>`** (gerçek URL, `rel="prev"` / `rel="next"`); mobilde 44px |
| Orta | text-sm gray-600 "Sayfa 2 / 6" |
| Sınırlar | İlk sayfada "Önceki", son sayfada "Sonraki" render edilmez (disabled gösterilmez); sütun boş kalır, orta metin kaymaz |
| Tek sayfa | Bileşen render edilmez |

---

## 29. Prose (TASK-016)

Public yazı/sayfa gövdesi ve (ileride) admin önizleme için Markdown çıktısı stili. `@tailwindcss/typography` tabanlı, token'lara ayarlı.

| Öğe | Stil |
|-----|------|
| Kapsayıcı | `max-w-prose-lg` (70ch), text 18px / 32px (mobil 17px / 1.7), gray-900 |
| Paragraf | Alt boşluk 24px |
| h2 | text-2xl (mobil text-xl) / semibold / tracking-tight, üst 48px alt 16px |
| h3 | text-xl / semibold, üst 32px alt 12px |
| h4–h6 | text-lg / semibold |
| Link | brand-600, underline offset 2px; hover brand-700 |
| Liste | Sol 24px girinti, öğeler arası 8px; işaret rengi gray-500 |
| Alıntı | Sol 4px gray-300 çizgi, padding-left 16px, gray-700, italik değil |
| Satır içi kod | `font-mono` 0.875em, bg gray-100, rounded-sm, padding 2px 4px, gray-900 |
| Kod bloğu | `font-mono` 14px/1.6, bg gray-900, metin gray-50 (≈17:1), rounded-lg, padding 16px, `overflow-x-auto`, `tabindex="0"` (klavyeyle kaydırılabilir) |
| Görsel | `max-width: 100%`, height auto, rounded-lg, dikey 32px boşluk; `loading="lazy"` |
| Tablo | Kendi kapsayıcısında `overflow-x-auto`; başlık bg gray-100, hücre çizgileri gray-200, text-base |
| Yatay çizgi | 1px gray-200, dikey 48px |

Başlık seviyesi kaydırma: gövdedeki Markdown `#` → h2 (sayfanın tek h1'i başlıktır).

---

## Bileşen kayıt tablosu

| Bileşen | Bölüm | Eklendiği görev | Not |
|---------|-------|-----------------|-----|
| Button | §1 | TASK-001 | primary, secondary, danger, ghost, ghost-danger; sm/md/lg; icon-only |
| Input / Textarea / Select | §2 | TASK-001 | Şifre, arama, adornment varyantları |
| FormField | §3 | TASK-001 | Etiket, yardım, hata, form seviyesi hata akışı |
| Checkbox / Switch | §4 | TASK-001 | Yardımcı |
| Table (+ Pagination) | §5 | TASK-001 | Mobilde kart listesi |
| Badge | §6 | TASK-001 | draft, published, neutral, info, success, warning, error |
| Modal / ConfirmDialog | §7 | TASK-001 | Silme onayı dahil |
| EmptyState | §8 | TASK-001 | default, compact, error |
| Spinner / Skeleton | §9 | TASK-001 | |
| Alert | §10 | TASK-001 | Inline banner |
| Toast | §11 | TASK-001 | |
| Link | §12 | TASK-001 | |
| AuthCard | §13 | TASK-004 | Login kapsayıcısı |
| Sidebar (+ mobil drawer) | §14 | TASK-004 | Rol → öğe tablosundan üretilir |
| Topbar | §15 | TASK-004 | |
| UserMenu | §16 | TASK-004 | DropdownMenu üzerine |
| DropdownMenu | §17 | TASK-004 | ARIA menu button; Table mobil "⋯" menüsü de bunu kullanır |
| SkipLink | §18 | TASK-004 | Admin + public |
| Dropzone | §19 | TASK-012 | compact, large |
| ProgressBar | §20 | TASK-012 | Belirli / belirsiz |
| UploadItem / UploadQueue | §21 | TASK-012 | |
| MediaCard | §22 | TASK-012 | link, selectable |
| MediaPicker | §23 | TASK-012 | Editörden bağımsız sözleşme |
| CopyField | §24 | TASK-012 | |
| SiteHeader | §25 | TASK-016 | |
| SiteFooter | §26 | TASK-016 | |
| PostCard | §27 | TASK-016 | grid, list |
| SimplePagination | §28 | TASK-016 | Public önceki/sonraki |
| Prose | §29 | TASK-016 | Markdown gövde stili |

İlerideki görevlerde beklenen yeni bileşenler (henüz tanımlı değil): Markdown editörü + önizleme, FilterBar (TASK-008).
