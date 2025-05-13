import Foundation

enum NetworkErrors : Error {
    case cantGetDestinations
    case cantGetHotels
    case cantSearchHotels
    case cantGetImage
    
    var errorDescription : String {
        switch self {
        case .cantGetDestinations:
            return "Cant get destinations for query"
        case .cantGetHotels:
            return "Cant get hotels"
        case .cantSearchHotels:
            return "Cant search for the hotels"
        case .cantGetImage:
            return "Cant get images for the hotel"
        }
    }
}
