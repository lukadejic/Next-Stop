import Foundation

enum UserError : Error {
    case emptyEmail
    case noCurrentUser
    case noFirebaseUser
    case noUserId
    
    var errorDescription: String {
        switch self {
        case .emptyEmail:
            return "User error is empty" 
        case .noCurrentUser:
            return "No current signed in user"
        case .noFirebaseUser:
            return "No user in the firebase"
        case .noUserId:
            return "User id is empty"
        }
        
    }
}
