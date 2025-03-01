import SwiftUI

struct RangeCalendarView: View {
    var manager: CalendarManager
    
    var numberOfMonths : Int {
        CalendarHelpers.getNumberOfMonths(minDate: manager.minimumDate,
                                          maxDate: manager.maximumDate)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            CalendarWeekdayHeaderView(manager: manager)
                .padding(.horizontal)
            
            ScrollViewReader { reader in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 32) {
                        ForEach(0..<numberOfMonths, id: \.self) { index in
                            MonthView(manager: manager,
                                      monthOffset: index)

                        }
                    }
                    .padding()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let date = manager.startDate {
                            reader.scrollTo(CalendarHelpers.getMonthHeader(date: date),anchor: .center)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RangeCalendarView(manager: CalendarManager(minimumDate: Date().addingTimeInterval(-60 * 24 * 30), maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 10)))
}
