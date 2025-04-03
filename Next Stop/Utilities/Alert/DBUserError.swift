import Foundation

enum DBUserError: Error {
    case noData
    case noUserId
    
    var description: String {
        switch self {
        case .noData:
            return "No user data found"
        case .noUserId:
            return "No user id found"
        }
    }
}
