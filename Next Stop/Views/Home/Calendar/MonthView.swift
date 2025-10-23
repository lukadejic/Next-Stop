import SwiftUI

struct MonthView: View {
    @State private var isStartDate = false
    
    var manager : CalendarManager
    let monthOffset: Int
    
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    
    var monthsArray : [[Date]] {
        monthArray()
    }
    
    @State private var showTime = false
    
    var body: some View {
        Group{
            let header = getMonthHeader()
            
            VStack(alignment:.leading, spacing: 10) {
                Text(header)
                    .font(manager.font.monthHeaderFont)
                    .foregroundStyle(manager.colors.monthHeaderColor)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 5){
                    ForEach(monthsArray, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(row, id: \.self){ date in
                                cellView(date)
                            }
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    MonthView(manager: CalendarManager(), monthOffset: 0)
}

private extension MonthView {
    func isThisMonth(date: Date) -> Bool {
        return self.manager.calendar.isDate(date,
                                            equalTo: firstOfMonthOffset(),
                                            toGranularity: .month)
    }
    
    func firstDateMonth() -> Date {
        var components = manager.calendar.dateComponents(calendarUnitYMD,
                                                         from: manager.minimumDate)
        components.day = 1
        return manager.calendar.date(from: components) ?? Date()
    }
    
    func firstOfMonthOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        return manager.calendar.date(byAdding: offset, to: firstDateMonth())!
    }
    
    func formatDate(date: Date) -> Date {
        let compoments = manager.calendar.dateComponents(calendarUnitYMD,
                                                         from: date)
        return manager.calendar.date(from: compoments)!
    }
    
    func formatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = formatDate(date: referenceDate)
        let clampedDate = formatDate(date: date)
        return refDate == clampedDate
    }
    
    func calculateNumberOfDays(offset: Int) -> Int {
        let firstOfMonth = firstOfMonthOffset()
        let rangeOfWeeks = manager.calendar.range(of: .weekOfMonth,
                                                  in: .month,
                                                  for: firstOfMonth)
        guard let count = rangeOfWeeks?.count else {
            fatalError("Cant get range of weeks")
        }
        return count * daysPerWeek
    }
    
    func isStartDate(date: Date) -> Bool {
        if manager.startDate == nil {
            return false
        }else{
            return formatAndCompareDate(date: date,
                                        referenceDate: manager.startDate ?? Date())
        }
    }
    
    func isEndDate(date: Date) -> Bool {
        if manager.endDate == nil {
            return false
        }else {
            return formatAndCompareDate(date: date,
                                        referenceDate: manager.endDate ?? Date())
        }
    }
    
    func isBetweenStartAndEnd(date: Date) -> Bool {
        if manager.startDate == nil {
            return false
        }else if manager.endDate == nil {
            return false
        }else if manager.calendar.compare(date,
                                          to: manager.startDate ?? Date(),
                                          toGranularity: .day) == .orderedAscending{
            return false
        }else if manager.calendar.compare(date,
                                          to: manager.endDate ?? Date(),
                                          toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    func isEnabled(date: Date) -> Bool {
        let clampedDate = formatDate(date: date)
        if manager.calendar.compare(clampedDate,
                                    to: manager.minimumDate,
                                    toGranularity: .day) == .orderedAscending ||
            manager.calendar.compare(date,
                                     to: manager.maximumDate,
                                     toGranularity: .day) == .orderedDescending {
            return false
        }
        
        return !isOnOfDisabledDates(date: date)
    }
    
    func isOnOfDisabledDates(date: Date) -> Bool {
        self.manager.disabledDatesContains(date: date)
    }
    
    func isStartDateAfterEndDate() -> Bool {
        if manager.startDate == nil {
            return false
        }else if manager.endDate == nil {
            return false
        }else if manager.calendar.compare(manager.endDate ?? Date(),
                                          to: manager.startDate ?? Date(),
                                          toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    func isToday(date: Date) -> Bool {
        return formatAndCompareDate(date: date, referenceDate: Date())
    }
    
    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) ||
        isStartDate(date: date) ||
        isEndDate(date: date)
    }
    
    func isSelectedDate(date: Date) -> Bool {
        if manager.selectedDate == nil {
            return false
        }
        return formatAndCompareDate(date: date,
                                    referenceDate: manager.selectedDate ?? Date())
    }
    
    func dateTapped(date: Date) {
        if self.isEnabled(date: date) {
            if isStartDate {
                self.manager.startDate = date
                self.manager.endDate = nil
                isStartDate = false
            }else{
                self.manager.endDate = date
                if self.isStartDateAfterEndDate() {
                    self.manager.endDate = nil
                    self.manager.startDate = nil
                }
                isStartDate = true
            }
        }
    }
    
    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthOffset()
        let weekday = manager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - manager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset
        
        return manager.calendar.date(byAdding: dateComponents, to: firstOfMonth) ?? Date()
    }
    
    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        
        for row in 0..<(calculateNumberOfDays(offset: monthOffset) / 7) {
            var columnArray = [Date]()
            for column in 0...6 {
                let abc = self.getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
                
        return rowArray
    }
    
    func getMonthHeader() -> String {
        CalendarHelpers.getMonthHeader(date: firstOfMonthOffset())
    }
    
    func cellView(_ date: Date) -> some View {
        HStack(spacing: 0) {
            if self.isThisMonth(date: date) {
                DayCellView(calendarDate:
                                CalendarDate(date: date,
                                             manager: manager,
                                             isDisabled: !isEnabled(date: date),
                                             isToday: isToday(date: date),
                                             isSelected: isSpecialDate(date: date),
                                             isBetweenStartAndEnd: isBetweenStartAndEnd(date: date),
                                             endDate: manager.endDate, startDate:
                                                manager.startDate),
                            cellWidth:
                                CalendarCellWidth)
                    .onTapGesture {
                        self.dateTapped(date: date)
                    }
            }else{
                Text("")
                    .frame(maxWidth: .infinity,alignment: .center)
            }
        }
    }
}
