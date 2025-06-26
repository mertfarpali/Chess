//8x8 satranç tahtasını grid şeklinde çizer.
//Her hücreyi renklendirir ve içindeki taşı gösterir.
//ZStack kullanarak kare ve taşları üst üste koyar.
//Unicode taş sembolleri ile görsel temsil sağlar.
import SwiftUI

struct ChessBoardView: View {
    @ObservedObject var viewModel: ChessBoardViewModel
    let onExitToMenu: () -> Void  // Ana menüye dönüş fonksiyonu

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Sıra: \(viewModel.currentTurn == .white ? "Beyaz" : "Siyah")")
                    .font(.headline)
                    .padding(.leading)

                Spacer()

                Button(action: {
                    onExitToMenu()
                }) {
                    Text("Ana Menü")
                        .font(.subheadline)
                        .padding(8)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
            .padding(.vertical)

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
            Button("Ana Menüye Dön", role: .cancel) {
                onExitToMenu()
            }
        } message: {
            Text("\(viewModel.currentTurn == .white ? "Siyah" : "Beyaz") kazandı!")
        }
    }

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
                Text(viewModel.selectedTheme.symbol(for: piece))
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
}
