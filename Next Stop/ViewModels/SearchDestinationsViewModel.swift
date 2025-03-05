
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
}

class SearchDestinationsViewModel : ObservableObject {
    @Published var numberOfGuests: Int = 0
    @Published var numberOfAdults: Int = 0
    @Published var numberOfChildred : Int = 0
    @Published var numberOfInfants: Int = 0
    @Published var numberOfPets : Int = 0
    
    private let searchService: LocationSearchService
    
    init(searchService: LocationSearchService) {
        self.searchService = searchService
    }
    
    let guestDetails: [(guest: String, age: String, selection: GuestsSelection)] = [
        ("Adults", "Age 13 or above", .adults),
        ("Children", "Ages 2-12", .childred),
        ("Infants", "Under 2", .infants),
        ("Pets", "", .pets)
    ]
    
    
}
