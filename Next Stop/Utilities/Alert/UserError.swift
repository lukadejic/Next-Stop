import Foundation

enum UserError : Error {
    case emptyEmail
    
    var errorDescription: String {
        switch self {
        case .emptyEmail:
            return "User error is empty" 
        }
    }
}
