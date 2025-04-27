import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm : HomeViewModel
    let hotel: Hotel
    
    @State private var manager = CalendarManager (
        calendar: Calendar.current,
        minimumDate: Date(),
        maximumDate: Date().addingTimeInterval(60*60*24*365)
    )
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading){
                VStack(alignment: .leading,spacing: 10) {
                    if manager.startDate != nil, manager.endDate != nil {
                        Text("\(manager.selectedNumberOfDays()) Nights")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Text(CalendarHelpers.formattedRangeDate(startDate: manager.startDate, endDate: manager.endDate) ?? "")
                }
                .frame(maxWidth: .infinity, maxHeight: 80,alignment: .leading)
                .padding(.leading)
                
                Divider()
                    .padding(.horizontal)
                
                RangeCalendarView(manager: manager)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "xmark")
                            .tint(.black)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Clear dates")
                        .underline()
                        .onTapGesture {
                            clearDates()
                        }
                }
            }
        }
        .onAppear{
            setSelectedDates()
        }
        .overlay(alignment: .bottom){
            PriceSectionView(price: vm.hotelDetail?.product_price_breakdown?.charges_details?.amount?.value,
                             rating: hotel.property?.reviewScore,
                             buttonText: "Save") {
                saveSelectedDate()
                saveArrivalDay()
            }
        }
    }
}

#Preview {
    CalendarView(hotel: MockData.mockHotel)
        .environmentObject(HomeViewModel(hotelsService: HotelsService(networkManager: NetworkManager())))
}

private extension CalendarView {
    func clearDates() {
        manager.startDate = nil
        manager.endDate = nil
    }
    
    func saveSelectedDate() {
        vm.saveAvailibilyDate(startDate: manager.startDate, endDate: manager.endDate)
        dismiss()
    }
    
    func saveArrivalDay() {
        vm.saveArrivalDay(arrivalDay: manager.startDate)
    }
    
    func setSelectedDates() {
        if vm.startDate == nil {
            vm.startDate = CalendarHelpers.convertStringToDate(date: hotel.property?.checkinDate)
        }
        
        if vm.endDate == nil {
            vm.endDate = CalendarHelpers.convertStringToDate(date: hotel.property?.checkoutDate)
        }
        
        manager.startDate = vm.startDate
        manager.endDate = vm.endDate
    }
}
