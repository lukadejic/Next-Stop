import Foundation

enum SignUpError : Error {
    case invalidEmail
    case emptyFields
    case passwordsNotMached
    case weakPassword
    case firebaseError(error: Error)
    case wrongEmail
    case wrongPassword
    
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
        case .wrongEmail:
            return "User with this email does not exist"
        case .wrongPassword:
            return "Incorect password"
        }
    }
}
