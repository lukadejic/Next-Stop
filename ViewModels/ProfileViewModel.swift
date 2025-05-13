import FirebaseAuth
import SwiftUI

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
    
    let authManager : AuthenticationProtocol
    let userManager: UserManagerProtocol
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    init(authManager: AuthenticationProtocol, userManager: UserManagerProtocol) {
        self.authManager = authManager
        self.userManager = userManager
        //self.getAuthenticatedUser()
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
        Task {
            do {
                let authDataResultModel = try authManager.getAuthenticatedUser()
                
                self.user = try await userManager.getUser(userId: authDataResultModel.uid)
                
                loadUserData()
            } catch {
                throw UserError.noCurrentUser
            }
        }
    }

    // test_signOut_signesOut()
    // test_signOut_throwsError()
    func signOut() throws {
        do {
            try authManager.signOut()
            user = nil
        } catch {
            throw UserError.cantSignOut
        }
    }
    
    // swiftlint
    func deleteUser() {
        Task{
            do {
                try await authManager.deleteUser()
                alertItem = AlertContext.succesfulyDeletedUser
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func resetPassword() {
        do {
            let user = try authManager.getAuthenticatedUser()
            
            guard let email = user.email else {
                alertItem = AlertContext.invalidEmail
                throw UserError.emptyEmail
            }
            
            Task {
                try await authManager.resetPassword(email: email)
                self.alertItem = AlertContext.resetPasswordSuccess
            }
            
        } catch let error as NSError {
            if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                switch authErrorCode {
                case .invalidRecipientEmail:
                    alertItem = AlertContext.invalidRecipientEmail
                default:
                    alertItem = AlertContext.defaultError
                }
            }
        }
        
    }
    
    // test_updateEmail_updatesEmail
    // test_updateEmail_throwsError
    
    func updateEmail(email: String) {
        Task {
            do {
                try await authManager.updateEmail(email: email)
                self.alertItem = AlertContext.succesfulEmailUpdate
            } catch let error as NSError {
                if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                    switch authErrorCode {
                    case .invalidRecipientEmail:
                        self.alertItem = AlertContext.invalidRecipientEmail
                        throw UserError.cantUpdateEmail
                    default :
                        self.alertItem = AlertContext.defaultError
                        throw UserError.cantUpdateEmail
                    }
                }
            }
        }
    }
    
    func updatePassword(password: String) {
        Task {
            do {
                try await authManager.updatePassword(password: password)
                self.alertItem = AlertContext.succesfulPasswordUpdate
            } catch {
                
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

    private func loadUserData() {
        loadUserInfoList()
        populateUserEditProfileList()
    }
    
    
    //test_loadUserInfoList_shouldLoadUserInfoList
    private func loadUserInfoList() {
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
    
    private func populateUserEditProfileList() {
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
    
    func loadInterests() {
        self.interests = user?.interests ?? []
    }
    
    
    //test_updateUserBiography_updatesBiography
    func updateUserBiography(bio: String) {
        guard let user else { return }
        
        Task {
            do {
                let data : [String : Any] = [DBUser.CodingKeys.biography.rawValue : bio]
                
                try await userManager.updateUser(userId: user.userId, with: data)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                self.alertItem = AlertContext.updateUserBioSucessfull
                
                loadUserData()
            } catch {
                self.alertItem = AlertContext.updateUserBioError
                throw UserError.cantUpdateUser
            }
        }
    }
    
    func addUserPreference(text: String) {
        guard let user else { return }
        
        Task {
            do {
                try await userManager.updatePreferences(userId: user.userId, preference: text)
                
                self.user = try await userManager.getUser(userId: user.userId)
            } catch {
                
            }
        }
    }
    
    func removeUserPreference(text: String) {
        guard let user else { return }
        
        Task {
            do {
                try await userManager.removePreferences(userId: user.userId, preference: text)
                
                self.user = try await userManager.getUser(userId: user.userId)
            } catch {
                
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
    
    func updateUserInterests2() {
        guard let user else { return }
        
        Task{
            do{
                let data : [String : Any] = [DBUser.CodingKeys.interests.rawValue : user.interests ?? []]
                
                try await userManager.updateUser(userId: user.userId, with: data)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                loadUserData()
            }catch {
                
            }
        }
    }
    
    func updateUserProfilePicture(picture: UIImage) {
        guard let user else { return }
        
        Task {
            do {
                try await userManager.updateUserProfilePicture(userId: user.userId, picture: picture)
                
                self.user = try await userManager.getUser(userId: user.userId)
                
                loadUserData()
            } catch {
                print("Failed to update user profile image")
            }
        }
    }
    
    

}
