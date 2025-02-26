import Foundation
import SwiftUI

class ColorSettins {
    var textColor = Color.primary
    var todayColor = Color.red
    var selectedColor = Color.white
    var betweenStartAndEndColor = Color.white
    var disabledColor = Color.gray
    var todayBackColor = Color.gray
    var textBackColor = Color.clear
    var disabledBackColor = Color.clear
    var selectedBackColor = Color.blue
    var betweenStartAndEndBackColor = Color.init(.systemGray3)
    var calendarBackColor = Color.init(.systemGray6)
    var weekdayHeaderColor = Color.secondary
    var monthHeaderColor = Color.primary
    var monthHeaderBackColor = Color.clear
    var monthBackColor = Color.clear
}

class FontSettings {
    var monthHeaderFont : Font = .body.bold()
    var weekdayHeaderFont : Font = .caption
    var cellUnselectedFont : Font = .body
    var cellDisabledFont : Font = .body.weight(.light)
    var cellSelectedFont : Font = .body.bold()
    var cellTodayFont : Font = .body.bold()
    var cellBetweenStartAndEndFont : Font = .body.bold()
}
