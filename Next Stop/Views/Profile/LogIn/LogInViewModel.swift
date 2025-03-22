import Foundation
import SwiftUI

@MainActor
final class LogInViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showSignUp = false
    @Published var alertItem: AlertItem? = nil
    @Published var isLoading = false
    
    let authManager: AuthenticationProtocol
    
    init(authManager: AuthenticationProtocol) {
        self.authManager = authManager
    }
    
    func signIn() {
        do{
            try validateFields()
            isLoading = true
            
            Task{
                do{
                    let authResultModel = try await authManager.signIn(email: email, password: password)
                    print("Succesfull")
                    print(authResultModel)
                    self.alertItem = nil
                    isLoading = false
                }catch{
                    self.alertItem = AlertItem(title: Text("Sign in failed"),
                                               message: Text(error.localizedDescription),
                                               dismissButton: .default(Text("Ok")))
                    isLoading = false
                }
            }
        }catch let error as SignUpError {
            mapErrorToAlert(error)
            isLoading = false
        }catch {
            self.alertItem = AlertContext.firebaseError
            isLoading = false
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
        }
    }
}
