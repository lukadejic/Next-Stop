import Foundation
import SwiftUI

class CalendarColorSettins {
    var textColor = Color.primary
    var todayColor = Color.red
    var selectedColor = Color.white
    var betweenStartAndEndColor = Color.white
    var disabledColor = Color.gray
    var todayBackColor = Color.gray
    var textBackColor = Color.clear
    var disabledBackColor = Color.clear
    var selectedBackColor = Color.black
    var betweenStartAndEndBackColor = Color.init(.systemGray3).opacity(0.8)
    var calendarBackColor = Color.init(.systemGray6)
    var weekdayHeaderColor = Color.secondary
    var monthHeaderColor = Color.primary
    var monthHeaderBackColor = Color.clear
    var monthBackColor = Color.clear
    var weekdayHeaderBackColor = Color.clear
}

class CalendarFontSettings {
    var monthHeaderFont : Font = .body.bold()
    var weekdayHeaderFont : Font = .caption
    var cellUnselectedFont : Font = .body
    var cellDisabledFont : Font = .body.weight(.light)
    var cellSelectedFont : Font = .body.bold()
    var cellTodayFont : Font = .body.bold()
    var cellBetweenStartAndEndFont : Font = .body.bold()
}

class CalendarHelpers {
    
    static func getWeekDayHeaders(calendar: Calendar) -> [String] {
        let weekdays = calendar.shortStandaloneWeekdaySymbols
        let firstWeekDayIndex = calendar.firstWeekday - 1
        let adjustedWeekDays = Array(weekdays[firstWeekDayIndex...] + weekdays[..<firstWeekDayIndex])
        return adjustedWeekDays
    }
    
    static func formatDate(date: Date) -> String {
        return date.formatted(.dateTime.day())
    }
    
    static func stringFromDate(date: Date) -> String {
        return date.formatted()
    }
    
    static func getMonthDayFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        
        guard let month = components.month else {
            fatalError("Can't get a month from a calendar")
        }
        
        return month - 1
    }
    
    static func getMonthHeader(date: Date) -> String {
        let dateStyle = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.wide)
        return date.formatted(dateStyle)
    }
    
    static func getNumberOfMonths(minDate: Date, maxDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.month], from: minDate, to: maxDate)
        
        guard let month = components.month else {
            fatalError("Can't get a month from a calendar")
        }
        
        return month + 1
    }
    
    static func getLastDayOfMonth(date: Date, calendar: Calendar = .current) -> Date {
        var components = calendar.dateComponents([.year, .month], from: date)
        components.setValue(1, for: .day)
        
        guard let startOfMonth = calendar.date(from: components) else {
            fatalError("Can't get a start of month from the calendar")
        }
        
        return calendar.date(byAdding: .month, value: 1, to: startOfMonth)?.addingTimeInterval(-86500) ?? startOfMonth
    }
    
    static func formattedRangeDate(startDate: Date?, endDate: Date?) -> String {
        guard let startDate = startDate, let endDate = endDate else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") 
        dateFormatter.dateFormat = "E, d MMM"
       
        let start = dateFormatter.string(from: startDate)
        let end = dateFormatter.string(from: endDate)
        
        return "\(start) - \(end)"
    }
    
    static func covnertDateToString(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: date)
    }
    
}

struct RoundedCorner: Shape {
    var radius : CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

let daysPerWeek = 7
var CalendarCellWidth: CGFloat = 32

extension ListingDetailView {
    func extractRoomInfo() -> String {
        guard let text = hotel.accessibilityLabel else { return "No data" }
        
        let regexPattern = #"(\d+)\s*beds?(?:\s*•\s*(\d+)\s*bedrooms?)?(?:\s*•\s*(\d+)\s*living rooms?)?(?:\s*•\s*(\d+)\s*bathrooms?)?|Hotel\s*room\s*:\s*(\d+)\s*bed"#

        if let regex = try? NSRegularExpression(pattern: regexPattern, options: []) {
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                let nsText = text as NSString

                if match.range(at: 1).location != NSNotFound {
                    let beds = nsText.substring(with: match.range(at: 1))
                    let bedrooms = match.range(at: 2).location != NSNotFound ? nsText.substring(with: match.range(at: 2)) : "0"
                    let livingRooms = match.range(at: 3).location != NSNotFound ? nsText.substring(with: match.range(at: 3)) : "0"
                    let bathrooms = match.range(at: 4).location != NSNotFound ? nsText.substring(with: match.range(at: 4)) : "0"
                    
                    return "\(beds) beds • \(bedrooms) bedrooms • \(livingRooms) living rooms • \(bathrooms) bathrooms"
                }
                
                if match.range(at: 5).location != NSNotFound {
                    let singleBed = nsText.substring(with: match.range(at: 5))
                    return "Hotel room: \(singleBed) bed"
                }
            }
        }
        
        return "Room info not found"
    }
}
