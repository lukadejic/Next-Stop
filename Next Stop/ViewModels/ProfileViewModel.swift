import Foundation
import FirebaseAuth

@MainActor
final class ProfileViewModel : ObservableObject {
    @Published var user: DBUser? = nil
    @Published var isLoading = false
    @Published var alertItem: AlertItem? = nil
    @Published var authProviders: [AuthProviderOption] = []
    
    @Published var userInfoList: [UserInfo] = []
    @Published var userEditProfileList: [UserInfo] = []
        
    @Published var userLanguages : [String] = []
    
    @Published var interests: [Interest] = []
    
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
    
    func loadInterests() {
        self.interests = user?.interests ?? []
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
                
                loadUserData()
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

    func loadUserData() {
        loadUserInfoList()
        populateUserEditProfileList()
    }
    
    func loadUserInfoList() {
        guard let user else { return }
        
        var tempList : [UserInfo] = []
        
        if let biography = user.biography, !biography.isEmpty {
            tempList.append(UserInfo(icon: "book", text: "My biography title", info: biography, itemType: .biography))
        }
        
        if let languages = user.languages, !languages.isEmpty {
            tempList.append(UserInfo(icon: "speak", text: "Languages i speak", info: languages.joined(separator: ", "), itemType: .language))
        }
        
        if let obsessed = user.obsessed, !obsessed.isEmpty {
            tempList.append(UserInfo(icon: "like", text: "I'm obsessed with", info: obsessed, itemType: .obsessed))
        }
        
        if let location = user.location, !location.isEmpty {
            tempList.append(UserInfo(icon: "globe", text: "Lives in", info: location, itemType: .location))
        }
        
        if let work = user.work, !work.isEmpty {
            tempList.append(UserInfo(icon: "briefcase", text: "My work", info: work, itemType: .work))
        }
        
        if let pets = user.pets, !pets.isEmpty {
            tempList.append(UserInfo(icon: "paws", text: "Pets", info: pets, itemType: .pets))
        }
        
        self.userInfoList = tempList
    }
    
    func populateUserEditProfileList() {
        let tempList : [UserInfo] = [
            UserInfo(icon: "speak", text: "Speaks",
                     info: user?.languages?.joined(separator: ", ") ?? "", itemType: .language),
            UserInfo(icon: "like", text: "I'm obsessed with", info: user?.obsessed ?? "", itemType: .obsessed),
            UserInfo(icon: "book", text: "My biography title", info: user?.biography ?? "", itemType: .biography),
            UserInfo(icon: "globe", text: "Lives in", info: user?.location ?? "", itemType: .location),
            UserInfo(icon: "briefcase", text: "My work", info: user?.work ?? "", itemType: .work),
            UserInfo(icon: "paws", text: "Pets", info: user?.pets ?? "", itemType: .pets)]
        
        self.userEditProfileList = tempList
    }
    
    func updateUserBiography(bio: String) {
        guard let user else { return }
        
        Task{
            do{
                try await userManager.updateUserBiography(userId: user.userId,
                                                          biography: bio)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                loadUserData()
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
    
    func addUserLanguages(languages: [String]) {
        
        guard let user else { return }
        
        Task{
            do{
                try await userManager.updateLanguages(userId: user.userId, languages: languages)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                loadUserData()
            }catch {
                
            }
        }
    }
    
    func updateObsessedUserText(text: String) {
        
        guard let user else { return }
        
        Task{
            do{
                try await userManager.updateObsessed(userId: user.userId, text: text)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                loadUserData()
            }catch {
                
            }
        }
    }
    
    func updateUserLocation(location: String) {
        
        guard let user else { return }
        
        Task{
            do{
                try await userManager.updateLocation(userId: user.userId, location: location)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                loadUserData()
            }catch {
                
            }
        }
    }
    
    func updateUserWork(work: String) {
        
        guard let user else { return }
        
        Task{
            do{
                try await userManager.updateWork(userId: user.userId, work: work)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                loadUserData()
            }catch {
                
            }
        }
    }
    
    func updateUserPets(pets: String) {
        
        guard let user else { return }
        
        Task{
            do{
                try await userManager.updatePets(userId: user.userId, pets: pets)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                loadUserData()
            }catch {
                
            }
        }
    }
    
    func updateUserInterests() {
        guard let user else { return }
        
        Task{
            do{
                try await userManager.updateUserInterests(userId: user.userId, interests: interests)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                loadUserData()
            }catch {
                
            }
        }
    }
}
