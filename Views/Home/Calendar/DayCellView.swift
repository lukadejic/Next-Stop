import SwiftUI

struct DayCellView: View {
    var calendarDate: CalendarDate
    var cellWidth: CGFloat
    var manager = CalendarManager()
    
    var body: some View {
        Text(calendarDate.getText())
            .font(calendarDate.getTextFont())
            .foregroundStyle(calendarDate.getTextColor())
            .frame(height: cellWidth)
            .frame(maxWidth: .infinity,alignment: .center)
            .font(.system(size: 20))
            .background(getCellBackgroundColor())
            .cornerRadius(radius, corners: corners)
    }
}

#Preview {
    Group{
        DayCellView(calendarDate: CalendarDate(date: Date(), manager: CalendarManager(), isDisabled: false, isToday: false, isSelected: false,isBetweenStartAndEnd: false,endDate: Date(),startDate: Date()), cellWidth: 32)
        
        DayCellView(calendarDate: CalendarDate(date: Date(), manager: CalendarManager(), isDisabled: false, isToday: true, isSelected: true,isBetweenStartAndEnd: false,endDate: Date(),startDate: Date()), cellWidth: 32)
        
        DayCellView(calendarDate: CalendarDate(date: Date(), manager: CalendarManager(), isDisabled: true, isToday: true, isSelected: false,isBetweenStartAndEnd: false,endDate: Date(),startDate: Date()), cellWidth: 32)
    }
    .frame(width: 32,height: 32)
}

private extension DayCellView {
    var corners: UIRectCorner {
        if calendarDate.isStartDate {
            return [.topLeft, .bottomLeft]
        }else if calendarDate.isEndDate {
            return [.topRight, .bottomRight]
        }else {
            return [.allCorners]
        }
    }
    
    var radius: CGFloat {
        calendarDate.isEndDate || calendarDate.isStartDate ? cellWidth / 2 : 0
    }
    func getCellBackgroundColor() -> Color {
        if calendarDate.isStartDate || calendarDate.isEndDate {
            return manager.colors.selectedBackColor
        } else if calendarDate.isBetweenStartAndEnd {
            return manager.colors.betweenStartAndEndBackColor
        } else if calendarDate.isSelected {
            return manager.colors.selectedBackColor
        } else {
            return calendarDate.getBackgroundColor()
        }
    }
    
    var isStartOrEndDate: Bool {
        return calendarDate.isStartDate || calendarDate.isEndDate
    }
}
