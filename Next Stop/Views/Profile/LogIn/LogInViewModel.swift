import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
final class LogInViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showSignUp = false
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var succesful = false
    
    let authManager: AuthenticationProtocol
    
    init(authManager: AuthenticationProtocol) {
        self.authManager = authManager
    }
    
    func signIn() {
        do{
            try validateFields()
            Task{
                do{
                    try await Auth.auth().signIn(withEmail: email, password: password)
                    DispatchQueue.main.async {
                        self.succesful = true
                        self.alertItem = nil
                    }
                }catch let error as NSError {
                    if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                        switch authErrorCode {
                        case .invalidCredential:
                            alertItem = AlertContext.userNotFound
                        default:
                            alertItem = AlertContext.firebaseError
                        }
                    }
                }
            }
        }catch let error as SignUpError {
            mapErrorToAlert(error)
        }catch {
            self.alertItem = AlertContext.firebaseError
        }
    }
    
    private func validateFields() throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw SignUpError.emptyFields
        }
        
        guard isEmailValid(email) else {
            throw SignUpError.invalidEmail
        }
        
        guard isValidPassword(password) else {
            throw SignUpError.weakPassword
        }

    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    private func mapErrorToAlert(_ error: SignUpError) {
        switch error {
        case .emptyFields:
            alertItem = AlertContext.emptyFields
        case .passwordsNotMached:
            alertItem = AlertContext.passwordsDoNotMatch
        case .weakPassword:
            alertItem = AlertContext.weakPassword
        case .firebaseError(_):
            alertItem = AlertContext.firebaseError
        case .invalidEmail:
            alertItem = AlertContext.invalidEmail
        case .wrongEmail:
            alertItem = AlertContext.invalidEmail
        case .wrongPassword:
            alertItem = AlertContext.wrongPassword
        }
    }
}
