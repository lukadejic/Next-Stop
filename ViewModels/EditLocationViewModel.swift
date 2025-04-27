import MapKit

class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchText = "" {
        didSet {
            updateSearchResults()
        }
    }
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var selectedLocation: String?
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    func updateSearchResults() {
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchCompleter.queryFragment = searchText
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async { [weak self] in
            self?.searchResults = completer.results
        }
    }
    
    func selectLocation(_ location: String) {
        selectedLocation = location
        searchText = location
        searchResults = []
    }
}
