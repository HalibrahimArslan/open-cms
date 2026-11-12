# Ekran: Medya kütüphanesi

> Sahibi: designer · Görev: TASK-012 · Rota: `/admin/media` (admin layout içinde)
>
> Bağımlılıklar: `tokens.md`, `components.md` (Dropzone §19, ProgressBar §20, UploadItem §21, MediaCard §22, MediaPicker §23, CopyField §24 — bu görevde eklendi), `admin-layout.md`.
> API: TASK-013 (yükle / listele / sil). Bu doküman **depolama yerinden bağımsızdır** (Açık karar #2): UI yalnız API'nin döndürdüğü `url`'yi kullanır; alan adı, yol yapısı veya CDN varsayımı yapmaz.

---

## 1. Amaç

Görselleri yüklemek, göz atmak, ayrıntısını görmek, URL'sini kopyalamak ve silmek. Aynı kütüphane, içerik formundan **MediaPicker** modalı ile görsel seçmek için de kullanılır.

MVP'de yalnız **görsel** dosyalar desteklenir.

### Yer tutucu değerler

Tip ve boyut sınırı backend'de (TASK-013) belirlenecek. Bu dokümanda:
- `{TIPLER}` → izinli uzantıların okunur listesi, ör. "JPG, PNG, WebP, GIF"
- `{MAKS}` → maksimum boyut, ör. "5 MB"

Frontend bu değerleri tek bir yapılandırmadan okur (ekranda iki yerde geçer: Dropzone yardım metni ve hata mesajları). Değerler `docs/api.md`'de belirlenince doldurulur.

---

## 2. Kullanıcı akışları

### 2.1 Yükleme

```
[Yükle] butonu / sürükle-bırak / Dropzone'a tıklama
    │
    ├─ İstemci doğrulama (her dosya ayrı):
    │     ├─ tip izinli değil  → UploadItem "hata" (istek atılmaz)
    │     └─ boyut > {MAKS}     → UploadItem "hata" (istek atılmaz)
    │
    └─ Geçerli dosyalar → yükleme kuyruğu (aynı anda en fazla 3 istek)
          ├─ yükleniyor  → ProgressBar (yüzde)
          ├─ başarılı    → UploadItem kısa süre "tamamlandı", sonra grid'in başına MediaCard olarak eklenir
          └─ başarısız   → UploadItem "hata" + "Tekrar dene" / "Kaldır"
```

- Birden çok dosya seçilebilir; her dosya bağımsız yüklenir (biri hatalıysa diğerleri devam eder).
- Sunucu tarafı reddi (`413`, `415`, `400`) istemci hatasıyla aynı mesajları kullanır.
- Tüm yüklemeler bitince tek bir özet Toast: başarılı ise `success` "3 görsel yüklendi."; kısmi ise `warning` "2 görsel yüklendi, 1 görsel yüklenemedi." Hatalı öğeler kuyrukta kalır.
- Yükleme sürerken sayfadan ayrılmaya çalışılırsa tarayıcı `beforeunload` uyarısı gösterilir.

### 2.2 Göz atma

Grid, en yeniler önce. İlk 40 öğe; altında "Daha fazla yükle" (secondary) butonu. Sonsuz kaydırma kullanılmaz (klavye ve footer erişimi için).

### 2.3 Detay ve silme

```
MediaCard'a tıkla ─▶ Detay modalı (Modal lg)
                       ├─ "URL'yi kopyala" → panoya kopyalanır, buton metni 2 sn "Kopyalandı"
                       ├─ "Yeni sekmede aç" → orijinal dosya
                       └─ "Sil" (ghost-danger) → ConfirmDialog
                               ├─ Vazgeç → detay modalına dönülür
                               └─ Sil → DELETE
                                     ├─ başarı → her iki modal kapanır, success Toast "“kapak.jpg” silindi.",
                                     │           kart grid'den kalkar, odak bir sonraki karta (yoksa sayfa h1'ine)
                                     └─ hata   → ConfirmDialog açık kalır, inline error Alert
```

ConfirmDialog metni (kullanım takibi MVP'de yok, bu yüzden uyarı genel):
- Başlık: **"“kapak.jpg” silinsin mi?"**
- Açıklama: "Bu işlem geri alınamaz. Bu görseli kullanan içeriklerde görsel artık görünmez."
- Butonlar: "Vazgeç" (secondary, ilk odak) · "Sil" (danger)

### 2.4 İçerik formundan görsel seçme (MediaPicker)

```
İçerik formu ─ "Görsel ekle" butonu ─▶ MediaPicker (Modal lg)
                                         │
                                         ├─ Grid'den bir görsel seç (tek seçim)    ┐
                                         ├─ veya Dropzone ile yeni yükle →          ├─▶ seçili görsel
                                         │    yüklenen görsel otomatik seçilir      ┘
                                         │
                                         ├─ "Alternatif metin" alanı (zorunlu değil, bkz. aşağı)
                                         │
                                         └─ [Ekle] → modal kapanır, görsel editöre eklenir,
                                                      odak editörde ekleme noktasına döner
```

- Picker **editörden bağımsızdır** (Açık karar #3): seçim sonucu olarak `{ id, url, alt, width?, height? }` döndürür. Markdown editöründe imleç konumuna `![alt](url)` eklenir; WYSIWYG seçilirse aynı veri bir görsel düğümüne dönüşür. Tetikleyici butonun editördeki yeri TASK-008 dokümanında belirlenir.
- **Alternatif metin:** Picker altında FormField: "Alternatif metin" — yardım metni: "Görseli göremeyenler için kısa açıklama. Görsel yalnızca süs ise boş bırakın." Alan boşsa ekleme yine yapılır (`alt=""` dekoratif görsel olarak geçerlidir). Alt metin içeriğe (Markdown) yazılır, medya kaydına değil; bu yüzden backend değişikliği gerektirmez.
- Picker içinden **silme yapılamaz** (yanlışlıkla kullanımdaki görseli silmeyi önlemek için).
- Seçim yapılmadan "Ekle" disabled.

---

## 3. Yerleşim

### 3.1 Kütüphane sayfası — masaüstü

```
┌─ admin layout ─────────────────────────────────────────────────────────────┐
│ Medya                                                       [⤒ Yükle]      │ ← h1 + primary "Yükle" (dosya seçiciyi açar)
│                                                                            │
│ ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐ │
│ ╎        ⤒  Görselleri buraya sürükleyin veya  dosya seçin               ╎ │ ← Dropzone (compact, 96px)
│ ╎           {TIPLER} · en fazla {MAKS}                                   ╎ │
│ └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘ │
│                                                                            │
│ Yüklemeler (2/3)                                          [Listeyi temizle]│ ← UploadQueue (yalnız kuyruk varken)
│ ┌────────────────────────────────────────────────────────────────────────┐ │
│ │ ▢ kapak.jpg        1,2 MB   ████████████░░░░░░  64%           [İptal]  │ │
│ │ ▢ logo.png         0,3 MB   ✓ Yüklendi                                 │ │
│ │ ⚠ video.mp4        12 MB    Bu dosya türü desteklenmiyor.     [Kaldır] │ │
│ └────────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│ 57 görsel                                                                  │ ← text-sm gray-600, aria-live=polite
│ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐          │
│ │        │ │        │ │        │ │        │ │        │ │        │          │ ← MediaCard grid
│ │  1:1   │ │        │ │        │ │        │ │        │ │        │          │
│ │        │ │        │ │        │ │        │ │        │ │        │          │
│ ├────────┤ ├────────┤ ├────────┤ ├────────┤ ├────────┤ ├────────┤          │
│ │kapak.jp│ │logo.png│ │ekip-01…│ │ ...    │ │        │ │        │          │
│ │1,2 MB  │ │0,3 MB  │ │2,4 MB  │ │        │ │        │ │        │          │
│ └────────┘ └────────┘ └────────┘ └────────┘ └────────┘ └────────┘          │
│ ...                                                                        │
│                          [Daha fazla yükle]                                │
└────────────────────────────────────────────────────────────────────────────┘
```

- Sayfa geneli de bırakma hedefidir: dosya sayfa üzerinde sürüklenince Dropzone "aktif" durumuna geçer (ayrı tam ekran overlay yok).
- Grid: CSS grid `repeat(auto-fill, minmax(160px, 1fr))`, aralık 16px. Kart radius `rounded-xl`.

### 3.2 Detay modalı (Modal `lg`, 800px)

```
┌───────────────────────────────────────────────────────────────────────┐
│ kapak.jpg                                                         [X] │
├───────────────────────────────────────────────────────────────────────┤
│ ┌───────────────────────────────────┐  Dosya adı                      │
│ │                                   │  kapak.jpg                      │
│ │                                   │                                 │
│ │      önizleme (object-contain,    │  Tür          Boyut             │
│ │      bg gray-100, maks 60vh)      │  JPG          1,2 MB            │
│ │                                   │                                 │
│ │                                   │  Ölçüler      Yüklenme          │
│ │                                   │  1600×900 px  12 Kas 2026 14:05 │
│ └───────────────────────────────────┘                                 │
│                                        Yükleyen                       │
│                                        Ayşe Yılmaz                    │
│                                                                       │
│                                        URL                            │
│                                        ┌──────────────────────┬─────┐ │
│                                        │ https://…/kapak.jpg  │ ⧉   │ │ ← CopyField
│                                        └──────────────────────┴─────┘ │
├───────────────────────────────────────────────────────────────────────┤
│ [🗑 Sil]                                    [Yeni sekmede aç ↗] [Kapat]│
└───────────────────────────────────────────────────────────────────────┘
```

- Sol sütun %60, sağ sütun %40; meta `<dl>` olarak (dt text-xs/medium gray-600, dd text-sm gray-900).
- API'nin dönmediği meta alanları (ör. ölçüler, yükleyen) **gösterilmez**; boş "—" satırı yazılmaz.
- "Sil" footer'ın solunda `ghost-danger`; yalnız silme yetkisi olan kullanıcıya gösterilir (§4).
- Bu modalda primary buton yoktur ("Kapat" secondary).

### 3.3 MediaPicker (Modal `lg`)

```
┌───────────────────────────────────────────────────────────────────────┐
│ Görsel seç                                                        [X] │
├───────────────────────────────────────────────────────────────────────┤
│ ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐ │
│ ╎  ⤒ Yeni görsel yüklemek için sürükleyin veya dosya seçin          ╎ │ ← Dropzone compact
│ └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘ │
│  (yükleme varsa UploadItem satırları burada)                          │
│                                                                       │
│ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐                          │
│ │      │ │ ✓    │ │      │ │      │ │      │   ← seçili kart: 2px brand-600 halka
│ │      │ │██████│ │      │ │      │ │      │      + sol üstte ✓ rozet
│ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘                          │
│ ┌──────┐ ┌──────┐ ...                       (body kayar)              │
│                  [Daha fazla yükle]                                   │
├───────────────────────────────────────────────────────────────────────┤
│ Alternatif metin                                                      │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │ Ekip toplantısında beş kişi masa başında                          │ │
│ └───────────────────────────────────────────────────────────────────┘ │
│ Görseli göremeyenler için kısa açıklama. Süs ise boş bırakın.         │
│                                                  [İptal]  [Ekle]      │
└───────────────────────────────────────────────────────────────────────┘
```

- Alt metin alanı ve butonlar sabit footer'dadır (grid kayarken görünür kalır). Alt metin alanı yalnız bir görsel seçiliyken etkin.
- Picker grid'inde kart minimum 120px; dosya adı kartta gösterilir, boyut gösterilmez.

---

## 4. Rol bazlı aksiyonlar

> **Varsayım** (bkz. AÇIK SORU): API tasarımı netleşene kadar en kısıtlayıcı ve kolay gevşetilebilir kural.

| Aksiyon | admin | editor | author |
|---------|:-----:|:------:|:------:|
| Kütüphaneyi görme, detay, URL kopyalama | ✓ | ✓ | ✓ |
| Yükleme (sayfa + picker) | ✓ | ✓ | ✓ |
| Silme | ✓ (tümü) | ✓ (tümü) | Yalnız kendi yüklediği |

- Yetkisi olmayan kullanıcıya "Sil" butonu **gösterilmez** (disabled değil).
- API yine de `403` dönerse: ConfirmDialog içinde `error` Alert "Bu görseli silme yetkiniz yok."

---

## 5. Bileşenler

| Bileşen | Kaynak | Kullanım |
|---------|--------|----------|
| Button | §1 | "Yükle" primary; "Daha fazla yükle", "Kapat", "İptal" secondary; "Sil" ghost-danger / danger |
| Dropzone | §19 (yeni) | Sayfa + picker |
| ProgressBar | §20 (yeni) | UploadItem içinde |
| UploadItem / UploadQueue | §21 (yeni) | Yükleme listesi |
| MediaCard | §22 (yeni) | Grid (kütüphane: `link` modu, picker: `selectable` modu) |
| MediaPicker | §23 (yeni) | İçerik formundan seçim |
| CopyField | §24 (yeni) | Detay modalında URL |
| Modal / ConfirmDialog | §7 | Detay, picker, silme onayı |
| EmptyState | §8 | Boş kütüphane, yükleme hatası |
| Skeleton | §9 | İlk yükleme |
| Alert, Toast | §10, §11 | Hatalar ve sonuçlar |
| Badge `error` | §6 | UploadItem'da "Başarısız" |

---

## 6. Durumlar

### 6.1 Kütüphane sayfası

| Durum | Görünüm |
|-------|---------|
| İlk yükleme | Başlık + Dropzone gerçek; grid yerinde 12 MediaCard skeleton'u (1:1 kutu + tek satır); sayaç gizli |
| Boş (hiç görsel yok) | Dropzone **büyük** varyantı grid'in yerini alır ve EmptyState rolünü üstlenir: ikon `ImagePlus`, başlık (h2) "Henüz görsel yok", metin "Görselleri buraya sürükleyin veya bilgisayarınızdan seçin. {TIPLER}, en fazla {MAKS}.", buton "Dosya seç". Üstteki compact Dropzone gösterilmez (tek bırakma alanı) |
| Dolu | §3.1 |
| Daha fazla yükleniyor | "Daha fazla yükle" butonu loading; yeni kartlar eklenince odak ilk yeni karta taşınır |
| Liste hatası | Grid yerine `error` Alert: "Görseller yüklenemedi." + secondary "Tekrar dene". Dropzone kullanılabilir kalır |
| "Daha fazla" hatası | Buton yerinde kalır; altında inline `error` metni "Daha fazla görsel yüklenemedi." Buton tekrar denenebilir |
| Kart görseli yüklenemedi (kırık URL) | Kartta 1:1 alan bg gray-100, ortada `ImageOff` ikon gray-500, sr-only "Önizleme yüklenemedi"; kart yine tıklanabilir |

### 6.2 Yükleme (UploadItem) durumları

| Durum | Görünüm | Mesaj |
|-------|---------|-------|
| Sırada | Küçük önizleme + ad + boyut, ProgressBar 0% (belirsiz değil) | "Sırada" (gray-600) |
| Yükleniyor | ProgressBar yüzde; "İptal" ghost sm | "%64" |
| Sunucu işliyor (100% sonrası yanıt bekleniyor) | ProgressBar belirsiz (indeterminate) | "İşleniyor…" |
| Tamamlandı | ✓ success-600 ikon | "Yüklendi" (success-700). 3 sn sonra satır kaybolur, kart grid'de belirir |
| Hatalı tür | ⚠ error-600 ikon, Badge `error` | "Bu dosya türü desteklenmiyor. {TIPLER} yükleyebilirsiniz." + "Kaldır" |
| Çok büyük | ⚠ | "Dosya çok büyük ({boyut}). En fazla {MAKS} yükleyebilirsiniz." + "Kaldır" |
| Ağ / sunucu hatası | ⚠ | "Yüklenemedi. Bağlantınızı kontrol edin." + "Tekrar dene" + "Kaldır" |
| Yetki (`403`) | ⚠ | "Görsel yükleme yetkiniz yok." + "Kaldır" |
| İptal edildi | Satır hemen kaldırılır | Live region: "kapak.jpg yüklemesi iptal edildi." |

Kuyruk başlığı "Yüklemeler (tamamlanan/toplam)"; tüm satırlar bitince ve hata yoksa kuyruk kendiliğinden kapanır. Hata varsa "Listeyi temizle" ile kapatılır.

### 6.3 Detay modalı

| Durum | Görünüm |
|-------|---------|
| Açılış | Liste verisi yeterliyse anında; ek veri gerekiyorsa sağ sütunda Skeleton |
| Silme sürüyor | ConfirmDialog kuralları (§7) |
| Silinmiş öğe (başka sekmede silinmiş) | Modal body'de `warning` Alert "Bu görsel artık yok." + "Kapat"; kapanınca grid yenilenir |

### 6.4 MediaPicker

| Durum | Görünüm |
|-------|---------|
| Yükleniyor | Body'de 10 skeleton kart; "Ekle" disabled |
| Boş kütüphane | Dropzone büyük varyantı body'nin tamamında; metin "Henüz görsel yok. İlk görseli yükleyin." |
| Liste hatası | Body'de `error` Alert + "Tekrar dene" |
| Seçim yok | "Ekle" disabled, alt metin alanı disabled |
| Seçili | Kart halkası + ✓; alt metin etkin; "Ekle" etkin |
| Picker içi yükleme | UploadItem satırları Dropzone altında; tamamlanan ilk görsel **otomatik seçilir** ve grid başına eklenir; live region "kapak.jpg yüklendi ve seçildi." |

---

## 7. Responsive

| Kırılım | Kütüphane | Detay modalı | Picker |
|---------|-----------|--------------|--------|
| < `sm` | Grid 2 sütun (`minmax(140px,1fr)`), aralık 12px. Dropzone compact metni kısalır: "Dosya seç" butonu + "{TIPLER}, en fazla {MAKS}" (dokunmatikte sürükle-bırak metni gösterilmez). "Yükle" butonu başlığın altında | Alttan sheet, tam genişlik; önizleme üstte (maks 40vh), meta altta tek sütun; footer butonları dikey ("Kapat" üstte, "Sil" en altta ayırıcıyla) | Alttan tam yükseklik sheet (95vh); grid 3 sütun; footer sabit |
| `sm`–`md` | 3–4 sütun | Modal `lg` sığmazsa tam genişlik − 32px; iki sütun | Modal |
| ≥ `md` | auto-fill 160px | §3.2 | §3.3, 4–5 sütun |

UploadItem mobilde iki satır: (önizleme + ad + aksiyon) / (ProgressBar veya mesaj).

---

## 8. Erişilebilirlik

- **Dropzone** gerçek bir `<input type="file" multiple accept="{mime listesi}">`'e bağlı; tüm alan bir `<label>` veya içindeki "dosya seçin" bir `<button>`'dır. Sürükle-bırak yalnız ek kolaylıktır; klavye kullanıcısı Tab → Enter/Space ile dosya seçicisini açar.
- `accept` filtresi istemci doğrulamasının yerine geçmez (kullanıcı "Tüm dosyalar"ı seçebilir).
- **Yükleme ilerlemesi:** ProgressBar `role="progressbar"` + `aria-valuenow`; her yüzde değişimi duyurulmaz. Live region (`role="status"`) yalnız durum değişimlerini duyurur: "kapak.jpg yükleniyor", "kapak.jpg yüklendi", "video.mp4 yüklenemedi: dosya türü desteklenmiyor".
- **Grid:** `<ul role="list">` içinde `<li>`; her kart tek bir `<button>` (kütüphane: detayı açar) ve erişilebilir adı dosya adıdır ("kapak.jpg, 1,2 MB"). Kart görselinin `alt=""` (ad zaten butonda).
- **Picker seçimi:** Grid `role="radiogroup"` (`aria-label="Görseller"`), her kart `role="radio"` + `aria-checked`; ok tuşları ile gezinme, Space ile seçim (roving tabindex; gruba tek Tab durağı). Seçili kart görsel olarak renk + ✓ ikonuyla belirtilir.
- **Detay modalı:** Başlık dosya adıdır; önizleme görselinin `alt`'ı "kapak.jpg önizlemesi".
- **CopyField:** Kopyalama sonrası buton etiketi "Kopyalandı" olur ve `role="status"` ile duyurulur; pano API'si başarısızsa alan metni seçili hale getirilir ve "Kopyalanamadı, metni elle kopyalayın." gösterilir.
- **Odak yönetimi:** Silme sonrası odak bir sonraki karta; "Daha fazla yükle" sonrası ilk yeni karta; picker kapanınca editöre.
- **Kontrast:** Dropzone kenarlığı varsayılan gray-500 kesikli (4.8:1), aktif brand-600; metinler gray-600/gray-0 7.6:1. Seçili kart halkası brand-600 6.3:1.
- **Hareket:** ProgressBar dolum animasyonu `duration-fast`; reduced-motion'da animasyonsuz atlar; belirsiz ilerleme reduced-motion'da sabit %100 soluk çubuk + "İşleniyor…" metni.
