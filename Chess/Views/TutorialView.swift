import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @State private var step = 0
    @State private var instructionText = "Satranç taşlarını tanıyalım!"

    var body: some View {
        VStack(spacing: 20) {
            Text("📘 Satranç Öğretici")
                .font(.largeTitle).bold()
                .padding()

            Text(instructionText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
            stepView()
            Spacer()

            if step < 6 {
                Button("İleri") {
                    step += 1
                    instructionText = getStepTitle(step)
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding()
    }

    @ViewBuilder
    func stepView() -> some View {
        switch step {
        case 0: step0View()
        case 1: step1View()
        case 2: step2View()
        case 3: step3View()
        case 4: step4View()
        case 5: step5View()
        default:
            VStack(spacing: 12) {
                Text("🎉 Tebrikler! Satranç taşlarını öğrendiniz.")
                    .font(.title)
                Button("Ana Menüye Dön") { dismiss() }
                    .padding().background(Color.green.opacity(0.2)).cornerRadius(8)
            }
        }
    }

    func step0View() -> some View {
        tutorialStep(
            piece: .pawn, start: Position(row: 1, column: 4),
            valid: [
                Position(row: 2, column: 4),
                Position(row: 3, column: 4)
            ],
            text: "Piyon sadece ileri gider. İlk hamlede iki kare ilerleyebilir."
        )
    }

    func step1View() -> some View {
        tutorialStep(
            piece: .knight, start: Position(row: 4, column: 4),
            valid: [
                Position(row: 6, column: 5), Position(row: 6, column: 3),
                Position(row: 2, column: 5), Position(row: 2, column: 3),
                Position(row: 5, column: 6), Position(row: 5, column: 2),
                Position(row: 3, column: 6), Position(row: 3, column: 2)
            ],
            text: "At 'L' şeklinde gider ve üzerinden atlayabilir."
        )
    }

    func step2View() -> some View {
        tutorialStep(
            piece: .bishop, start: Position(row: 3, column: 3),
            valid: [
                Position(row: 4, column: 4), Position(row: 5, column: 5),
                Position(row: 6, column: 6), Position(row: 2, column: 2),
                Position(row: 1, column: 1), Position(row: 0, column: 0),
                Position(row: 4, column: 2), Position(row: 5, column: 1),
                Position(row: 2, column: 4), Position(row: 1, column: 5),
                Position(row: 0, column: 6)
            ],
            text: "Fil diagonalde yani çapraz hareket eder."
        )
    }

    func step3View() -> some View {
        tutorialStep(
            piece: .rook, start: Position(row: 0, column: 0),
            valid: [
                Position(row: 1, column: 0), Position(row: 2, column: 0),
                Position(row: 3, column: 0), Position(row: 4, column: 0),
                Position(row: 5, column: 0), Position(row: 6, column: 0),
                Position(row: 7, column: 0),
                Position(row: 0, column: 1), Position(row: 0, column: 2),
                Position(row: 0, column: 3), Position(row: 0, column: 4),
                Position(row: 0, column: 5), Position(row: 0, column: 6),
                Position(row: 0, column: 7)
            ],
            text: "Kale yatay ve dikey doğrultuda gider."
        )
    }

    func step4View() -> some View {
        tutorialStep(
            piece: .queen, start: Position(row: 0, column: 3),
            valid: [
                // birleşik yatay/dikey/çapraz…
                Position(row: 1, column: 3), Position(row: 2, column: 3), Position(row: 3, column: 3),
                Position(row: 0, column: 2), Position(row: 0, column: 1), Position(row: 0, column: 0),
                Position(row: 0, column: 4), Position(row: 0, column: 5), Position(row: 0, column: 6), Position(row: 0, column: 7),
                Position(row: 1, column: 2), Position(row: 2, column: 1), Position(row: 3, column: 0),
                Position(row: 1, column: 4), Position(row: 2, column: 5), Position(row: 3, column: 6),
                Position(row: 1, column: 3), Position(row: 2, column: 3), Position(row: 3, column: 3)
            ],
            text: "Vezir tüm yönlere sınırsız kare gidebilir."
        )
    }

    func step5View() -> some View {
        tutorialStep(
            piece: .king, start: Position(row: 0, column: 4),
            valid: [
                Position(row: 1, column: 4), Position(row: 1, column: 3),
                Position(row: 1, column: 5), Position(row: 0, column: 3),
                Position(row: 0, column: 5)
            ],
            text: "Şah her yöne bir kare gider. Güvende tutulmalıdır."
        )
    }

    func tutorialStep(
        piece: PieceType, start: Position,
        valid: [Position], text: String
    ) -> some View {
        VStack(spacing: 12) {
            TutorialBoardInteractiveView(
                pieceType: piece,
                start: start,
                validDestinations: valid,
                explanation: text
            ) {
                // hamle tamamlandığında
                step += 1
                instructionText = getStepTitle(step)
            }
        }
    }

    func getStepTitle(_ step: Int) -> String {
        switch step {
        case 1: return "At nasıl hareket eder?"
        case 2: return "Fil nasıl hareket eder?"
        case 3: return "Kale nasıl hareket eder?"
        case 4: return "Vezir nasıl hareket eder?"
        case 5: return "Şah nasıl hareket eder?"
        case 6: return "Taşları tamamladık!"
        default: return "Satranç taşlarını tanıyalım!"
        }
    }
}
