import Foundation

enum PieceTheme: String, CaseIterable, Identifiable {
    case classic
    case emoji
    case fantasy

    var id: String { self.rawValue }

    func symbol(for piece: ChessPiece) -> String {
        switch self {
        case .classic:
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

        case .emoji:
            switch (piece.type, piece.color) {
            case (.king, .white): return "👑"
            case (.queen, .white): return "👸"
            case (.rook, .white): return "🏰"
            case (.bishop, .white): return "🧙"
            case (.knight, .white): return "🐴"
            case (.pawn, .white): return "🧍‍♂️"
            case (.king, .black): return "🕴️"
            case (.queen, .black): return "🧛"
            case (.rook, .black): return "🏯"
            case (.bishop, .black): return "🧝"
            case (.knight, .black): return "🐎"
            case (.pawn, .black): return "👤"
            }

        case .fantasy:
            switch (piece.type, piece.color) {
            case (.king, .white): return "🦁"
            case (.queen, .white): return "🦄"
            case (.rook, .white): return "🐉"
            case (.bishop, .white): return "🧚"
            case (.knight, .white): return "🐎"
            case (.pawn, .white): return "🧙"
            case (.king, .black): return "🐺"
            case (.queen, .black): return "🧛"
            case (.rook, .black): return "🦂"
            case (.bishop, .black): return "🧞"
            case (.knight, .black): return "🐍"
            case (.pawn, .black): return "👺"
            }
        }
    }
}
