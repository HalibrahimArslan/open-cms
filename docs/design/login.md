# Ekran: Giriş (Login)

> Sahibi: designer · Görev: TASK-004 · Rota: `/login`
>
> Bağımlılıklar: `tokens.md`, `components.md` (Button, Input, FormField, Alert, Spinner, Link), `admin-layout.md` (oturum ve yönlendirme kuralları).
> API: `POST /api/auth/login`, `GET /api/auth/me` (TASK-005, `docs/api.md`). Bu dokümandaki hata kodları **beklenen** davranıştır; nihai kodlar `docs/api.md`'ye göre eşlenir.

---

## 1. Amaç

Admin, editor ve author rolündeki kullanıcıların e-posta ve şifreyle admin paneline girmesi. Tek amaçlı, dikkat dağıtmayan bir ekran. Kayıt olma ve şifre sıfırlama MVP'de **yok** (kullanıcılar seed ile oluşturuluyor; bkz. Açık kararlar #4).

## 2. Kullanıcı akışları

### 2.1 Normal giriş

```
/login  ──(e-posta + şifre, "Giriş yap")──▶ POST /api/auth/login
   │                                              │
   │                         200 ─────────────────┤──▶ yönlendir: `next` (geçerliyse) yoksa `/admin`
   │                         401 ─────────────────┤──▶ Alert: "E-posta veya şifre hatalı." (şifre temizlenir)
   │                         429 ─────────────────┤──▶ Alert: çok fazla deneme
   │                         5xx / ağ hatası ─────┘──▶ Alert: sunucuya ulaşılamadı, girilen değerler korunur
```

### 2.2 Oturumsuz kullanıcı korumalı sayfaya gider

1. Kullanıcı `/admin/content` adresini açar, oturumu yok.
2. `/login?next=%2Fadmin%2Fcontent` adresine yönlendirilir. Ekranda **ek mesaj yok** (normal giriş ekranı).
3. Başarılı girişte `next` adresine döner.

### 2.3 Oturum süresi doldu

1. Kullanıcı panelde çalışırken bir API çağrısı `401` döner (ya da sayfa yenilemede `GET /api/auth/me` 401 döner).
2. `/login?next=<mevcut yol>&reason=expired` adresine yönlendirilir.
3. Formun üstünde `info` Alert: **"Oturumunuzun süresi doldu. Devam etmek için tekrar giriş yapın."**
4. E-posta alanı, son giriş yapan kullanıcının e-postasıyla **dolu gelmez** (paylaşılan bilgisayar gizliliği); odak e-posta alanındadır.
5. Başarılı girişte `next` adresine döner.

Kaydedilmemiş form verisinin korunması bu ekranın değil içerik formunun (TASK-008) konusudur; bkz. AÇIK SORU.

### 2.4 Çıkış sonrası

`UserMenu > Çıkış yap` → `/login?reason=logged_out` → `success` Alert: **"Çıkış yaptınız."** (role verilmez, sayfa yüklenirken zaten görünür).

### 2.5 Oturumu açık kullanıcı `/login`'e gelir

`GET /api/auth/me` 200 dönerse form gösterilmeden `/admin`'e (veya geçerli `next`'e) yönlendirilir. Kontrol sürerken: bkz. §5 "Oturum kontrolü".

### 2.6 `next` parametresi güvenliği

- Yalnızca `/admin` ile başlayan **göreli** yollar kabul edilir. `//`, `http:`, `https:` veya başka bir yol içeren `next` yok sayılır ve `/admin`'e gidilir (open redirect koruması).
- `reason` yalnızca `expired` ve `logged_out` değerlerini tanır; diğerleri yok sayılır.

---

## 3. Yerleşim

Admin layout **kullanılmaz** (sidebar/topbar yok). Arka plan `bg-app` (gray-50), içerik dikey ve yatay ortalı.

### 3.1 Masaüstü / tablet (≥ `sm`)

```
┌────────────────────────────────────────────────────────────────────────┐
│                                                                        │
│                                                                        │
│                         ◆ CMS                                          │ ← logo/ürün adı: text-xl/semibold gray-900, ortalı
│                                                                        │   kartın 32px üstünde
│             ┌────────────────────────────────────────┐                 │
│             │  Giriş yap                             │ ← h1: text-2xl/semibold, tracking-tight
│             │  Yönetim paneline erişmek için         │ ← text-sm gray-600
│             │  bilgilerinizi girin.                  │
│             │                                        │
│             │ ┌────────────────────────────────────┐ │
│             │ │ (!) E-posta veya şifre hatalı.     │ │ ← Alert (yalnız hata/bilgi varken)
│             │ └────────────────────────────────────┘ │
│             │                                        │
│             │  E-posta *                             │
│             │ ┌────────────────────────────────────┐ │
│             │ │ ornek@site.com                     │ │ ← Input type=email
│             │ └────────────────────────────────────┘ │
│             │                                        │
│             │  Şifre *                               │
│             │ ┌──────────────────────────────┬─────┐ │
│             │ │ ••••••••                     │ 👁  │ │ ← Şifre input'u + Göster/Gizle
│             │ └──────────────────────────────┴─────┘ │
│             │                                        │
│             │ ┌────────────────────────────────────┐ │
│             │ │            Giriş yap               │ │ ← Button primary lg, tam genişlik
│             │ └────────────────────────────────────┘ │
│             └────────────────────────────────────────┘
│                                                                        │
│             Erişim sorunu için site yöneticinize başvurun.             │ ← text-sm gray-600, ortalı
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

| Parça | Değer |
|-------|-------|
| Kart | `AuthCard` (bkz. components.md §13): bg-surface, 1px border-default, rounded-xl, shadow-sm, padding 32px (`8`), genişlik `max-w-auth` (400px) |
| Başlık bloğu → form | 24px (`6`) |
| Alert → ilk alan | 16px (`4`) |
| Alanlar arası | 16px (FormField kuralı) |
| Son alan → buton | 24px (`6`) |
| Sayfa dikey konum | Kart viewport'ta dikey ortalı; viewport kısaysa üstten 48px boşlukla başlar ve sayfa kayar |

### 3.2 Mobil (< `sm`)

```
┌──────────────────────────┐
│                          │
│  ◆ CMS                   │ ← üstten 48px, sola hizalı
│                          │
│  Giriş yap               │
│  Yönetim paneline        │
│  erişmek için ...        │
│                          │
│  E-posta *               │
│ ┌──────────────────────┐ │
│ └──────────────────────┘ │
│  Şifre *                 │
│ ┌──────────────────┬───┐ │
│ └──────────────────┴───┘ │
│ ┌──────────────────────┐ │
│ │      Giriş yap       │ │
│ └──────────────────────┘ │
│                          │
│  Erişim sorunu için ...  │
└──────────────────────────┘
```

- Kartın kenarlığı, gölgesi ve arka plan farkı kalkar; form doğrudan `bg-surface` sayfada, yatay padding 16px.
- Yazılım klavyesi açıldığında buton görünür kalmalı: form sayfa akışındadır (fixed konumlu öğe yok).

---

## 4. Bileşenler

| Bileşen | Kaynak | Ayar |
|---------|--------|------|
| AuthCard | components.md §13 (yeni) | — |
| FormField + Input (e-posta) | §2, §3 | `type="email"`, `autocomplete="username"`, `inputmode="email"`, `autocapitalize="none"`, `spellcheck="false"`, `required` |
| FormField + Input (şifre) | §2 şifre varyantı | `type="password"`, `autocomplete="current-password"`, `required`; Göster/Gizle butonu `aria-pressed` |
| Button | §1 | `primary`, `lg`, tam genişlik, `type="submit"`, metin "Giriş yap" |
| Alert | §10 | `error` / `info` / `success` / `warning` |
| Spinner | §9 | Buton içi `sm`; oturum kontrolünde `lg` |

Kasıtlı olarak **olmayanlar** (MVP):
- "Beni hatırla" checkbox'ı — oturum süresi backend kararıdır (bkz. AÇIK SORU).
- "Şifremi unuttum" linki — e-posta altyapısı yok; yerine alt metin "Erişim sorunu için site yöneticinize başvurun."
- "Kayıt ol" linki.

---

## 5. Durumlar

| Durum | Tetikleyici | Görünüm | Davranış |
|-------|-------------|---------|----------|
| Oturum kontrolü | Sayfa açılışı, `GET /api/auth/me` sürüyor | Ortada `Spinner lg` + sr-only "Yükleniyor…". 300ms'den kısa sürerse hiçbir şey gösterilmez (boş `bg-app`) | 200 → yönlendir; 401 → formu göster; ağ hatası → formu göster (giriş denemesi hatayı zaten yakalar) |
| Varsayılan | — | Boş form, Alert yok | Odak e-posta alanında (`autofocus`; sayfanın tek amacı bu olduğu için kabul edilir) |
| İstemci doğrulama hatası | Gönderimde boş alan / geçersiz e-posta formatı | Alan altı hata: "E-posta adresini girin." · "Geçerli bir e-posta adresi girin." · "Şifreyi girin." Formun üstünde `error` Alert **gösterilmez** (2 alanlık form; alan hatası yeterli) | İstek atılmaz; odak ilk hatalı alana taşınır. İlk gönderimden önce yalnızca blur'da doğrulama (FormField kuralı) |
| Gönderiliyor | Geçerli form gönderildi | Buton loading (Spinner `sm`, genişlik sabit); alanlar `readonly` (disabled değil — değerler okunabilir kalır) | `aria-busy="true"` formda; çift gönderim engellenir |
| Geçersiz bilgi | `401` | `error` Alert: başlık **"E-posta veya şifre hatalı."** açıklama yok. Alanlar `aria-invalid` **yapılmaz** (hangisinin yanlış olduğu söylenmez) | Şifre alanı temizlenir; e-posta korunur; odak Alert'e (`tabindex="-1"`, `role="alert"`), sonraki Tab şifre alanına gider |
| Çok fazla deneme | `429` | `warning` Alert: **"Çok fazla başarısız deneme."** açıklama: "Lütfen birkaç dakika sonra tekrar deneyin." (API bekleme süresi dönerse: "{n} dakika sonra tekrar deneyin.") | Buton süre boyunca disabled değil (süre bilinmiyorsa); tekrar denemede aynı yanıt gelir |
| Ağ hatası | İstek hiç ulaşmadı / zaman aşımı | `error` Alert: **"Sunucuya ulaşılamadı."** açıklama: "İnternet bağlantınızı kontrol edip tekrar deneyin." | **Her iki alan da korunur**; odak Alert'e; tekrar "Giriş yap" ile denenir |
| Sunucu hatası | `5xx` | `error` Alert: **"Giriş şu anda yapılamıyor."** açıklama: "Bir sorun oluştu. Biraz sonra tekrar deneyin." | Her iki alan korunur |
| Hesap devre dışı | (API böyle bir kod dönerse, ör. `403`) | `error` Alert: "Hesabınız devre dışı. Site yöneticinize başvurun." | Şifre temizlenir. MVP'de bu durum yoksa uygulanmaz |
| Oturum süresi doldu | `?reason=expired` | `info` Alert (role yok) | Bkz. §2.3 |
| Çıkış yapıldı | `?reason=logged_out` | `success` Alert (role yok) | Bkz. §2.4 |
| Başarılı | `200` | Buton loading kalır | Yönlendirme tamamlanana kadar form gönderilemez; ekstra başarı mesajı yok |

Kural: Aynı anda tek Alert gösterilir. Yeni gönderimde önceki Alert kaldırılır; `reason` Alert'i ilk gönderimde kaybolur.

---

## 6. Responsive

| Kırılım | Davranış |
|---------|----------|
| < `sm` | Kartsız, tam genişlik form, padding 16px, logo sola hizalı |
| ≥ `sm` | Ortalı 400px kart |
| Yatay telefon / kısa viewport | Dikey ortalama yerine üstten başlar, sayfa kayar |
| Yakınlaştırma %200 / 320px genişlik | Yatay kaydırma yok; buton metni tek satır ("Giriş yap") |

---

## 7. Erişilebilirlik

- `<main>` içinde tek `<h1>` "Giriş yap". Sayfa `<title>`: "Giriş yap — CMS".
- Görünür etiketler; placeholder etiket yerine kullanılmaz (e-posta placeholder'ı yalnız örnek: `ornek@site.com`).
- Tab sırası: E-posta → Şifre → Göster/Gizle → Giriş yap. Enter her alandan formu gönderir.
- Göster/Gizle butonu `type="button"`, `aria-label` duruma göre "Şifreyi göster"/"Şifreyi gizle", `aria-controls` şifre alanına.
- Hata mesajları yalnız renkle değil, ikon + metinle verilir; Alert `role="alert"` ile duyurulur.
- Şifre yöneticileri için `autocomplete` değerleri doğru; form `method="post"` ve `<form>` öğesi kullanılır.
- Kontrast: başlık gray-900/gray-0 17.9:1, yardım metni gray-600/gray-50 ~7.2:1 (mobilde gray-0 üstünde 7.6:1), primary buton 6.3:1.
- Hareket: Alert geçişi yok (reduced-motion fark etmez); yalnız buton spinner'ı döner.
