import Foundation
import SwiftUI

struct CalendarDate {
    var date: Date
    var isDisabled = false
    var isToday = false
    var isSelected = false
    var isBetweenStartAndEnd = false
    var endDate: Date?
    var startDate : Date?
    
    init(date: Date, isDisabled: Bool = false, isToday: Bool = false, isSelected: Bool = false, isBetweenStartAndEnd: Bool = false, endDate: Date?, startDate: Date?) {
        self.date = date
        self.isDisabled = isDisabled
        self.isToday = isToday
        self.isSelected = isSelected
        self.isBetweenStartAndEnd = isBetweenStartAndEnd
        self.endDate = endDate
        self.startDate = startDate
    }
    
    var isEndDate: Bool {
        date == endDate
    }
    
    var isStartDate: Bool {
        date == startDate
    }
    
    func getText() -> String {
        let day = CalendarHelpers.formatDate(date: date)
        return day
    }
    
//    func getTextColor() -> Color {
//        
//    }
}
