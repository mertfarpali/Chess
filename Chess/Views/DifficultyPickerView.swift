import SwiftUI

struct DifficultyPickerView: View {
    let onSelect: (BotDifficulty) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("Zorluk Seviyesi Seç")
                .font(.title2)
                .bold()
                .padding(.top)

            ForEach(BotDifficulty.allCases, id: \.self) { level in
                Button(level.rawValue) {
                    onSelect(level)
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
            }

            Button("İptal", role: .cancel) {
                dismiss()
            }
            .padding(.top)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding()
    }
}
