
import Foundation

enum GuestsSelection {
    case adults
    case childred
    case infants
    case pets
}

class SearchDestinationsViewModel : ObservableObject {
    @Published var numberOfGuests: Int = 0
    @Published var numberOfAdults: Int = 0
    @Published var numberOfChildred : Int = 0
    @Published var numberOfInfants: Int = 0
    @Published var numberOfPets : Int = 0
}
