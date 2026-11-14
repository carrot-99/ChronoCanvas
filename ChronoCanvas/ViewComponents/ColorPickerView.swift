// ColorPickerView.swift

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColorCode: String

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(PresetColors.hexes, id: \.self) { hex in
                let isSelected = hex.caseInsensitiveCompare(selectedColorCode) == .orderedSame
                Button {
                    selectedColorCode = hex
                } label: {
                    Circle()
                        .fill(Color(hex: hex))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(isSelected ? 1 : 0)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.primary.opacity(isSelected ? 0.6 : 0), lineWidth: 2)
                                .padding(-4)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("色 \(hex)"))
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(.vertical, 8)
    }
}
