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
    private let userManager: UserManagerProtocol
    
    init(authManager: AuthenticationProtocol, userManager: UserManagerProtocol) {
        self.authManager = authManager
        self.userManager = userManager
    }
    
    func signUp() async throws {
        do {
            try AuthValidator.validateFields(email: email,
                                             password: password,
                                             confirmPassword: confirmPassword,
                                             username: username)
            
            var authDataResult = try await authManager.createUser(email: email, password: password)
            authDataResult.displayName = username
            try await userManager.createUser(auth: authDataResult)
            
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
