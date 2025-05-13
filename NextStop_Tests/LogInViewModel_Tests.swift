import Foundation
import XCTest
@testable
import Next_Stop
@testable
import FirebaseAuth

@MainActor
final class LogInViewModel_Tests: XCTestCase {
    private(set) var sut: LogInViewModel!
    private(set) var authMock: MockAuthenticationManager!
    private(set) var userManagerMock: MockUserManager!
    
    override func setUp() {
        super.setUp()
        authMock = MockAuthenticationManager()
        userManagerMock = MockUserManager()
        sut = LogInViewModel(authManager: authMock, userManager: userManagerMock)
    }
    
    override func tearDown() {
        super.tearDown()
        authMock = nil
        userManagerMock = nil
        sut = nil
    }

    func test_signIn_signesIn() {
        //given
        sut.email = "lukadejic111@gmail.com"
        sut.password = "Password031.!"
        
        authMock.user = .init(uid: UUID().uuidString, email: "lukadejic111@gmail.com",
                                     photoURL: nil, displayName: nil)
        
        authMock.expectation = expectation(description: #function)
        //when
        
        sut.signIn()
        
        waitForExpectations(timeout: 5)
        //then
        
        XCTAssertTrue(sut.succesful)
    }
    
    func test_signIn_onInvalidCredential_setsUserNotFoundAlert() {
        //given
        sut.email = "lukadejic111@gmail.com"
        sut.password = "Password031.!"
        
        authMock.error = NSError (
            domain: "FIRAuthErrorDomain",
            code: AuthErrorCode.invalidCredential.rawValue,
            userInfo: nil
        )
        
        authMock.expectation = expectation(description: #function)
        
        //when
        
        sut.signIn()
        
        waitForExpectations(timeout: 2)
        //then
        
        XCTAssertFalse(sut.succesful)
        XCTAssertEqual(sut.alertItem, AlertContext.userNotFound)
        
    }
    
    func test_signIn_onDefaultError_setsDefaultError() {
        //given
        sut.email = "lukadejic111@gmail.com"
        sut.password = "Password031.!"
        
        authMock.error = NSError (
            domain: "SomeRandomDomain",
            code: 17011,
            userInfo: nil
        )
        
        authMock.expectation = expectation(description: #function)
        
        //when
        
        sut.signIn()
        
        waitForExpectations(timeout: 2)
        
        //then
        
        XCTAssertFalse(sut.succesful)
        XCTAssertEqual(sut.alertItem, AlertContext.defaultError)
    }
    
    func test_signIn_onEmptyFields_setsEmptyFieldAlert() {
        //given
        sut.email = ""
        sut.password = ""
        //when
        
        sut.signIn()
        
        //then
        
        XCTAssertFalse(sut.succesful)
        XCTAssertEqual(sut.alertItem, AlertContext.emptyFields)
    }
    
    func test_signIn_onWeakPassword_setsWeakPasswordAlert() {
        //given
        sut.email = "lukadejic111@gmail.com"
        sut.password = "password"
        
        //when
        
        sut.signIn()
        
        //then
        
        XCTAssertFalse(sut.succesful)
        XCTAssertEqual(sut.alertItem, AlertContext.weakPassword)
        
    }
    func test_signIn_onInvalidEmail_setsInvalidEmailAlert() {
        //given
        sut.email = "luka@kk"
        sut.password = "Password031.!"
        
        //when
        
        sut.signIn()
        
        //then
        
        XCTAssertFalse(sut.succesful)
        XCTAssertEqual(sut.alertItem, AlertContext.invalidEmail)
    }
}
