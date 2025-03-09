
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

enum AgeOption: String, CaseIterable {
    case lessThanOne = "< 1 year old"
    case one = "1 year old"
    case two = "2 years old"
    case three = "3 years old"
    case four = "4 years old"
    case five = "5 years old"
    case six = "6 years old"
    case seven = "7 years old"
    case eight = "8 years old"
    case nine = "9 years old"
    case ten = "10 years old"
    case eleven = "11 years old"
    case twelve = "12 years old"
    case thirteen = "13 years old"
    case fourteen = "14 years old"
    case fifteen = "15 years old"
    case sixteen = "16 years old"
    case seventeen = "17 years old"

    static var allCasesArray: [String] {
        return AgeOption.allCases.map { $0.rawValue }
    }
}

