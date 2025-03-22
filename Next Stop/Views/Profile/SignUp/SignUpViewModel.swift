import Foundation
import SwiftUI

@MainActor
final class SignUpViewModel : ObservableObject {
    
    @Published var confirmPassword = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var alertItem: AlertItem? = nil
    
    private let authManager : AuthenticationProtocol
    
    init(authManager: AuthenticationProtocol){
        self.authManager = authManager
    }
    
    func signUp() {
        do{
            try validateFields()
            
            Task{
                do{
                    try await authManager.createUser(email: email, password: password)
                    self.alertItem = nil
                }catch{
                    self.alertItem = AlertItem(title: Text("Sign up failed"),
                                               message: Text(error.localizedDescription),
                                               dismissButton: .default(Text("Ok")))
                }
            }
        }catch let error as SignUpError {
            mapErrorToAlert(error)
        }catch{
            self.alertItem = AlertContext.firebaseError
        }
    }

    private func validateFields() throws {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            throw SignUpError.emptyFields
        }
        
        guard confirmPassword == password else {
            throw SignUpError.passwordsNotMached
        }
        
        guard isValidPassword(password) else {
            throw SignUpError.weakPassword
        }
        
        guard isEmailValid(email) else {
            throw SignUpError.invalidEmail
        }
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
        }
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
}
