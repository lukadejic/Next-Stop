import Foundation

enum SignUpError : Error {
    case invalidEmail
    case emptyFields
    case passwordsNotMached
    case weakPassword
    case firebaseError(error: Error)
    
    var errorDescription: String {
        switch self {
        case .emptyFields:
            return "All fields must be filled"
        case .passwordsNotMached:
            return "Passwords do not match"
        case .weakPassword:
            return "Password is too weak"
        case .firebaseError(let error):
            return error.localizedDescription
        case .invalidEmail:
            return "Invalid email format"
        }
    }
}
