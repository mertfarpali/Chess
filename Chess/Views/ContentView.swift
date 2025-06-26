import SwiftUI

struct ContentView: View {
    @State private var selectedMode: GameMode? = nil
    @State private var showDifficultyPicker = false
    @State private var showTutorial = false
    @State private var selectedTheme: PieceTheme = .classic

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .gray.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("♟ Satranç Dünyasına")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Text("Hoş Geldiniz")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))

                // Tema Seçimi
                VStack {
                    Text("Tema Seçin")
                        .font(.headline)
                        .foregroundColor(.white)
                    Picker("", selection: $selectedTheme) {
                        ForEach(PieceTheme.allCases) { theme in
                            Text(theme.rawValue.capitalized).tag(theme)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }

                // Mod Seçimleri
                VStack(spacing: 16) {
                    Button("Tek Oyuncu (Bot’a Karşı)") {
                        showDifficultyPicker = true
                    }
                    .buttonStyle(ChessButtonStyle())

                    Button("İki Oyuncu (Aynı Cihazda)") {
                        selectedMode = .twoPlayers
                    }
                    .buttonStyle(ChessButtonStyle())

                    Button("📘 Öğretici") {
                        showTutorial = true
                    }
                    .buttonStyle(ChessButtonStyle())
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        // Zorluk seçimi sayfası
        .sheet(isPresented: $showDifficultyPicker) {
            DifficultyPickerView { level in
                selectedMode = .singlePlayer(difficulty: level)
                showDifficultyPicker = false
            }
        }
        // Öğretici tam ekran
        .fullScreenCover(isPresented: $showTutorial) {
            TutorialView()
        }
        // Oyun ekranı tam ekran açılır
        .fullScreenCover(item: $selectedMode) { mode in
            ChessBoardView(
                viewModel: ChessBoardViewModel(mode: mode, theme: selectedTheme),
                onExitToMenu: {
                    selectedMode = nil
                }
            )
        }
    }
}

struct ChessButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(configuration.isPressed ? 0.3 : 0.2))
            .cornerRadius(10)
            .foregroundColor(.black)
            .shadow(radius: configuration.isPressed ? 0 : 3)
    }
}
