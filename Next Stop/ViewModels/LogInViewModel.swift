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
    
    private let authManager: AuthenticationProtocol
    private let userManager: UserManagerProtocol
    
    init(authManager: AuthenticationProtocol, userManager : UserManagerProtocol) {
        self.authManager = authManager
        self.userManager = userManager
    }
    
    func signIn() {
        validateFields()

        Task {
            do {
                try await authManager.signIn(email: email, password: password)
                self.succesful = true
            } catch let error as NSError {
                if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                    switch authErrorCode {
                    case .invalidCredential:
                        alertItem = AlertContext.userNotFound
                    default:
                        alertItem = AlertContext.defaultError
                    }
                }
                self.succesful = false
            }
        }
    }
    
    func signInWithGoogle() async throws {
        let tokens = try await SignInGoogleHelper.signIn()
        
        let authDataResult = try await authManager.signInWithGoogle(tokens: tokens)
        
        let user = DBUser(user: authDataResult)
        
        try await userManager.createNewUser(user: user)
    }
    
    private func validateFields() {
        do {
            try AuthValidator.validateFields(email: email, password: password)
        } catch {
            if let signUpError = error as? SignUpError {
                alertItem = AuthValidator.mapErrorToAlert(signUpError)
            }
            self.succesful = false
            return
        }
    }
}
