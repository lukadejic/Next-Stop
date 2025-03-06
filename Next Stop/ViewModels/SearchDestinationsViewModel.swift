
import Foundation

enum GuestsSelection {
    case adults
    case childred
    case infants
    case pets
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
    @Published var numberOfInfants: Int = 0
    @Published var numberOfPets : Int = 0
    
    
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var arrivalDay: Date? = nil
    
    
    let manager = CalendarManager()
    @Published var searchOption : DestinationSearchOption = .none
    
    var searchService: LocationSearchService
    private let hotelService : HotelsService
    
    init(searchService: LocationSearchService, hotelSerice: HotelsService) {
        self.searchService = searchService
        self.hotelService = hotelSerice
    }
    
    let guestDetails: [(guest: String, age: String, selection: GuestsSelection)] = [
        ("Adults", "Age 13 or above", .adults),
        ("Children", "Ages 2-12", .childred),
        ("Infants", "Under 2", .infants),
        ("Pets", "", .pets)
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
