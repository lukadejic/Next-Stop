
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
    
    @Published var selectedOption : AgeOption? = nil
    @Published var childrenAges : [Int] = []
    let options = AgeOption.allCases

    
    let manager = CalendarManager()
    @Published var searchOption : DestinationSearchOption = .none
    
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
