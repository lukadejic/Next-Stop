
import SwiftUI

struct WeekDayHeaderView: View {
    var manager: CalendarManager
    
    var body: some View {
        VStack(spacing: 8) {
            CalendarWeekdayHeaderView(manager: manager)
                .padding(.horizontal)
                .padding(.top)
            
            Divider()
        }
    }
}

#Preview {
    WeekDayHeaderView(manager: CalendarManager())
}
