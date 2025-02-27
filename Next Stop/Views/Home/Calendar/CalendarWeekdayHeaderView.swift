import SwiftUI

struct CalendarWeekdayHeaderView: View {
    
    var manager : CalendarManager
    var weekdays : [String] {
        CalendarHelpers.getWeekDayHeaders(calendar: manager.calendar)
    }
    
    var body: some View {
        HStack{ 
            ForEach(weekdays, id: \.self) { weekDay in
                Text(weekDay)
                    .font(manager.font.weekdayHeaderFont)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
        }
        .foregroundStyle(manager.colors.weekdayHeaderColor)
        .background(manager.colors.weekdayHeaderBackColor)
    }
}

#Preview {
    CalendarWeekdayHeaderView(manager: CalendarManager())
}
