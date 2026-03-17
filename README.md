# Proje Adı: Flutter ve Temiz Mimari (Clean Architecture) ile Kimlik Doğrulama Modülü

## Açıklama
Bu proje, Flutter çerçevesi ve durum yönetimi (BLoC/Cubit) kullanılarak geliştirilmiş bir kullanıcı kimlik doğrulama sistemidir. İletmiş olduğunuz yapı itibarıyla uygulama, Temiz Mimari (Clean Architecture) prensiplerine uygun olarak özellik bazlı (feature-driven) dizin yapısı ile tasarlanmıştır. Bu yapı; veri, iş mantığı ve sunum katmanlarını birbirinden izole ederek yüksek ölçeklenebilirlik, test edilebilirlik ve sürdürülebilirlik sağlamayı hedeflemektedir.

## Kullanılan Teknolojiler ve Paketler
* **Flutter:** Çapraz platform mobil uygulama geliştirme çerçevesi.
* **flutter_bloc:** Durum yönetimi mimarisi (BLoC ve Cubit) entegrasyonu.
* **Firebase Auth:** Uzak sunucu tabanlı kullanıcı kimlik doğrulama altyapısı (Veri katmanındaki isimlendirmeden referans alınmıştır).
* **equatable:** Durum (state) nesnelerinin bellek adresleri yerine içeriklerine göre karşılaştırılmasını sağlamak amacıyla kullanılmaktadır.

## Mimari Yapı ve Katmanlar
Proje, "auth" (kimlik doğrulama) özelliği altında üç temel katmana ayrılmıştır:

1. **Domain (Etki Alanı) Katmanı:** Uygulamanın temel iş kurallarını barındırır. Herhangi bir dış servise bağımlılığı yoktur. Çekirdek veri modellerini (`entities/app_user.dart`) ve veri erişim arayüzlerini/kontratlarını (`repos/auth_repo.dart`) içerir.
2. **Data (Veri) Katmanı:** Domain katmanında tanımlanan soyut arayüzlerin (interface) somut uygulamalarını (implementation) barındırır. Dış servislerle (Firebase vb.) iletişimi bu katman sağlar (`firebase_auth_repo.dart`).
3. **Presentation (Sunum) Katmanı:** Kullanıcı arayüzünü ve uygulamanın durum yönetimini içerir. Ekranlar (`pages`), tekrar kullanılabilir arayüz bileşenleri (`components`) ve iş mantığı ile arayüz arasındaki veri akışını yöneten durum yöneticileri (`cubits`) bu katmanda yer almaktadır.

## Proje Dizini
İlgili mimariye uygun şekilde güncellenmiş dizin yapısı aşağıdaki gibidir:

```text
lib/
└── features/
    └── auth/
        ├── data/
        │   └── firebase_auth_repo.dart
        ├── domain/
        │   ├── entities/
        │   │   └── app_user.dart
        │   └── repos/
        │       └── auth_repo.dart
        └── presentation/
            ├── components/
            ├── cubits/
            └── pages/
```

## Kurulum ve Çalıştırma
Projeyi yerel geliştirme ortamınızda çalıştırmak için aşağıdaki adımları izleyiniz:

1. **Depoyu Klonlayın:**
   ```bash
   git clone https://github.com/furkanteber/bloclogin.git
   ```

2. **Proje Dizinine Geçiş Yapın:**
   ```bash
   cd <proje_klasoru>
   ```

3. **Gerekli Bağımlılıkları Yükleyin:**
   ```bash
   flutter pub get
   ```

4. **Uygulamayı Çalıştırın:**
   ```bash
   flutter run
   ```

## Çalışma Mantığı
* Kullanıcı etkileşimleri, `presentation/pages` altındaki arayüzler üzerinden gerçekleşir.
* Kullanıcı giriş yapmak istediğinde, arayüz üzerinden ilgili `Cubit` veya `BLoC` sınıfına bir tetikleyici gönderilir.
* Durum yöneticisi (Cubit), `domain/repos/auth_repo.dart` üzerinden ilgili fonksiyonu çağırır.
* Bu arayüzün somut karşılığı olan `firebase_auth_repo.dart`, uzak sunucuya (Firebase) giderek kimlik doğrulama işlemini gerçekleştirir.
* Sunucudan dönen yanıt, `app_user.dart` varlık (entity) modeline dönüştürülerek durum yöneticisine iletilir.
* Durum yöneticisi, işlemin başarısına veya başarısızlığına göre yeni bir durum (state) yayar ve kullanıcı arayüzü bu yeni duruma göre güncellenir.
