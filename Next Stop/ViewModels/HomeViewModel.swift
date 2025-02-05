import Foundation

@MainActor
class HomeViewModel : ObservableObject {
    @Published var destinations : [Destination] = []
    @Published var hotels : [Hotel] = []
    @Published var selectedDestination : Destination? = nil
    
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
                
                DispatchQueue.main.async {
                    self.destinations = destinationsWithAddedQuery
                }
            }catch{
                throw error
            }
        }
    }
    
    func getHotels(){

        guard let destination = selectedDestination else { return }

        Task{
            do{
                let fetchedHotels = try await hotelsService.fetchHotels(for: destination)
                DispatchQueue.main.async {
                    self.hotels  = fetchedHotels
                }
            }catch{
                throw error
            }
        }
    }
    
    func selectDestination(for query: String) {
        if let selectedDest = destinations.first(where: { $0.query?.lowercased() == query.lowercased() }) {
            self.selectedDestination = selectedDest
            self.getHotels()
        } else {
            print("Destination not found for query: \(query)")
        }
    }
}
