import XCTest
@testable import Next_Stop
import SwiftUI
import Combine

@MainActor
final class ProfileViewModel_Tests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func getSut() -> ProfileViewModel {
        let authManager = MockAuthenticationManager()
        let userManager = MockUserManager()
        return ProfileViewModel(authManager: authManager, userManager: userManager)
    }

    func test_init_doesSetValuesCorrectly() {
        let sut = getSut()

        XCTAssertTrue(sut.authManager is MockAuthenticationManager)
        XCTAssertTrue(sut.userManager is MockUserManager)
    }

    func test_getAuthenticatedUser_shouldLoadCurrentUser() {
        let sut = getSut()
        
        let expectation = expectation(description: "Should load current user")
        
        Task{
            try? await sut.getAuthenticatedUser()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(sut.user)
        XCTAssertEqual(sut.user?.userId, "HBFAJN1841N8TNFSOnfjn9Fn")
    }
    
    
    
}
