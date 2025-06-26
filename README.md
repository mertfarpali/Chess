# ♟️ ChessApp - Satranç Oyunu (iOS)

SwiftUI ile geliştirilen bu satranç uygulaması; tek oyunculu (bot’a karşı), iki oyunculu ve öğretici modlarıyla tam özellikli bir deneyim sunar. Kullanıcılar satranç taşlarının hareketlerini öğrenebilir, farklı zorluk seviyelerinde botlara karşı oynayabilir ve ana menüden tüm bu modlara kolayca erişebilir.

---

## 📱 Özellikler

- ✅ Tek oyunculu mod (Bot’a karşı)
- ✅ Farklı bot zorlukları: Kolay, Orta, Zor, Efsanevi
- ✅ İki oyunculu mod (aynı cihazda)
- ✅ Öğretici mod (taşları tanı ve deneme yap)
- ✅ Gerçekçi UI ve taş ikonları
- ✅ Ana menüye dönüş ve geçiş kontrolü
- ✅ Minimax algoritması ile akıllı bot davranışı

---

## 📁 Proje Yapısı

### `Models/`

| Dosya                | Açıklama |
|---------------------|----------|
| `ChessPiece.swift`  | Satranç taşının tipi ve rengi (`PieceType`, `PieceColor`) |
| `Position.swift`    | Tahtadaki bir pozisyonu temsil eder (`row`, `column`) |
| `GameMode.swift`    | Oyun modlarını (`singlePlayer`, `twoPlayers`) tanımlar |
| `BotDifficulty.swift` | Bot’un zorluk seviyeleri (`easy`, `medium`, `hard`, `legendary`) |

---

### `ViewModels/`

| Dosya                      | Açıklama |
|---------------------------|----------|
| `ChessBoardViewModel.swift` | Oyun mantığı, geçerli hamle kontrolü, taş hareketi, bot hamlesi ve oyun durumu kontrolü yapılır. |

---

### `Views/`

| Dosya                       | Açıklama |
|----------------------------|----------|
| `ContentView.swift`        | Ana menü arayüzü. Oyun modları ve sayfa geçişleri. |
| `DifficultyPickerView.swift` | Tek oyunculu modda zorluk seviyesi seçimi (sheet). |
| `ChessBoardView.swift`     | Satranç tahtasının çizimi, kullanıcı etkileşimi ve oyun arayüzü. |
| `TutorialView.swift`       | Eğitim ekranı: her taş için bilgi ve örnek. |
| `TutorialBoardView.swift`  | Eğitim tahtası: kullanıcı taş hamlesini deneyerek öğrenir. |
| `TutorialTileView.swift`   | Her taşın açıklamasını içeren bilgi kutusu. |

---

### `Assets/`

- Satranç ikonları, taş sembolleri, renk temaları, app ikonları vb.

---

## 🤖 Bot Zorluk Seviyeleri

| Seviye     | Strateji Açıklaması |
|------------|---------------------|
| `easy`     | Rastgele hamle |
| `medium`   | En değerli taşı alma odaklı |
| `hard`     | 1 seviye derinlikli `minimax` |
| `legendary`| 2 seviye derinlikli `minimax` + taş değeri değerlendirmesi |

---

## 🎓 Öğretici Mod

Taş tanıtımı ve hamle denemesi:

1. **Teorik açıklama** (`TutorialTileView`)
2. **Uygulamalı deneme** (`TutorialBoardView`)
   - Geçerli tüm hedef karelerde doğru hamle vurgulanır.
   - Doğru/yanlış geri bildirimi ekranda gösterilir.

---

## 🧠 İleri Geliştirme Fikirleri

- Zamanlı mod (Blitz, Rapid)
- Online eşli oyun (multiplayer)
- Taş temaları (modern, klasik vs.)
- Geri alma / ileri alma özelliği
- Oyun kaydetme / yükleme
- iCloud ile eşzamanlama

---

## 🚀 Başlangıç

1. Xcode ile projeyi aç
2. `ChessApp.swift` içinden uygulamayı başlat
3. `Simulator` veya gerçek cihazda test et

---

## 👤 Author

**Mert Fırat Arpalı**

- 🧑‍💻 GitHub: [@mertfarpali](https://github.com/mertfarpali)
- 🎮 Proje: [Runner - Endless Runner Game](https://github.com/mertfarpali/Runner)

---
