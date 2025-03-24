import Foundation

enum UserError : Error {
    case emptyEmail
    case noCurrentUser
    
    var errorDescription: String {
        switch self {
        case .emptyEmail:
            return "User error is empty" 
        case .noCurrentUser:
            return "No current signed in user" 
        }
    }
}
