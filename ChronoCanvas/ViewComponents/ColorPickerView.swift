// ColorPickerView.swift

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColorCode: String

    var body: some View {
        HStack {
            ForEach(PresetColors.colors, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 30, height: 30)
                    .overlay( // 選択された色を示すための枠を追加
                        Circle()
                            .stroke(ColorUtils.hexString(from: color) == selectedColorCode ? Color.gray : Color.clear, lineWidth: 3)
                    )
                    .onTapGesture {
                        self.selectedColorCode = ColorUtils.hexString(from: color)
                    }
            }
        }
    }
}
