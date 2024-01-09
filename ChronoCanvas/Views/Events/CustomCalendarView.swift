//  CustomCalendarView.swift

import SwiftUI

struct CustomCalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    private let daysInWeek = 7
    private let topPadding: CGFloat = 50
    private let bottomPadding: CGFloat = 55
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        viewModel.changeMonth(by: -1)
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Text("\(viewModel.yearMonth, formatter: Formatter.monthFormatter)")
                        .font(.title)
                        .padding(.top)
                    Spacer()
                    Button(action: {
                        viewModel.changeMonth(by: 1)
                    }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.horizontal)

                Divider()
                
                HStack {
                    ForEach(Constants.daysOfWeek, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                    }
                }
                
                Divider()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: daysInWeek), spacing: 0) {
                    ForEach(viewModel.generateDaysInMonth(), id: \.self) { day in
                        if let day = day {
                            let colorCodes = viewModel.colorCodesForDay(day)
                            let isCurrentMonth = Calendar.current.isDate(day, equalTo: viewModel.selectedDate, toGranularity: .month)
                            let eventsCount = viewModel.eventsCountOnDay(day)
                            DayView(
                                day: day,
                                isSelected: viewModel.isSameDay(day, viewModel.selectedDate),
                                eventsCount: eventsCount,
                                isCurrentMonth: isCurrentMonth,
                                colorCodes: colorCodes
                            )
                                .frame(maxWidth: .infinity, minHeight: gridHeight(geometry: geometry))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.selectedDate = day
                                }
                                .border(Color.gray, width: 0.5)
                        } else {
                            EmptyView()
                                .frame(maxWidth: .infinity, minHeight: gridHeight(geometry: geometry))
                                .border(Color.gray, width: 0.5)
                        }
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 5)
        }
    }
    
    private func gridHeight(geometry: GeometryProxy) -> CGFloat {
        let totalHeight = geometry.size.height - topPadding - bottomPadding
        return totalHeight / CGFloat(numberOfWeeksInMonth(date: viewModel.selectedDate))
    }
    
    private func numberOfWeeksInMonth(date: Date) -> Int {
        let calendar = Calendar.current
        let weekRange = calendar.range(of: .weekOfMonth, in: .month, for: date)
        return weekRange?.count ?? 4
    }
}
