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

    func test_init_doesSetValuesCorrectly() {
        //Given
        let authManager = MockAuthenticationManager()
        let userManager = MockUserManager()
        
        //When
        let vm = ProfileViewModel(authManager: authManager, userManager: userManager)
        
        //Then
        XCTAssertTrue(vm.authManager as AnyObject === authManager)
        XCTAssertTrue(vm.userManager as AnyObject === userManager)
    }

    func test_getAuthenticatedUser_shouldLoadCurrentUser() {
        //Given
        let authManager = MockAuthenticationManager()
        let userManager = MockUserManager()
        let SUT = ProfileViewModel(authManager: authManager, userManager: userManager)
        
        //When
        
        let expectation = expectation(description: "Should load current user")
        var isExpectationFulfilled = false
        
        SUT.$user
            .dropFirst()
            .sink { user in
                if user != nil && !isExpectationFulfilled {
                    expectation.fulfill()
                    isExpectationFulfilled = true
                }
            }
            .store(in: &cancellables)
        
        SUT.getAuthenticatedUser()
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(SUT.user)
        XCTAssertEqual(SUT.user?.userId, "HBFAJN1841N8TNFSOnfjn9Fn")
    }
    
}
