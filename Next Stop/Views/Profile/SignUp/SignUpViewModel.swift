import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
final class SignUpViewModel : ObservableObject {
    
    @Published var confirmPassword = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var alertItem: AlertItem? = nil
    @Published var succesful = false
    
    private let authManager : AuthenticationProtocol
    
    init(authManager: AuthenticationProtocol) {
        self.authManager = authManager
    }
    
    func signUp() async throws {
        do {
            try AuthValidator.validateFields(email: email,
                                             password: password,
                                             confirmPassword: confirmPassword)
            
            try await authManager.createUser(email: email, password: password)
            
            self.succesful = true
            
        } catch let error as SignUpError {
            alertItem = AuthValidator.mapErrorToAlert(error)
        } catch let error as NSError {
            if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                switch authErrorCode {
                case .emailAlreadyInUse:
                    alertItem = AlertContext.emailAlreadyExsists
                default:
                    alertItem = AlertContext.firebaseError
                }
            }
            self.succesful = false
        } catch {
            self.alertItem = AlertContext.firebaseError
        }
    }


}
