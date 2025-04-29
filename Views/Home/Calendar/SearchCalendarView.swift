import SwiftUI

struct SearchCalendarView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: SearchDestinationsViewModel
    
    @State private var manager = CalendarManager (
        calendar: Calendar.current,
        minimumDate: Date(),
        maximumDate: Date().addingTimeInterval(60*60*24*365)
    )
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading){
                VStack(alignment: .leading,spacing: 10) {
                    Text("When's your trip?")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, maxHeight: 80,alignment: .leading)
                .padding(.leading)
                
                Divider()
                    .padding(.horizontal)
                
                RangeCalendarView(manager: manager)
            }
            .onAppear {
                manager.startDate = vm.startDate
                manager.endDate = vm.endDate
            }
            .onDisappear {
                setSelectedDates()
            }
            .padding(.trailing)
        }
    }
}


#Preview {
    SearchCalendarView(vm: SearchDestinationsViewModel(
        searchService: LocationSearchService()))
}

private extension SearchCalendarView {
    func setSelectedDates() {
        vm.saveAvailibilyDate(startDate: manager.startDate,
                              endDate: manager.endDate)
        
        vm.saveArrivalDay(arrivalDay: manager.startDate)
    }
}
