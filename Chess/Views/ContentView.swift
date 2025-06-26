import SwiftUI

struct ContentView: View {
    @State private var selectedMode: GameMode? = nil
    @State private var showDifficultyPicker = false

    var body: some View {
        if let mode = selectedMode {
            ChessBoardView(
                viewModel: ChessBoardViewModel(mode: mode),
                onExitToMenu: {
                    selectedMode = nil // 🔹 Ana menüye dönüldüğünde sıfırla
                }
            )
        } else {
            VStack(spacing: 20) {
                Text("Satranç").font(.largeTitle).bold()

                Button("Tek Oyuncu (Bot’a Karşı)") {
                    showDifficultyPicker = true
                }

                Button("İki Oyuncu (Aynı Cihazda)") {
                    selectedMode = .twoPlayers
                }
            }
            .sheet(isPresented: $showDifficultyPicker) {
                VStack(spacing: 16) {
                    Text("Zorluk Seviyesi Seç")
                        .font(.title2)
                        .bold()

                    ForEach(BotDifficulty.allCases, id: \.self) { level in
                        Button(level.rawValue) {
                            selectedMode = .singlePlayer(difficulty: level)
                            showDifficultyPicker = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    }

                    Button("İptal", role: .cancel) {
                        showDifficultyPicker = false
                    }
                }
                .padding()
            }
        }
    }
}
