import Foundation

class LogInViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showSignUp = false
}
