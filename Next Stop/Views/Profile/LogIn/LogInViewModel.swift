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
    
    func signIn() async throws {
        do {
            try AuthValidator.validateFields(email: email, password: password)
            try await Auth.auth().signIn(withEmail: email, password: password)
            
            self.succesful = true
            
        } catch let error as SignUpError {
            alertItem = AuthValidator.mapErrorToAlert(error)
        } catch let error as NSError {
            if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                switch authErrorCode {
                case .invalidCredential:
                    alertItem = AlertContext.userNotFound
                default:
                    alertItem = AlertContext.firebaseError
                }
            }
            self.succesful = false
        }
    }
    
    func signInWithGoogle() async throws {
        let tokens = try await SignInGoogleHelper.signIn()
        
        try await authManager.signInWithGoogle(tokens: tokens)
    }
}
