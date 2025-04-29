import SwiftUI
import MapKit

struct FullMapView: View {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let annotationName: String
    
    @State private var isShowingLookAround = false
    @State private var lookAroundScene : MKLookAroundScene?
    @State private var route: MKRoute?
    @State private var selectedLocation : CLLocationCoordinate2D?
    @State private var mapSelection : MKMapItem?
    @State private var showLocationDetails = false
    @State private var getDirections : Bool = false
    @State private var cameraPositon: MapCameraPosition
    @State private var routeDestination : MKMapItem?
    @State private var routeDisplaying : Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, annotationName: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.annotationName = annotationName
        
        _cameraPositon = State(initialValue: .region(.init(center: .init(latitude: latitude, longitude: longitude), latitudinalMeters: 10000, longitudinalMeters: 10000)))
    }
    var body: some View {
        VStack{
            MapReader{ reader in
                Map(initialPosition: cameraPositon, selection: $mapSelection) {
                    Annotation(annotationName, coordinate: .init(latitude: latitude, longitude: longitude)) {
                        Image(systemName: "mappin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(7)
                            .background(.red.gradient, in: .circle)
                            .foregroundStyle(.white)
                    }
                    
                    if let selectedLocation {
                        Annotation("", coordinate: selectedLocation) {
                            Image(systemName: "mappin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(7)
                                .background(.red.gradient, in: .circle)
                                .foregroundStyle(.white)
                                .contextMenu {
                                    Button("Look Around", systemImage: "binoculars") {
                                        Task {
                                            lookAroundScene = await getLookAroundSceen(from: .panamaPark)
                                            isShowingLookAround = true
                                        }
                                    }
                                    
                                    Button("Get Directions", systemImage: "arror.turn.down.right") {
                                        
                                    }
                                }
                        }
                        
                    }
                    
                    if let route,routeDisplaying {
                        MapPolyline(route.polyline)
                            .stroke(Color.blue,lineWidth: 5)
                    }
                }
                .onTapGesture { screenCoordinate in
                    Task {
                        let newLocation = reader.convert(screenCoordinate, from: .global)
                        
                        guard let validLocation = newLocation else {
                            return
                        }
                        
                        selectedLocation = validLocation
                        
                        reverseGeocode(location: validLocation) { mapItem in
                            mapSelection = mapItem
                            showLocationDetails = (mapItem != nil)
                        }
                        routeDisplaying = false
                    }
                }
                .mapControls {
                    MapCompass()
                    MapPitchToggle()
                    MapScaleView()
                }
                .onChange(of: getDirections, { oldValue, newValue in
                    if newValue {
                        fetchRoute()
                    }
                })
                .mapStyle(.standard(elevation: .realistic))
                .lookAroundViewer(isPresented: $isShowingLookAround, scene: $lookAroundScene)
                .sheet(isPresented: $showLocationDetails) {
                    LocationDetailsView(mapSelection: $mapSelection,
                                        show: $showLocationDetails,
                                        getDirections: $getDirections)
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
                }
            }
        }
        .overlay(alignment: .topTrailing){
            Button{
                dismiss()
            }label: {
                Image(systemName: "xmark")
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.black)
                    .background(in: Circle())
                    .shadow(radius: 7)
            }
            .padding()
        }
    }
}
#Preview {
    FullMapView(latitude: 37.347730, longitude: -122.018715, annotationName: "Panama Park")
}

private extension FullMapView {
    
    func getLookAroundSceen(from coordinate: CLLocationCoordinate2D) async -> MKLookAroundScene? {
        do{
            return try await MKLookAroundSceneRequest(coordinate: coordinate).scene
        }catch{
            print("Cannot retrive Look Around Scene: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .init(latitude: latitude, longitude: longitude)))
            request.destination = mapSelection
            
            Task{
                do{
                    let result = try await MKDirections(request: request).calculate()
                    route = result.routes.first
                    routeDestination = mapSelection
                    
                    withAnimation(.snappy){
                        routeDisplaying = true
                        showLocationDetails = false
                    }
                    
                    if let rect = route?.polyline.boundingMapRect {
                        cameraPositon = .rect(rect)
                    }
                }catch{
                    print("Failed to fetch route: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func reverseGeocode(location: CLLocationCoordinate2D, completion: @escaping (MKMapItem?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                print("Reverse geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let mkPlacemark = MKPlacemark(placemark: placemark)
            let mapItem = MKMapItem(placemark: mkPlacemark)
            completion(mapItem)
        }
    }

}
