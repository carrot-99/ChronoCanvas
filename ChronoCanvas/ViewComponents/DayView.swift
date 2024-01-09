//  DayView.swift

import SwiftUI

struct DayView: View {
    let day: Date
    var isSelected: Bool
    var eventsCount: Int
    var isCurrentMonth: Bool
    var colorCodes: [Color]
    
    private var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: day)
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return Color.gray.opacity(0.5)
        } else if dayOfWeek == "Sat" {
            return Color.blue
        } else if dayOfWeek == "Sun" {
            return Color.red
        } else {
            return Color.black
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(Formatter.dayFormatter.string(from: day))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding([.top, .leading], 8)
                .background(isSelected ? Color.blue.opacity(0.3) : Color.clear)
                .foregroundColor(textColor)
            
            if eventsCount > 0 {
                Text("\(eventsCount)")
                    .font(.caption)
                    .padding(5)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .offset(x: 30, y: 5)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                ForEach(colorCodes.indices, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(colorCodes[index])
                        .frame(width: 28, height: 6)
                }
            }
            .padding(.top, 30)
            .padding(.leading, 5)
        }
    }
}
