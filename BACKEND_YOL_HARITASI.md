# Quantum Restaurant - Backend Yol Haritasi

Bu dokuman, Flutter istemcisindeki mevcut ekranlar ve servis cagri akislari baz alinarak backend ekibi icin hazirlanmistir.
Amac: backend tarafinda API sozlesmesini netlestirmek, eksik endpointleri onceliklendirmek ve uc uca test plani cikarmak.

Tarih: 18 Nisan 2026

## 1) Kapsam ve Incelenen Ekranlar

Aktif is akisinda backend ile en kritik baglantisi olan ekranlar:

- Giris: lib/features/presentation/pages/login/login.dart
- Masa listesi ve filtreleme: lib/features/presentation/pages/home/home_view.dart
- Adisyon ana ekrani: lib/features/presentation/pages/adisyon/adisyon_main.dart
- Urun miktar/secenek popup: lib/features/presentation/pages/adisyon/adisyon_miktar.dart
- Siparis aciklama popup: lib/features/presentation/pages/dialog_aciklama_siparis.dart
- Masa aktarma popup: lib/features/presentation/pages/dialogmasa_aktar.dart

Not: lib/features/presentation/pages/home_page.dart daha eski bir akis gibi gorunuyor, ancak route icinde halen tanimli. Yeni akis home/home_view.dart ve adisyon/adisyon_main.dart etrafinda.

## 2) Genel Teknik Mimari (Backend'i ilgilendiren kisim)

- Tum HTTP cagrilari Dio ile yapiliyor.
- Base URL runtime'da ayarlaniyor: Settings.getApiAdres()
- Tum istekler HTTP (HTTPS degil) olarak gidiyor.
- Auth header anahtari: Auth
- Header standardi:
  - Content-Type: application/json
  - Auth: <token>
- Login harici endpointlerde token zorunlu bekleniyor.

Kaynak dosya: lib/features/data/dataSources/remote/http_services.dart

## 3) Ekran Bazli Is Akisi ve Backend Beklentisi

### 3.1 Login Akisi

UI davranisi:

1. Kullanici email + parola girer.
2. POST RestLogin/login cagrilir.
3. Donen cevap string token olarak parse edilir.
4. Token alinirsa:
   - Settings.token set edilir.
   - Garson bilgisi localde set edilir (su an sabit id=1).
   - Ilk acilista urun ve kategori listesi preload edilir.

Backend beklentisi:

- Login endpointi 200 dondugunde response body dogrudan token string olmali.
- Hatali durumda 4xx/5xx donmeli, body okunabilir hata mesaji icermeli.

### 3.2 Masa Secim Ekrani

UI davranisi:

- Masa gruplari cekilir.
- Secili filtreye gore masalar cekilir:
  - Tum masalar
  - Acik/Kapali durum
  - Garsona ait masalar
- Arama ve grup filtreleme istemci tarafinda yapiliyor.

Backend beklentisi:

- Masalar endpointi surekli ve hizli donmeli (ana ekran oldugu icin).
- Masa modeli asagidaki alanlari tutarli donmeli:
  Id, Adi, KisiSayisi, AcanGarson, MasaDurumu, MasaAcik, Toplam, SonUrun, SureDk, AcilisZaman, AdisyonYazildi, GrupAdi

### 3.3 Adisyon Ekrani

UI davranisi:

- Masaya ait adisyon satirlari cekilir.
- Kategoriler local cache uzerinden listelenir.
- Urun ekle/guncelle/sil islemleri yapilir.
- Mutfak yazdirma ve adisyon yazdirma tetiklenir.
- Masa aktarma akisi tetiklenebilir.

Backend beklentisi:

- Siparis ekleme ve guncelleme ayni endpointten yapiliyor (Id alanina gore).
- Silme endpointi satir bazli calismali.
- Yazdirma endpointleri idempotent olursa (birden cok cagrida guvenli) UI daha stabil olur.

### 3.4 Miktar/Secenek Popup

UI davranisi:

- Miktar adimlari (1 veya 0.5) secilir.
- Varsa urun seceneklerinden tek secim zorunlu tutulur.
- Kaydette AdisyonModel ile saveOrder/updateOrder cagrilir.

Backend beklentisi:

- Miktar decimal desteklemeli.
- Secenek alani bos veya dolu gelebilir.
- KisiSayisi alani her kayitta gecerli is kuraliyla dogrulanmali.

### 3.5 Aciklama Popup

UI davranisi:

- Siparis detay satirina aciklama yazilir.
- POST RestOrderV1/postdetails cagrilir.

Backend beklentisi:

- Ozellik1 alani aciklama olarak saklanir.
- Hedef siparis/detay kaydi Id ile bulunur.

### 3.6 Masa Aktarma Popup

UI davranisi:

- Tum masalar listelenir.
- Secilen masaya adisyon transferi icin PostReplaceMasa cagrilir.

Backend beklentisi:

- Kaynak masa Id ve hedef masa Id ile atomik transfer gerekir.
- Eszamanli islemde veri kaybi olmamali.

## 4) Endpoint Sozlesmesi (Mevcut Koddan Cikarilan)

### 4.1 Auth ve Login

- POST /RestLogin/login
  - Body:
    - Email: string
    - Parola: string
  - Beklenen response:
    - 200: token string

### 4.2 Masa Isleri

- GET /RestTablesV1/get
  - Tum masalar
- GET /RestTablesV1/GetGarson?GarsonId={garsonId}
  - Garsona ait masalar
- GET /RestTablesV1/GetStatus?Status={status}
  - status: 0 kapali, 1 acik
- GET /RestTablesV1/GetMasaGruplari
  - Masa grup listesi

### 4.3 Urun ve Kategori

- GET /ItemsV1/get
  - Tum urunler
- GET /ItemsV1/GetCategories?KategoriKodu={kategoriKodu}
  - Kategoriye gore urunler
- GET /ItemsCategoriV1/get
  - Tum kategoriler

### 4.4 Adisyon/Siparis

- GET /RestOrderV1/get
  - Tum siparis satirlari (genel)
- GET /RestOrderV1/get/{masaId}
  - Masaya ait siparis satirlari
- POST /RestOrderV1/post
  - Yeni siparis veya guncelleme (Id'ye gore)
- POST /RestOrderV1/postdetails
  - Siparis detay/aciklama guncelleme
- DELETE /RestOrderV1/delete/{id}
  - Siparis satiri silme
- DELETE /RestOrderV1/deleteprint/{id}
  - Adisyon yazdirma durumu
- DELETE /RestOrderV1/deleteprintall/{id}
  - Mutfak/bar yazdirma durumu
- POST /RestOrderV1/PostReplaceMasa
  - Masa transferi
  - Body:
    - Id: string (kaynak masa id)
    - YeniId: string (hedef masa id)

## 5) Veri Modeli Beklentileri

### 5.1 TableItemModel

Zorunluya yakin alanlar:

- Id: int
- Adi: string
- MasaAcik: bool
- AdisyonYazildi: bool
- GrupAdi: string

UI'de gorunen ek alanlar:

- AcanGarson, SureDk, SonUrun, Toplam, MasaDurumu, AcilisZaman, KisiSayisi

### 5.2 CardItemModel (Adisyon satiri)

- Id: int
- Adi: string
- Fiyat: number
- Miktar: number (decimal)
- Secenek: string
- Ozellik1, Ozellik2, Ozellik3: string

### 5.3 AdisyonModel (POST payload)

- Id: int
- Adi: string
- Fiyat: number
- Miktar: number
- Ozellik1: string
- Ozellik2: string
- Ozellik3: string
- KisiSayisi: int
- MalzemeId: int
- MasaId: int
- Secenek: string

Not: UI tarafinda bazi alanlar bos string veya 0 olarak gonderiliyor. Backend default handling ve validation net olmali.

## 6) Kritik Riskler ve Teknik Borclar (Backend Etkili)

1. HTTP kullanimi var, HTTPS yok.
   - Uretimde token plain text tasinma riski.

2. Hata yonetimi zayif.
   - Cogu yerde sadece bool donuluyor, detay hata kodu kayboluyor.

3. Login response tipi string'e bagli.
   - Token JSON obje donerse mevcut istemci parse kirilabilir.

4. Adisyon POST hem create hem update icin kullaniliyor.
   - Id semantigi net degilse veri tutarsizligi olusabilir.

5. Yazdirma endpointleri DELETE ile isimlendiriliyor.
   - Semantik olarak command endpoint (POST) daha uygun olabilir.

6. GarsonId login sonrasi sabit 1 set ediliyor.
   - Gercek kullanici-rol eslesmesi backend tarafinda zorunlu kontrol edilmeli.

## 7) Backend Ekibi icin Oncelikli Yol Haritasi

### Faz 1 - Sozlesme Dondurma (1-2 gun)

- Login response formatini kesinlestir (string mi object mi).
- RestOrderV1/post endpointinde create-update kurali netlestir.
- Tum endpointler icin zorunlu alanlar, nullable kurali, hata kodu tablosu cikart.
- Auth header standardini dokumante et (Auth Bearer benzeri).

Cikti:
- V1 API sozlesme dokumani
- Ornek request/response payloadlari

### Faz 2 - Guvenilirlik ve Is Kurallari (2-4 gun)

- Masa transferini atomik isleme al.
- Yazdirma endpointlerinde idempotency garantisi sagla.
- Decimal miktar ve secenek validation kurallarini ekle.
- Yetki kontrolunu endpoint bazinda netlestir (garson sadece kendi islemleri gibi).

Cikti:
- Is kurali testleri
- 4xx/5xx hata sozlugu

### Faz 3 - Go-Live Sertlestirme (2-3 gun)

- HTTPS zorunlulugu.
- Sunucu tarafi request log correlation id.
- Kritik endpointler icin performans hedefi:
  - Masa listesi < 500ms (P95)
  - Masa bazli adisyon cekme < 500ms (P95)

Cikti:
- Production readiness checklist
- Monitoring alarmlari

## 8) Uc Uca Test Senaryolari (Backend + Mobil Ortak)

1. Basarili login
2. Hatali login (yanlis parola)
3. Tum masa listesi cekme
4. Acik/Kapali masa filtreleme
5. Garsona ait masa listeleme
6. Masa adisyon listesi cekme
7. Urun ekleme (seceneksiz)
8. Urun ekleme (secenekli)
9. Urun guncelleme (miktar degisikligi)
10. Urun silme
11. Siparise aciklama girme
12. Adisyon yazdirma tekrar cagrisi
13. Mutfak yazdirma tekrar cagrisi
14. Masa transferi (hedef masa dolu/bos varyasyon)

## 9) Backend'e Hemen Acilacak Is Kartlari

- API-01: RestLogin/login response contract netlestirme
- API-02: RestOrderV1/post create-update ayrimi ve Id kurali
- API-03: RestOrderV1/postdetails validation (Id, Ozellik1)
- API-04: RestOrderV1/PostReplaceMasa atomik transfer
- API-05: Yazdirma endpointlerinde idempotent davranis ve loglama
- API-06: Tum endpointler icin standart hata modeli (code, message, detail)
- API-07: HTTPS ve auth policy sertlestirme

## 10) Mobil Tarafindan Beklenen Backend Iyilestirmeleri

- Bool yerine anlamli response modeli:
  - success
  - code
  - message
  - data
- Hata kodlari sabitlenirse mobil UI daha iyi kullanici mesaji verebilir.
- Tarih/saat alanlari timezone bilgisi ile dondurulmeli.

## 11) Sonuc

Mevcut mobil kod, backend tarafinda temel restoran akislarini kullanabilir durumda; ancak sozlesme netligi, hata modeli ve guvenlik sertlestirmesi tamamlanmadan uretim kalitesi riskli.
En kritik adim: RestOrderV1 ve RestTablesV1 endpointlerinin davranisini yazili sozlesme ile dondurmak.
