extension ChessPiece {
    var classicSymbol: String {
        switch (type, color) {
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

    var emojiSymbol: String {
        switch (type, color) {
        case (.king, .white): return "🤴"
        case (.queen, .white): return "👸"
        case (.rook, .white): return "🏰"
        case (.bishop, .white): return "🕊"
        case (.knight, .white): return "🐴"
        case (.pawn, .white): return "⚪️"
        case (.king, .black): return "🦹‍♂️"
        case (.queen, .black): return "🧙‍♀️"
        case (.rook, .black): return "🗼"
        case (.bishop, .black): return "🦉"
        case (.knight, .black): return "🐎"
        case (.pawn, .black): return "⚫️"
        }
    }

    var minimalSymbol: String {
        switch type {
        case .king: return "K"
        case .queen: return "Q"
        case .rook: return "R"
        case .bishop: return "B"
        case .knight: return "N"
        case .pawn: return "P"
        }
    }
}
