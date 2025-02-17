class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchQuery: String = "" {
        didSet { completer.queryFragment = searchQuery }
    }
    @Published var searchResults: [MKLocalSearchCompletion] = []
    
    private let completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        // Set to the entire world by using a large region
        completer.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
        )
    }
    
    // Update search results when completer finds matches.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
    
    // Perform a local search based on the selected completion.
    func selectLocation(_ completion: MKLocalSearchCompletion,
                        completionHandler: @escaping (CLLocationCoordinate2D?) -> Void) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate,
                  error == nil else {
                print("Error searching location: \(error?.localizedDescription ?? "Unknown error")")
                completionHandler(nil)
                return
            }
            completionHandler(coordinate)
        }
    }
}

// MARK: - SwiftUI View
struct LocationSearchView: View {
    @StateObject private var searchService = LocationSearchService()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for a location", text: $searchService.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List(searchService.searchResults, id: \.self) { result in
                    Button {
                        searchService.selectLocation(result) { coordinate in
                            if let coordinate = coordinate {
                                self.selectedCoordinate = coordinate
                                // Persist or use the coordinate as needed.
                                print("Selected coordinate: \(coordinate.latitude), \(coordinate.longitude)")
                            }
                        }
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.headline)
                            Text(result.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                if let coordinate = selectedCoordinate {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Selected Location:")
                            .font(.headline)
                        Text("Latitude: \(coordinate.latitude)")
                        Text("Longitude: \(coordinate.longitude)")
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Location Search")
        }
    }
}

// MARK: - Preview
struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
