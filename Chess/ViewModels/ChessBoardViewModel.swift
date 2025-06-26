//Tüm satranç tahtasının veri yapısını (board) yönetir.
//Başlangıçta taşları doğru konumlara yerleştirir.
//Gelecekte taş hareketi, oyun mantığı, hamle kontrolü gibi işlevler buraya eklenecek.

import Foundation

class ChessBoardViewModel: ObservableObject {
    @Published var board: [Position: ChessPiece] = [:]
    @Published var selectedPosition: Position? = nil
    @Published var currentTurn: PieceColor = .white
    @Published var validMoves: [Position] = []
    @Published var isCheckmate: Bool = false
    
    init() {
        setupInitialBoard()
    }
    
    func setupInitialBoard() {
        board = [:]
        isCheckmate = false
        
        for col in 0..<8 {
            board[Position(row: 1, column: col)] = ChessPiece(type: .pawn, color: .white)
            board[Position(row: 6, column: col)] = ChessPiece(type: .pawn, color: .black)
        }
        
        let backRank: [PieceType] = [.rook, .knight, .bishop, .queen, .king, .bishop, .knight, .rook]
        for col in 0..<8 {
            board[Position(row: 0, column: col)] = ChessPiece(type: backRank[col], color: .white)
            board[Position(row: 7, column: col)] = ChessPiece(type: backRank[col], color: .black)
        }
    }
    
    func handleTap(on position: Position) {
        guard !isCheckmate else { return }
        
        if let selected = selectedPosition {
            if board[selected]?.color == board[position]?.color {
                selectedPosition = position
                validMoves = availableMoves(for: position)
            } else {
                if board[selected]?.color == currentTurn {
                    movePiece(from: selected, to: position)
                    selectedPosition = nil
                    validMoves = []
                }
            }
        } else {
            if let piece = board[position], piece.color == currentTurn {
                selectedPosition = position
                validMoves = availableMoves(for: position)
            }
        }
    }
    
    func movePiece(from: Position, to: Position) {
        guard let piece = board[from], isValidMove(from: from, to: to) else { return }
        board[to] = piece
        board[from] = nil
        toggleTurn()
        checkForCheckmate()
    }
    
    func toggleTurn() {
        currentTurn = currentTurn == .white ? .black : .white
    }
    
    func checkForCheckmate() {
        for (from, piece) in board where piece.color == currentTurn {
            for row in 0..<8 {
                for col in 0..<8 {
                    let to = Position(row: row, column: col)
                    if isValidMove(from: from, to: to) {
                        isCheckmate = false
                        return
                    }
                }
            }
        }
        isCheckmate = true
    }
    
    func availableMoves(for from: Position) -> [Position] {
        guard let piece = board[from] else { return [] }
        
        var moves: [Position] = []
        
        for row in 0..<8 {
            for col in 0..<8 {
                let to = Position(row: row, column: col)
                if from != to, isValidMove(from: from, to: to) {
                    moves.append(to)
                }
            }
        }
        
        return moves
    }
    
    func isValidMove(from: Position, to: Position) -> Bool {
        guard let piece = board[from] else { return false }
        
        if let target = board[to], target.color == piece.color {
            return false
        }
        
        let rowDiff = to.row - from.row
        let colDiff = to.column - from.column
        let absRow = abs(rowDiff)
        let absCol = abs(colDiff)
        
        let pieceCanMove: Bool = {
            switch piece.type {
            case .pawn:
                let direction = piece.color == .white ? 1 : -1
                let startRow = piece.color == .white ? 1 : 6
                
                if colDiff == 0 {
                    if rowDiff == direction && board[to] == nil {
                        return true
                    }
                    if rowDiff == 2 * direction && from.row == startRow {
                        let mid = Position(row: from.row + direction, column: from.column)
                        return board[to] == nil && board[mid] == nil
                    }
                }
                
                if absCol == 1 && rowDiff == direction {
                    if let target = board[to], target.color != piece.color {
                        return true
                    }
                }
                return false
                
            case .knight:
                return (absRow == 2 && absCol == 1) || (absRow == 1 && absCol == 2)
                
            case .bishop:
                return absRow == absCol && isPathClear(from: from, to: to)
                
            case .rook:
                return (from.row == to.row || from.column == to.column) && isPathClear(from: from, to: to)
                
            case .queen:
                return (from.row == to.row || from.column == to.column || absRow == absCol) && isPathClear(from: from, to: to)
                
            case .king:
                return absRow <= 1 && absCol <= 1
            }
        }()
        
        if !pieceCanMove {
            return false
        }
        
        var simulatedBoard = board
        simulatedBoard[to] = simulatedBoard[from]
        simulatedBoard[from] = nil
        
        return !isKingInCheck(color: piece.color, board: simulatedBoard)
    }
    
    func isKingInCheck(color: PieceColor, board: [Position: ChessPiece]) -> Bool {
        guard let kingPos = board.first(where: { $0.value.type == .king && $0.value.color == color })?.key else {
            return true
        }
        
        for (pos, piece) in board where piece.color != color {
            let vm = ChessBoardViewModel()
            vm.board = board
            if vm.isValidMove(from: pos, to: kingPos) {
                return true
            }
        }
        return false
    }
    
    func isPathClear(from: Position, to: Position) -> Bool {
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
    func resetGame() {
        setupInitialBoard()
        selectedPosition = nil
        validMoves = []
    }
}
