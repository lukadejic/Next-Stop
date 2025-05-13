import Foundation
@testable
import Next_Stop
import XCTest

@MainActor
final class HomeViewModel_Tests: XCTestCase {
    private(set) var sut: HomeViewModel!
    private(set) var hotelsServiceMock: HotelsServiceMock!
    
    override func setUp () {
        super.setUp()
        hotelsServiceMock = HotelsServiceMock()
        sut = HomeViewModel(hotelsService: hotelsServiceMock)
    }
    
    override func tearDown() {
        super.tearDown()
        hotelsServiceMock = nil
        sut = nil
    }
    
    func test_getDestinations_getsDestinations() {
        //given
        let query = "lake"
        hotelsServiceMock.destinations = createDestinations()
        hotelsServiceMock.expectation = expectation(description: #function)
        
        //when
        sut.getDestinations(query: query)
        
        waitForExpectations(timeout: 2)
        //then
        
        XCTAssertFalse(sut.destinations.isEmpty)
        XCTAssertTrue(sut.destinations.count > 0)
    }

    func test_getDestinations_throwsError() {
        //given
        let query = "lake"
        hotelsServiceMock.error = NetworkErrors.cantGetDestinations
        hotelsServiceMock.expectation = expectation(description: #function)
        
        //when
        sut.getDestinations(query: query)
        
        //then
        waitForExpectations(timeout: 2)
        XCTAssertTrue(sut.destinations.isEmpty)
    }
    
    func test_getHotels_getsHotels() {
        //given
        sut.selectedDestination = createDestinations().first
        hotelsServiceMock.hotels = createHotels()
        hotelsServiceMock.expectation = expectation(description: #function)
        
        //when
        sut.getHotels()
        
        //then
        waitForExpectations(timeout: 2)
        XCTAssertFalse(sut.hotels.isEmpty)
        XCTAssertTrue(sut.hotels.count > 0)
    }
    
    func test_getHotels_throwsError() {
        //given
        sut.selectedDestination = createDestinations().first
        hotelsServiceMock.error = NetworkErrors.cantGetHotels
        hotelsServiceMock.expectation = expectation(description: #function)
        
        //when
        sut.getHotels()
        
        //then
        waitForExpectations(timeout: 2)
        
        XCTAssertTrue(sut.hotels.isEmpty)
        XCTAssertTrue(sut.hotels.count == 0)
    }
    
    func test_getHotels_onUnselectedDestination_returns() {
        //given
        hotelsServiceMock.hotels = createHotels()
        
        //when
        sut.getHotels()
        
        //then
        XCTAssertTrue(sut.hotels.isEmpty)
    }

    func test_searchHotels_fetchesHotelsWithFilters() {
        //given
        let location = "Belgrade, Serbia"
        let arrivalDate = Date()
        let departureDate = Date()
        let adults = 2
        let childrenAge = [5, 7]
        let roomQTY = 3
        hotelsServiceMock.hotels = createHotels()
        hotelsServiceMock.destinations = createDestinations()
        hotelsServiceMock.expectation = expectation(description: #function)
        
        //when
        sut.searchHotels(location: location, arrivalDate: arrivalDate, departureDate: departureDate, adults: adults, childredAge: childrenAge, roomQty: roomQTY)
        
        //then
        waitForExpectations(timeout: 2)
        
        XCTAssertFalse(sut.hotels.isEmpty)
        XCTAssertTrue(sut.hotels.count > 0)
        XCTAssertTrue(sut.isLoading == false)
    }
    
    func test_searchHotels_onEmptyDestination_throwsError() {
        //given
        let location = "Belgrade, Serbia"
        let adults = 2
        let childrenAge = [5, 7]
        let roomQTY = 3
        hotelsServiceMock.hotels = createHotels()
        hotelsServiceMock.error = NetworkErrors.cantSearchHotels
        hotelsServiceMock.expectation = expectation(description: #function)
        
        //when
        sut.searchHotels(location: location, arrivalDate: nil, departureDate: nil, adults: adults, childredAge: childrenAge, roomQty: roomQTY)
        
        waitForExpectations(timeout: 2)
        //then
        XCTAssertTrue(sut.hotels.isEmpty)
        XCTAssertTrue(sut.hotels.count == 0)
    }
    
    func test_searchHotels_throwsError() {
        //given
        let location = "Belgrade, Serbia"
        let adults = 2
        let childrenAge = [5, 7]
        let roomQTY = 3
        hotelsServiceMock.destinations = createDestinations()
        hotelsServiceMock.error = NetworkErrors.cantSearchHotels
        hotelsServiceMock.expectation = expectation(description: #function)
        
        //when
        sut.searchHotels(location: location, arrivalDate: nil, departureDate: nil, adults: adults, childredAge: childrenAge, roomQty: roomQTY)
        
        //then
        waitForExpectations(timeout: 2)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.hotels.isEmpty)
        XCTAssertTrue(sut.hotels.count == 0)
    }
    
    func test_getHotelImages_getsImages() {
        //given
        let hotelId = 123
        hotelsServiceMock.hotelImages = [.init(id: 1, url: "url1.com"),
                                         .init(id: 2, url: "url2.com")]
        hotelsServiceMock.expectation = expectation(description: #function)
        //when
        sut.getHotelImages(hotelID: hotelId)
        
        //when
        waitForExpectations(timeout: 2)
        XCTAssertFalse(sut.hotelImages.isEmpty)
    }
    
    func test_getHotelImages_throwsError() {
        //given
        let hotelId = 123
        hotelsServiceMock.error = NetworkErrors.cantGetImage
        hotelsServiceMock.expectation = expectation(description: #function)
        
        //when
        sut.getHotelImages(hotelID: hotelId)
        
        //then
        waitForExpectations(timeout: 2)
        XCTAssertTrue(sut.hotelImages.isEmpty)
    }
    
    
    private func createDestinations() -> [Destination] {
        return [
            .init(destType: "lake", cc1: nil, cityName: nil, label: nil, longitude: nil, latitude: nil, type: nil, region: nil, cityUfi: nil, name: nil, roundtrip: nil, country: nil, imageurl: nil, destid: nil, nrHotels: nil, lc: nil, hotels: nil,query: "lake"),
            
            .init(destType: "beahc", cc1: nil, cityName: nil, label: nil, longitude: nil, latitude: nil, type: nil, region: nil, cityUfi: nil, name: nil, roundtrip: nil, country: nil, imageurl: nil, destid: nil, nrHotels: nil, lc: nil, hotels: nil, query: "lake")
        ]
    }
    
    private func createHotels() -> [Hotel] {
        return [
            .init(hotelID: 123, accessibilityLabel: nil, property: nil),
            .init(hotelID: 124, accessibilityLabel: nil, property: nil)
        ]
    }
    
}

