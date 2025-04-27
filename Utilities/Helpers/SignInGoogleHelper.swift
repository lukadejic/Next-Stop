import Foundation
import GoogleSignIn
import GoogleSignInSwift

final class SignInGoogleHelper {
    @MainActor
    static func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilites.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }

        let accessToken: String = gidSignInResult.user.accessToken.tokenString

        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        
        let tokens = GoogleSignInResultModel(idToken: idToken,
                                             accessToken: accessToken,
                                             name: name,
                                             email: email)
        return tokens
    }
}
