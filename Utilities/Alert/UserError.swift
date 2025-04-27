import Foundation

enum UserError : Error {
    case emptyEmail
    case noCurrentUser
    case noFirebaseUser
    case noUserId
    case cantSignOut
    case cantSignIn
    case cantUpdateEmail
    case cantUpdateUser
    
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
        case .cantSignOut:
            return "Cant sign out user"
        case .cantUpdateEmail:
            return "Cant update user email"
        case .cantUpdateUser:
            return "Cant update user"
        case .cantSignIn:
            return "Cant sign in"
        }
        
    }
}
