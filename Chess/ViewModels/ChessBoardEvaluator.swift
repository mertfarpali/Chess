import Foundation

struct ChessBoardEvaluator {
    static func isValidMove(from: Position, to: Position, board: [Position: ChessPiece], color: PieceColor) -> Bool {
        guard let piece = board[from] else { return false }
        if let target = board[to], target.color == piece.color { return false }

        let rowDiff = to.row - from.row
        let colDiff = to.column - from.column
        let absRow = abs(rowDiff)
        let absCol = abs(colDiff)

        func isPathClear() -> Bool {
            let rowStep = (to.row - from.row).signum()
            let colStep = (to.column - from.column).signum()
            var checkRow = from.row + rowStep
            var checkCol = from.column + colStep

            while checkRow != to.row || checkCol != to.column {
                if board[Position(row: checkRow, column: checkCol)] != nil {
                    return false
                }
                checkRow += rowStep
                checkCol += colStep
            }
            return true
        }

        let pieceCanMove: Bool = {
            switch piece.type {
            case .pawn:
                let direction = piece.color == .white ? 1 : -1
                let startRow = piece.color == .white ? 1 : 6
                if colDiff == 0 {
                    if rowDiff == direction && board[to] == nil { return true }
                    if rowDiff == 2 * direction && from.row == startRow {
                        let mid = Position(row: from.row + direction, column: from.column)
                        return board[to] == nil && board[mid] == nil
                    }
                }
                if absCol == 1 && rowDiff == direction {
                    if let target = board[to], target.color != piece.color { return true }
                }
                return false

            case .knight:
                return (absRow == 2 && absCol == 1) || (absRow == 1 && absCol == 2)

            case .bishop:
                return absRow == absCol && isPathClear()

            case .rook:
                return (from.row == to.row || from.column == to.column) && isPathClear()

            case .queen:
                return (from.row == to.row || from.column == to.column || absRow == absCol) && isPathClear()

            case .king:
                return absRow <= 1 && absCol <= 1
            }
        }()

        return pieceCanMove
    }
}
