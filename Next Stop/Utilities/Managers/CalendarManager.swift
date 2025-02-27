import Foundation

@Observable
class CalendarManager {
    var selectedDate: Date? = nil
    var startDate: Date? = nil
    var endDate: Date? = nil
    var calendar = Calendar.current
    var minimumDate = Date()
    var maximumDate = Date()
    var disabledDates: [Date] = []
    var disabledAfterDate : Date?
    var colors = CalendarColorSettins()
    var font = CalendarFontSettings()
    
    init(selectedDate: Date? = nil, startDate: Date? = nil, endDate: Date? = nil, calendar: Foundation.Calendar = Calendar.current, minimumDate: Date = Date(), maximumDate: Date = Date(), disabledAfterDate: Date? = nil, colors: CalendarColorSettins = CalendarColorSettins(), font: CalendarFontSettings = CalendarFontSettings()) {
        self.selectedDate = selectedDate
        self.startDate = startDate
        self.endDate = endDate
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.disabledAfterDate = disabledAfterDate
        self.colors = colors
        self.font = font
    }
    
    func disabledDatesContains(date: Date) -> Bool {
        if let disabledAfterDate = disabledAfterDate , date > disabledAfterDate {
            return true
        }else{
            return disabledDates.contains{
                calendar.isDate($0, inSameDayAs: date)
            }
        }
    }
    
    func monthHeader(monthOffset: Int) -> String {
        if let date = firstOfMonthForTheOffset(offset: monthOffset){
            return CalendarHelpers.getMonthHeader(date: date)
        }else{
            return ""
        }
    }
    
    func firstOfMonthForTheOffset(offset: Int) -> Date? {
        var offsetCompoment = DateComponents()
        offsetCompoment.month = offset
        return calendar.date(byAdding: offsetCompoment, to: firstDateOfTheMonth())
    }
    
    func firstDateOfTheMonth() -> Date {
        var compoments = calendar.dateComponents([.year,.month,.day], from: minimumDate)
        compoments.day = 1
        return calendar.date(from: compoments) ?? Date()
    }
    
}
