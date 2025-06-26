//8x8 satranç tahtasını grid şeklinde çizer.
//Her hücreyi renklendirir ve içindeki taşı gösterir.
//ZStack kullanarak kare ve taşları üst üste koyar.
//Unicode taş sembolleri ile görsel temsil sağlar.
import SwiftUI

struct ChessBoardView: View {
    @ObservedObject var viewModel: ChessBoardViewModel

    var body: some View {
        VStack(spacing: 0) {
            Text("Sıra: \(viewModel.currentTurn == .white ? "Beyaz" : "Siyah")")
                .font(.headline)
                .padding()

            ForEach((0..<8).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { column in
                        let pos = Position(row: row, column: column)
                        ChessSquareView(pos: pos)
                    }
                }
            }
        }
        .alert("Şah Mat!", isPresented: Binding<Bool>(
            get: { viewModel.isCheckmate },
            set: { _ in }
        )) {
            Button("Yeni Oyun", role: .destructive) {
                viewModel.resetGame()
            }
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("\(viewModel.currentTurn == .white ? "Siyah" : "Beyaz") kazandı!")
        }
    }

    // ♟️ Tek bir kareyi ve içeriğini çizmek için view fonksiyonu
    @ViewBuilder
    func ChessSquareView(pos: Position) -> some View {
        ZStack {
            Rectangle()
                .fill((pos.row + pos.column).isMultiple(of: 2) ? Color.gray.opacity(0.3) : Color.green.opacity(0.5))

            if viewModel.validMoves.contains(pos) {
                Circle()
                    .fill(Color.blue.opacity(0.4))
                    .frame(width: 12, height: 12)
            }

            if let piece = viewModel.board[pos] {
                Text(pieceSymbol(for: piece))
                    .font(.system(size: 32))
            }

            if viewModel.selectedPosition == pos {
                Rectangle()
                    .stroke(Color.blue, lineWidth: 3)
            }
        }
        .frame(width: 44, height: 44)
        .onTapGesture {
            viewModel.handleTap(on: pos)
        }
    }

    func pieceSymbol(for piece: ChessPiece) -> String {
        switch (piece.type, piece.color) {
        case (.king, .white): return "♔"
        case (.queen, .white): return "♕"
        case (.rook, .white): return "♖"
        case (.bishop, .white): return "♗"
        case (.knight, .white): return "♘"
        case (.pawn, .white): return "♙"
        case (.king, .black): return "♚"
        case (.queen, .black): return "♛"
        case (.rook, .black): return "♜"
        case (.bishop, .black): return "♝"
        case (.knight, .black): return "♞"
        case (.pawn, .black): return "♟︎"
        }
    }
}
