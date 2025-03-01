import Foundation
import SwiftUI

struct CalendarDate {
    var date: Date
    var manager : CalendarManager
    var isDisabled = false
    var isToday = false
    var isSelected = false
    var isBetweenStartAndEnd = false
    var endDate: Date?
    var startDate : Date?
    
    init(date: Date, manager: CalendarManager, isDisabled: Bool = false, isToday: Bool = false, isSelected: Bool = false, isBetweenStartAndEnd: Bool = false, endDate: Date? = nil, startDate: Date? = nil) {
        self.date = date
        self.manager = manager
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
    
    func getTextColor() -> Color {
        var textColor = manager.colors.textColor
        
        if isDisabled {
            textColor = manager.colors.disabledColor
        }else if isSelected {
            textColor = manager.colors.selectedColor
        }else if isToday {
            textColor = manager.colors.todayColor
        }else if isBetweenStartAndEnd {
            textColor = manager.colors.betweenStartAndEndColor
        }
        
        return textColor
    }
    
    func getTextFont() -> Font {
        var fontWeight = manager.font.cellUnselectedFont
        
        if isDisabled {
            fontWeight = manager.font.cellDisabledFont
        }else if isSelected {
            fontWeight = manager.font.cellSelectedFont
        }else if isToday {
            fontWeight = manager.font.cellTodayFont
        }else if isBetweenStartAndEnd {
            fontWeight = manager.font.cellBetweenStartAndEndFont
        }
        return fontWeight
    }
    
    func getBackgroundColor() -> Color {
        var backGroundColor = manager.colors.textBackColor
        
        if isBetweenStartAndEnd {
            backGroundColor = manager.colors.betweenStartAndEndBackColor
        }else if isDisabled {
            backGroundColor = manager.colors.disabledBackColor
        }else if isSelected {
            backGroundColor = manager.colors.selectedBackColor
        }
        
        return backGroundColor
    }
}
