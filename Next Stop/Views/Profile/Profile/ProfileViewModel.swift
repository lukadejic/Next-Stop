import Foundation
import FirebaseAuth

@MainActor
final class ProfileViewModel : ObservableObject {
    @Published var user: DBUser? = nil
    @Published var isLoading = false
    @Published var alertItem: AlertItem? = nil
    @Published var authProviders: [AuthProviderOption] = []
    
    @Published var userInfoList: [UserInfo] = []
    
    @Published var myWork: String = ""
    @Published var pets: String = ""
    @Published var languages: String = ""
    @Published var obsessed: String = ""
    @Published var biography: String = ""
    @Published var location: String = ""
    
    @Published var userEditProfileList: [UserInfo] = [
        UserInfo(icon: "speak", text: "Speaks", info: "", itemType: .language),
        UserInfo(icon: "like", text: "I'm obsessed with", info: "", itemType: .obsessed),
        UserInfo(icon: "book", text: "My biography title", info: "", itemType: .biography),
        UserInfo(icon: "globe", text: "Lives in", info: "", itemType: .location),
        UserInfo(icon: "briefcase", text: "My work", info: "", itemType: .work),
        UserInfo(icon: "paws", text: "Pets", info: "", itemType: .pets)
    ]
        
    private let authManager : AuthenticationProtocol
    private let userManager: UserManagerProtocol
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    init(authManager: AuthenticationProtocol, userManager: UserManagerProtocol) {
        self.authManager = authManager
        self.userManager = userManager
        self.getAuthenticatedUser()
        self.listenForAuthStateChanges()
    }
    
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

extension ProfileViewModel {
    
    //MARK: Authentication
    
    func loadAuthProviders() {
        if let providers = try? authManager.getProviders() {
            authProviders = providers
        }
    }
    
    func getAuthenticatedUser() {
        Task{
            do{
                let authDataResultModel = try authManager.getAuthenticatedUser()
                self.user = try await userManager.getUser(userId: authDataResultModel.uid)
            }catch{
                throw SignUpError.firebaseError(error: error)
            }
        }
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            user = nil
        } catch {
            print("Failed to sign out: \(error)")
        }
    }
    
    func deleteUser() {
        Task{
            do{
                try await authManager.deleteUser()
                alertItem = AlertContext.succesfulyDeletedUser
            }catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func resetPassword() {
        Task{
            do{
                let user = try authManager.getAuthenticatedUser()
                
                guard let email = user.email else {
                    throw UserError.emptyEmail
                }
                
                try await authManager.resetPassword(email: email)
                
            }catch let error as NSError {
                if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                    switch authErrorCode {
                    case .invalidRecipientEmail:
                        alertItem = AlertContext.invalidEmail
                    default:
                        alertItem = AlertContext.defaultError
                    }
                }
                
            }
        }
    }
    
    func updateEmail() {
        let email = "lukadejic1234@gmail.com"
        Task{
            do{
                try await authManager.updateEmail(email: email)
                self.alertItem = AlertContext.succesfulEmailUpdate
            }catch{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func updatePassword() {
        let password = "Password031."
        Task{
            do{
                try await authManager.updatePassword(password: password)
                self.alertItem = AlertContext.succesfulPasswordUpdate
            }catch{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: User info
    func updateUserInfo(for itemType: UserInfoItem, newInfo: String) {
        if let index = userEditProfileList.firstIndex(where: { $0.itemType == itemType }) {
            userEditProfileList[index].info = newInfo
        }
        
        if let newUserInfo = userEditProfileList.first(where: { $0.itemType == itemType }) {
            userInfoList.append(newUserInfo)
        }
    }
    
    // MARK: Auth State Listener
    
    func listenForAuthStateChanges() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            Task {
                if let user = user {
                    do {
                        self.user = try await self.userManager.getUser(userId: user.uid)
                    } catch {
                        self.user = nil
                    }
                } else {
                    self.user = nil
                }
            }
        }
    }
    
    //MARK: Firestore
    
    func updateUserBiography() {
        guard let user else { return }
        
        Task{
            do{
                try await userManager.updateUserBiography(userId: user.userId,
                                                          biography: self.biography)
                
                self.user = try await userManager.getUser(userId: user.userId)
            }catch{
                
            }
        }
    }
    
    func addUserPreference(text: String) {
        guard let user else { return }
        
        Task{
            do{
                try await userManager.updatePreferences(userId: user.userId, preference: text)
                
                self.user = try await userManager.getUser(userId: user.userId)
            }catch{
                
            }
        }
    }
    
    func removeUserPreference(text: String) {
        guard let user else { return }
        
        Task{
            do{
                try await userManager.removePreferences(userId: user.userId, preference: text)
                
                self.user = try await userManager.getUser(userId: user.userId)
            }catch{
                
            }
        }
    }
}
