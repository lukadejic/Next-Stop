import Foundation

class AuthValidator {
    
    static func validateFields(email: String,
                               password: String,
                               confirmPassword: String? = nil,
                               username: String? = nil) throws {
        
        guard !email.isEmpty, !password.isEmpty else {
            throw SignUpError.emptyFields
        }

        if let confirmPassword = confirmPassword {
            guard !confirmPassword.isEmpty else {
                throw SignUpError.emptyFields
            }
            guard confirmPassword == password else {
                throw SignUpError.passwordsNotMached
            }
        }
        
        if let username = username {
            guard !username.isEmpty else {
                throw SignUpError.emptyFields
            }
        }
        
        guard isValidPassword(password) else {
            throw SignUpError.weakPassword
        }
        
        guard isEmailValid(email) else {
            throw SignUpError.invalidEmail
        }
    }
    
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    static func mapErrorToAlert(_ error: SignUpError) -> AlertItem {
        switch error {
        case .emptyFields:
            AlertContext.emptyFields
        case .passwordsNotMached:
            AlertContext.passwordsDoNotMatch
        case .weakPassword:
            AlertContext.weakPassword
        case .firebaseError(_):
            AlertContext.firebaseError
        case .invalidEmail:
            AlertContext.invalidEmail
        case .wrongEmail:
            AlertContext.invalidEmail
        case .wrongPassword:
            AlertContext.wrongPassword
        }
    }
}
