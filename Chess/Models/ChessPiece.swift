//Satranç taşlarını temsil eder (şah, vezir, at vs.)
//Her taşın tipi (PieceType) ve rengi (PieceColor) vardır.
//ChessPiece modeli UI'da gösterilecek nesnedir.import Foundation

import Foundation

enum PieceType: String {
    case king, queen, rook, bishop, knight, pawn
}

enum PieceColor {
    case white, black
}

struct ChessPiece: Identifiable {
    let id = UUID()
    let type: PieceType
    let color: PieceColor
}
