import Foundation

class LogInViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showSignUp = false
}
