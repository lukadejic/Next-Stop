import Foundation
import SwiftUI
import SwiftData

@MainActor
class HomeViewModel : ObservableObject {
    @Published var destinations : [Destination] = []
    @Published var hotels : [Hotel] = []
    @Published var selectedDestination: Destination? {
        didSet {
            if oldValue?.id != selectedDestination?.id {
                fetchHotelsIfNeeded()
            }
        }
    }

    @Published var hotelImages : [Int : [ImageModel]] = [:]
    @Published var hotelDetail : HotelDetailData? = nil
    @Published var hotelDescription: [HotelDescriptionData] = []
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    
    private let hotelsService : HotelsService
    
    init(hotelsService: HotelsService) {
        self.hotelsService = hotelsService
    }
    
    func getDestinations(query: String) {
        
        Task{
            do{
                let fetchedDestinations = try await hotelsService.fetchDestinations(query: query)
                
                let destinationsWithAddedQuery = fetchedDestinations.map { destination in
                    var destinationWithQuery = destination
                    destinationWithQuery.query = query
                    return destinationWithQuery
                }
                
                self.destinations = destinationsWithAddedQuery
                
            }catch{
                throw error
            }
        }
    }
    
    func getHotels(){

        guard let destination = selectedDestination else {
            print("No selected destination, cannot fetch hotels")
            return
        }

        Task{
            do{
                
                let hotels = try await hotelsService.fetchHotels(for: destination)
                print("Fetched hotels count: \(hotels.count)")
                
                DispatchQueue.main.async {
                    self.hotels = hotels
                    print("Updated hotels count: \(self.hotels.count)")
                }
            }catch{
                print("Error while fetching hotels: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func selectDestination(for query: String) {
        if let selectedDest = destinations.first(where: { $0.query?.lowercased() == query.lowercased() }) {
            if selectedDestination?.id != selectedDest.id { // Proveri da li je već ista
                self.selectedDestination = selectedDest
                self.getHotels()
                print("Hotels count after fetching: \(self.hotels.count)")
            }
        } else {
            print("Destination not found for query: \(query)")
        }
    }
    
    func getHotelImages(hotelID: Int) {
        if hotelImages[hotelID] != nil { return }
        
        print("fetching the hotel images...")
        Task{
            do{
                let images = try await hotelsService.fetchHotelImages(hotelID: hotelID)
                print("fetched images count : \(images.count)")
                
                self.hotelImages[hotelID] = images
                
            }catch{
                print("Error while fetching the images for hotelID: \(hotelID) : \(error.localizedDescription)" )
            }
        }
    }
    
    func getHotelDetails(hotelId : Int) {
        Task{
            do{
                let hotelDetails = try await hotelsService.fetchHotelDetails(hotelId: hotelId)
                
                self.hotelDetail = hotelDetails
                
                print("succesfully fetched the details for the hotel")
            }catch{
                print("error while fetching hotel details : \(error.localizedDescription)")
            }
        }
    }
    
    func getHotelDescription(hotelId: Int) {
        Task{
            do{
                guard let hotelDescriptions = try await hotelsService.fetchHotelDescription(hotelId: hotelId) else { return }
                
                self.hotelDescription = hotelDescriptions
                
            }catch{
                print("Failed to fetch hotel description data: \(error.localizedDescription)")
            }
        }
    }
    private func fetchHotelsIfNeeded() {
        guard let destination = selectedDestination, hotels.isEmpty else { return }
        print(destination)
        getHotels()
    }
    
    func saveAvailibilyDate(startDate: Date? , endDate: Date?) {
        guard let startDate = startDate, let endDate = endDate else { return }
        self.startDate = startDate
        self.endDate = endDate
    }

}
