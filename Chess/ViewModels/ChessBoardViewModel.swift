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

    let mode: GameMode
    let difficulty: BotDifficulty?

    var isVsBot: Bool {
        switch mode {
        case .singlePlayer: return true
        case .twoPlayers: return false
        }
    }

    init(mode: GameMode) {
        self.mode = mode
        if case let .singlePlayer(diff) = mode {
            self.difficulty = diff
        } else {
            self.difficulty = nil
        }
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

        currentTurn = .white
        selectedPosition = nil
        validMoves = []
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

        if isVsBot && currentTurn == .black && !isCheckmate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.makeBotMove()
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
            let vm = ChessBoardViewModel(mode: self.mode)
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

    func pieceValue(_ type: PieceType) -> Int {
        switch type {
        case .pawn: return 1
        case .knight, .bishop: return 3
        case .rook: return 5
        case .queen: return 9
        case .king: return 100
        }
    }

    func makeBotMove() {
        let depth: Int
        switch difficulty {
        case .medium:    depth = 1
        case .hard:      depth = 2
        case .legendary: depth = 3
        case .easy, .none: depth = 0
        }

        if depth == 0 {
            let botMoves = board.filter { $0.value.color == .black }
                .flatMap { from, _ in
                    availableMoves(for: from).map { to in (from, to) }
                }

            guard let (from, to) = botMoves.randomElement() else { return }
            movePiece(from: from, to: to)
        } else {
            let result = minimax(board: board, depth: depth, alpha: Int.min, beta: Int.max, maximizing: true)
            if let (from, to) = result.move {
                movePiece(from: from, to: to)
            }
        }
    }

    func resetGame() {
        setupInitialBoard()
        selectedPosition = nil
        validMoves = []
    }
    func availableMovesStatic(for from: Position, board: [Position: ChessPiece]) -> [Position] {
        guard let piece = board[from] else { return [] }

        var moves: [Position] = []

        for row in 0..<8 {
            for col in 0..<8 {
                let to = Position(row: row, column: col)
                if from != to {
                    let vm = ChessBoardViewModel(mode: self.mode)
                    vm.board = board
                    if vm.isValidMove(from: from, to: to) {
                        moves.append(to)
                    }
                }
            }
        }

        return moves
    }
    func evaluateBoard(_ board: [Position: ChessPiece]) -> Int {
        var total = 0
        for (_, piece) in board {
            let value = pieceValue(piece.type)
            total += piece.color == .black ? value : -value
        }
        return total
    }
    func minimax(board: [Position: ChessPiece], depth: Int, alpha: Int, beta: Int, maximizing: Bool) -> (score: Int, move: (from: Position, to: Position)?) {
        var alpha = alpha
        var beta = beta

        if depth == 0 {
            return (evaluateBoard(board), nil)
        }

        let currentColor: PieceColor = maximizing ? .black : .white
        let pieces = board.filter { $0.value.color == currentColor }

        var bestMove: (from: Position, to: Position)? = nil

        if maximizing {
            var maxEval = Int.min
            for (from, _) in pieces {
                let moves = (0..<8).flatMap { row in
                    (0..<8).compactMap { col in
                        let to = Position(row: row, column: col)
                        if from != to,
                           ChessBoardEvaluator.isValidMove(from: from, to: to, board: board, color: currentColor) {
                            return to
                        } else {
                            return nil
                        }
                    }
                }

                for to in moves {
                    var newBoard = board
                    newBoard[to] = newBoard[from]
                    newBoard[from] = nil

                    let result = minimax(board: newBoard, depth: depth - 1, alpha: alpha, beta: beta, maximizing: false)
                    if result.score > maxEval {
                        maxEval = result.score
                        bestMove = (from, to)
                    }
                    alpha = max(alpha, result.score)
                    if beta <= alpha {
                        break // ❗ Daha fazla hesaplamaya gerek yok
                    }
                }
            }
            return (maxEval, bestMove)
        } else {
            var minEval = Int.max
            for (from, _) in pieces {
                let vm = ChessBoardViewModel(mode: self.mode)
                vm.board = board
                vm.currentTurn = currentColor

                let moves = vm.availableMoves(for: from)
                for to in moves {
                    var newBoard = board
                    newBoard[to] = newBoard[from]
                    newBoard[from] = nil

                    let result = minimax(board: newBoard, depth: depth - 1, alpha: alpha, beta: beta, maximizing: true)
                    if result.score < minEval {
                        minEval = result.score
                        bestMove = (from, to)
                    }
                    beta = min(beta, result.score)
                    if beta <= alpha {
                        break
                    }
                }
            }
            return (minEval, bestMove)
        }
    }

}



