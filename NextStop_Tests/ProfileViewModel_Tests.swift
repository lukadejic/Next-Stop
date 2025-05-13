import XCTest
@testable import Next_Stop
@testable
import FirebaseAuth
import SwiftUI

@MainActor
final class ProfileViewModel_Tests: XCTestCase {
    private(set) var sut: ProfileViewModel!
    private(set) var authMock: MockAuthenticationManager!
    private(set) var userManagerMock: MockUserManager!
    
    override func setUp() {
        super.setUp()
        authMock = .init()
        userManagerMock = .init()
        sut = .init(authManager: authMock, userManager: userManagerMock)
    }
    
    override func tearDown() {
        super.tearDown()
        authMock = nil
        userManagerMock = nil
        sut = nil
    }

    func test_signOut_signesOut() {
        //given
        
        //when
        try? sut.signOut()
        
        //then
        
        XCTAssertNil(sut.user)
        XCTAssertNoThrow(try? sut.signOut())
    }
    
    func test_signOut_throwsError() {
        //given
        authMock.error = UserError.cantSignOut
        
        //when
        
        //then
        
        XCTAssertThrowsError(try sut.signOut())
    }
    
    func test_resetPassword_resetsPassword() {
        // given
        authMock.user = .init(uid: UUID().uuidString,
                                     email: "foo@gmail.com", photoURL: nil, displayName: nil)
            
        // when
        authMock.expectation = expectation(description: #function)
        
        sut.resetPassword()

        waitForExpectations(timeout: 5)
        // then
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertEqual(sut.alertItem, AlertContext.resetPasswordSuccess)
    }
    
    func test_resetPassword_onInvalidEmail_emptyEmail() {
        // given
        authMock.user = .init(uid: UUID().uuidString, email: nil,
                                     photoURL: "dda", displayName: "dada")
        
        // when
        sut.resetPassword()
        
        // then
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertEqual(sut.alertItem, AlertContext.invalidEmail)
    }
    
    func test_updateEmail_updatesEmail() {
        //given
        let email = "luka@gmail.com"
        
        //when
        authMock.expectation = expectation(description: #function)

        sut.updateEmail(email: email)
        
        //then
        
        waitForExpectations(timeout: 5)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertEqual(sut.alertItem, AlertContext.succesfulEmailUpdate)
        
    }
    
    func test_updateEmail_onInvalidEmail_setsInvalidRecipientEmail() {
        //given
        let email = "invalid@gmail.com"
        
        authMock.error = NSError (
            domain: "FIRAuthErrorDomain",
            code: AuthErrorCode.invalidRecipientEmail.rawValue,
            userInfo: nil
        )
        
        authMock.expectation = expectation(description: #function)
        //when
        
        sut.updateEmail(email: email)
        
        //then
        
        waitForExpectations(timeout: 2)
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertEqual(sut.alertItem, AlertContext.invalidRecipientEmail)
    }
    
    private func createDBUser() -> DBUser {
        return .init(userId: UUID().uuidString, email: "ope@gmail.com",
                     photoURL: "https/fkamfa", displayName: "Luka",
                     dateCreated: Date(), biography: "biography",
                     preferences: ["Movies", "Books"], languages: ["Serbian", "English"],
                     obsessed: nil, location: "Belgrade, Serbia",
                     work: "Unemployed", pets: nil , interests: [.init(id: UUID(), icon: "book", name: "Books")])
    }
    
    func test_updateUserBiography_updatesBiography() {
        //given
        let bio = "Updated biography"
        
        sut.user = createDBUser()
        
        userManagerMock.dbUser = createDBUser()
        
        userManagerMock.expectation = expectation(description: #function)
        
        //when
        
        sut.updateUserBiography(bio: bio)
        
        waitForExpectations(timeout: 5)
        
        //then
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertNotNil(sut.user)
        XCTAssertEqual(sut.alertItem, AlertContext.updateUserBioSucessfull)
    }
    
    func test_updateUserBiography_throwsError() {
        //given
        let bio = "Updated biography"
        sut.user = createDBUser()
        userManagerMock.dbUser = createDBUser()
        userManagerMock.error = UserError.cantUpdateUser
        
        userManagerMock.expectation = expectation(description: #function)
        //when
        
        sut.updateUserBiography(bio: bio)
        
        //then
        
        waitForExpectations(timeout: 2)
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertEqual(sut.alertItem, AlertContext.updateUserBioError)
    }

    
    func test_updateUserBiography_shouldLoadUserData() {
        //given
        let bio = "Updated bio"
        
        sut.user = createDBUser()
        userManagerMock.dbUser = createDBUser()
        
        userManagerMock.expectation = expectation(description: #function)
        
        //when
        
        sut.updateUserBiography(bio: bio)
        
        waitForExpectations(timeout: 2)
        
        //then
        
        XCTAssertNotNil(sut.userInfoList)
        XCTAssertEqual(sut.userInfoList.count, 4)
        XCTAssertNotNil(sut.userEditProfileList)
        XCTAssertEqual(sut.userEditProfileList.count, 6)
    }
    
    private func createEmptyDBUser() -> DBUser {
        return .init(userId: UUID().uuidString, email: "foo@gmail.com", photoURL: nil, displayName: nil, dateCreated: nil, biography: nil, preferences: nil, languages: nil, obsessed: nil, location: nil, work: nil, pets: nil, interests: nil)
    }
    
    func test_updateUserBiography_onEmptyDBUser_emptyUserInfoList() {
        //given
        let bio = "random bio"
        sut.user = createEmptyDBUser()
        userManagerMock.dbUser = createEmptyDBUser()
        userManagerMock.expectation = expectation(description: #function)
        
        //when
        sut.updateUserBiography(bio: bio)
        
        //then
        waitForExpectations(timeout: 2)
        
        XCTAssertTrue(sut.userInfoList.isEmpty)
        XCTAssertEqual(sut.userInfoList.count, 0)
        XCTAssertNotNil(sut.userEditProfileList)
        XCTAssertEqual(sut.userEditProfileList.count, 6)
    }
    
    
}

