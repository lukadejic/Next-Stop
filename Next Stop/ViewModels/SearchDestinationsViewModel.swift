
import Foundation

enum GuestsSelection {
    case adults
    case childred
    case infants
    case pets
    case rooms
}

enum DestinationSearchOption {
    case destination
    case dates
    case guests
    case none
}

class SearchDestinationsViewModel : ObservableObject {
    @Published var search: String = ""
    @Published var numberOfGuests: Int = 0
    @Published var numberOfAdults: Int = 0
    @Published var numberOfChildred : Int = 0
    @Published var numberOfRooms : Int = 0
    @Published var numberOfInfants: Int = 0
    @Published var numberOfPets : Int = 0
    
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var arrivalDay: Date? = nil
    
    @Published var selectedOption = "Opcija 1"
    
    let options = ["< 1 year old", "1 year old", "2 years old", "3 years old", "4 years old", "5 years old", "6 years old", "7 years old", "8 years old", "9 years old", "10 years old", "11 years old", "12 years old", "13 years old", "14 years old", "15 years old", "16 years old", "17 years old"]

    
    let manager = CalendarManager()
    @Published var searchOption : DestinationSearchOption = .guests
    
    var searchService: LocationSearchService
    
    init(searchService: LocationSearchService) {
        self.searchService = searchService
    }
    
    let guestDetails: [(guest: String, age: String, selection: GuestsSelection)] = [
        ("Adults", "Age 13 or above", .adults),
        ("Children", "Ages 0-17", .childred),
        ("Rooms", "", .rooms)
    ]
    
    func saveAvailibilyDate(startDate: Date? , endDate: Date?) {
        guard let startDate = startDate, let endDate = endDate else { return }
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func saveArrivalDay(arrivalDay: Date?) {
        guard let arrivalDay = arrivalDay else { return }
        self.arrivalDay = arrivalDay
    }
    

}
