
import Foundation

enum StayOptionType: String, CaseIterable {
    case lakeFront = "Lakefront"
    case beachfront = "Beachfront"
    case cabins = "Cabins"
    case pools = "Pools"
    case skiing = "Skiing"
    
    var imageName: String {
        switch self {
        case .lakeFront: return "house.fill"
        case .beachfront: return "beach.umbrella"
        case .cabins: return "tent.2"
        case .pools: return "figure.pool.swim"
        case .skiing: return "figure.skiing.downhill"
        }
    }
    
    var querryKeywords : String {
        switch self {
        case .lakeFront: return "lake"
        case .beachfront: return "beach"
        case .cabins: return "cabin"
        case .pools: return "pool"
        case .skiing: return "skiing"
        }
    }
}
