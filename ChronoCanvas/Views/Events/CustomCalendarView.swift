//  CustomCalendarView.swift

import SwiftUI

struct CustomCalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        VStack(spacing: 0) {
            header
            weekdayHeader
            Divider()
            grid
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 16) {
            Text(DateFormats.month.string(from: viewModel.displayedMonth))
                .font(.title2.bold())
                .numericTransitionIfAvailable()

            Spacer()

            if !viewModel.isShowingToday {
                Button("今日") {
                    withAnimation(.easeInOut(duration: 0.2)) { viewModel.selectToday() }
                }
                .font(.subheadline.weight(.semibold))
                .buttonStyle(.bordered)
                .controlSize(.small)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.2)) { viewModel.changeMonth(by: -1) }
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 32, height: 32)
            }
            .accessibilityLabel("前の月")

            Button {
                withAnimation(.easeInOut(duration: 0.2)) { viewModel.changeMonth(by: 1) }
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 32, height: 32)
            }
            .accessibilityLabel("次の月")
        }
        .font(.headline)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(Array(viewModel.weekdaySymbols.enumerated()), id: \.offset) { column, symbol in
                let weekday = viewModel.calendar.weekday(atColumn: column)
                Text(symbol)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(weekday == 1 ? .red : weekday == 7 ? .blue : .secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Grid

    private var grid: some View {
        GeometryReader { geometry in
            let rowHeight = geometry.size.height / CGFloat(viewModel.numberOfWeeks)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0) {
                ForEach(Array(viewModel.days.enumerated()), id: \.element.id) { index, day in
                    DayView(
                        day: day,
                        isSelected: viewModel.isSelected(day.date),
                        isToday: viewModel.calendar.isDateInToday(day.date),
                        weekday: viewModel.calendar.weekday(atColumn: index % 7),
                        colors: viewModel.events(on: day.date).map(\.displayColor)
                    )
                    .frame(height: rowHeight)
                    .overlay(Rectangle().frame(height: 0.5).foregroundColor(Color(.separator)), alignment: .bottom)
                    .onTapGesture {
                        viewModel.selectedDate = day.date
                    }
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    guard abs(value.translation.width) > abs(value.translation.height) else { return }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.changeMonth(by: value.translation.width < 0 ? 1 : -1)
                    }
                }
        )
    }
}

private extension View {
    /// iOS 16 以降では数値トランジションを使う
    @ViewBuilder
    func numericTransitionIfAvailable() -> some View {
        if #available(iOS 16.0, *) {
            self.contentTransition(.numericText())
        } else {
            self
        }
    }
}
