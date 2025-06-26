# 2D Satranç Oyunu - Whitepaper

## 1. Proje Özeti

SwiftUI kullanarak geliştirilecek olan bu 2D satranç oyunu, klasik satranç kurallarına uygun, interaktif ve modüler bir yapıda olacak. Oyun, kullanıcıya karşı oyun (PvE) ve ileride geliştirilecek yapay zekâ entegrasyonuna uygun mimariyle hazırlanacaktır.

## 2. Amaç ve Hedefler

* Satranç mantığının tam ve doğru bir şekilde uygulanması
* Şık ve sade bir SwiftUI arayüzü
* Genişletilebilir bir oyun motoru (gelecekte 3D veya online oynanabilirlik için altyapı)

## 3. Temel Özellikler

* 8x8 satranç tahtası
* Taş türleri ve renkleri
* Geçerli hamle kontrolü
* Şah ve Şah mat algılaması
* Oyuncu sırası kontrolü
* Hamle geçmişi

## 4. Teknik Mimari

* **Model**: Taş tipi (`enum ChessPiece`), konum (`struct Position`), tahta (`class ChessBoard`)
* **View**: SwiftUI tabanlı grid yapısı, draggable taşlar
* **ViewModel**: Hamle kontrol mantığı, oyunun durumu, şah-mat tespiti

## 5. Kullanılan Teknolojiler

* Swift 5.10+
* SwiftUI (iOS 17)
* Xcode 15+
* MVVM mimarisi

## 6. Yol Haritası

1. Taş ve tahta modellemesi
2. SwiftUI arayüzü ve grid yapısı
3. Hamle kontrol ve kurallar
4. Şah/şah mat algısı
5. Hamle geçmişi ve sıra takibi
6. Gelişmiş UX: animasyonlar, vurgular
7. Yapay zekâ için altyapı planlaması

## 7. Gelecek Geliştirmeler (Opsiyonel)

* 3D geörüntüleme (SceneKit)
* Online multiplayer (Game Center)
* Yapay zekâ rakip (minimax, MCTS)
* Temalar ve skin desteği
