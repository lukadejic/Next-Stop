
import Foundation

enum StayOptionType: String, CaseIterable {
    case rooms = "Rooms"
    case beachfront = "Beachfront"
    case camping = "Camping"
    case food = "Food"
    case explore = "Explore"
    
    var imageName: String {
        switch self {
        case .rooms: return "house.fill"
        case .beachfront: return "beach.umbrella"
        case .camping: return "tent.2"
        case .food: return "fork.knife"
        case .explore: return "map.fill"
        }
    }
}
