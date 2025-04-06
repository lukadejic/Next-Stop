import XCTest
@testable import Next_Stop
import SwiftUI

final class ProfileViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func test_ProfileViewModel_init_doesSetValuesCorrectly() {
        //Given
        let authManager = MockAuthenticationManager()
        let userManager = MockUserManager()
        
        //When
        let vm = ProfileViewModel(authManager: authManager, userManager: userManager)
        
        //Then
        XCTAssertTrue(vm.authManager as AnyObject === authManager)
        XCTAssertTrue(vm.userManager as AnyObject === userManager)
    }
    
}
