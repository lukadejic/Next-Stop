import Foundation
@testable
import Next_Stop
import XCTest

@MainActor
class HotelsServiceMock : HotelsServiceProtocol {
    
    var destinations: [Destination]? = nil
    var hotels : [Hotel]? = nil
    var error: Error? = nil
    var hotelImages: [ImageModel]? = nil
    var expectation: XCTestExpectation? = nil

    func fetchDestinations(query: String) async throws -> [Destination] {
        if let destinations {
            expectation?.fulfill()
            return destinations
        } else {
            expectation?.fulfill()
            throw error!
        }
    }
    
    func fetchHotels(for destination: Destination) async throws -> [Hotel] {
        if let hotels {
            expectation?.fulfill()
            return hotels
        } else {
            expectation?.fulfill()
            throw error!
        }
    }
    
    func fetchHotelsWithFilters(destination: Destination, location: String, arrivalDate: String?, departureDate: String?, adults: Int?, childrenAge: [Int]?, roomQty: Int?) async throws -> [Hotel] {
        if let hotels {
            DispatchQueue.main.async { [weak self] in
                self?.expectation?.fulfill()
            }
            return hotels
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.expectation?.fulfill()
            }
            throw error!
        }
    }
    
    func fetchHotelImages(hotelID: Int) async throws -> [ImageModel] {
        if let hotelImages {
            expectation?.fulfill()
            return hotelImages
        } else {
            expectation?.fulfill()
            throw error!
        }
    }
    
    func fetchHotelDetails(hotelId: Int) async throws -> HotelDetailData? {
        return nil
    }
    
    func fetchHotelDescription(hotelId: Int) async throws -> [HotelDescriptionData]? {
        return []
    }
    
}
