enum GameMode: Identifiable {
    case singlePlayer(difficulty: BotDifficulty)
    case twoPlayers

    var id: String {
        switch self {
        case .singlePlayer(let difficulty):
            return "single-\(difficulty.rawValue)"
        case .twoPlayers:
            return "two"
        }
    }
}
