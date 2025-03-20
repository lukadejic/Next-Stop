import Foundation

@MainActor
final class SignUpViewModel : ObservableObject {
    
    @Published var confirmPassword = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var error : String? = nil
    
    private let authManager : AuthenticationProtocol
    
    init(authManager: AuthenticationProtocol){
        self.authManager = authManager
    }
    
    func signUp() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            error = "All fields must be filled"
            return
        }
        
        guard confirmPassword == password else {
            error = "Passwords do not match"
            return
        }
        
        guard isValidPassword(password) else {
            error = "Password is too weak"
            return
        }
        
        Task{
            do{
                let returnedData = try await authManager.createUser(
                    email: email,
                    password: password)
                print("Success")
                print(returnedData)
                self.error = nil
            }catch{
                self.error = error.localizedDescription
            }
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // Proverava da li lozinka ima najmanje 8 karaktera, jedan broj i jedan specijalni znak
        let passwordRegEx = "^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
}
