import Foundation

@MainActor
class HomeViewModel : ObservableObject {
    @Published var destinations : [Destination] = []
    
    private let destinationService : DestinationsService
    
    init(destinationService: DestinationsService) {
        self.destinationService = destinationService
    }
    
    func getDestinations(query: String) {
        Task{
            do{
                let fetchedDestinations = try await destinationService.fetchDestinations(query: query)
                DispatchQueue.main.async {
                    self.destinations = fetchedDestinations
                }
            }catch{
                throw error
            }
        }
    }
    
}
