import Foundation
import FirebaseAuth
import SwiftUI

struct UserInfo: Identifiable {
    var id = UUID()
    var icon: String
    var text: String
    var info: String
    var itemType: UserInfoItem
    
    init(icon: String, text: String, info: String, itemType: UserInfoItem) {
        self.icon = icon
        self.text = text
        self.info = info
        self.itemType = itemType
    }
}

@MainActor
final class ProfileViewModel : ObservableObject {
    @Published var user: AuthDataResultModel? = nil
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
        UserInfo(icon: "speak", text: "Speaks", info: "English and Spanish", itemType: .language),
        UserInfo(icon: "like", text: "I'm obsessed with", info: "Something", itemType: .obsessed),
        UserInfo(icon: "book", text: "My biography title", info: "", itemType: .biography),
        UserInfo(icon: "globe", text: "Lives in", info: "", itemType: .location),
        UserInfo(icon: "briefcase", text: "My work", info: "Software Developer", itemType: .work),
        UserInfo(icon: "paws", text: "Pets", info: "", itemType: .pets)
    ]
        
    private let authManager : AuthenticationProtocol
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    init(authManager: AuthenticationProtocol) {
        self.authManager = authManager
        self.getAuthenticatedUser()
        self.listenForAuthStateChanges()
    }
    
    func updateUserInfo(for itemType: UserInfoItem, newInfo: String) {
        if let index = userEditProfileList.firstIndex(where: { $0.itemType == itemType }) {
            userEditProfileList[index].info = newInfo
        }
    }
    
    func loadAuthProviders() {
        if let providers = try? authManager.getProviders() {
            authProviders = providers
        }
    }
    
    func getAuthenticatedUser() {
        Task{
            do{
                self.user = try authManager.getAuthenticatedUser()
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
    
    func deleteUser(){
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
    
    func listenForAuthStateChanges() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.user = AuthDataResultModel(user: user)
            } else {
                self.user = nil
            }
        }
    }
    
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
