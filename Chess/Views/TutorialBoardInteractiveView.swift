import SwiftUI

struct TutorialBoardInteractiveView: View {
    let pieceType: PieceType
    let start: Position
    let validDestinations: [Position]
    let explanation: String
    let onSuccess: () -> Void

    @State private var currentPos: Position?
    @State private var feedback: String?

    var body: some View {
        VStack(spacing: 12) {
            Text(explanation)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)

            Text(feedback ?? "Doğru hamleyi yap!")
                .font(.headline)
                .foregroundColor(feedback == "Doğru!" ? .green : .primary)

            board
        }
        .onAppear {
            currentPos = start
        }
    }

    var board: some View {
        VStack(spacing: 0) {
            ForEach((0..<8).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { column in
                        let pos = Position(row: row, column: column)
                        ZStack {
                            Rectangle()
                                .fill((pos.row + pos.column).isMultiple(of: 2) ? Color.gray.opacity(0.3) : Color.green.opacity(0.4))

                            if validDestinations.contains(pos) {
                                Circle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 12, height: 12)
                            }

                            if currentPos == pos {
                                Text(pieceSymbol(for: pieceType))
                                    .font(.system(size: 32))
                            }

                            if start == pos {
                                Rectangle()
                                    .stroke(Color.blue, lineWidth: 2)
                            }
                        }
                        .frame(width: 44, height: 44)
                        .onTapGesture {
                            handleTap(on: pos)
                        }
                    }
                }
            }
        }
    }

    func handleTap(on pos: Position) {
        guard let from = currentPos else { return }

        if from == start && validDestinations.contains(pos) {
            currentPos = pos
            feedback = "Doğru!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                feedback = nil
                onSuccess()
            }
        } else {
            feedback = "Yanlış hamle"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                feedback = nil
            }
        }
    }

    func pieceSymbol(for type: PieceType) -> String {
        switch type {
        case .king: return "♔"
        case .queen: return "♕"
        case .rook: return "♖"
        case .bishop: return "♗"
        case .knight: return "♘"
        case .pawn: return "♙"
        }
    }
}
