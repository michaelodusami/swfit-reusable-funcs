import SwiftUI
import MapKit
import CoreLocation

// MARK: - LocationManager

/// A class that wraps CLLocationManager to publish location updates and authorization status.
public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published public var currentLocation: CLLocation?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    public override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Request permission (update as needed for your use-case)
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    /// Starts location updates.
    public func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    /// Stops location updates.
    public func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - MapView Representable

/// A SwiftUI view wrapping an MKMapView.
public struct MapView: UIViewRepresentable {
    @Binding public var centerCoordinate: CLLocationCoordinate2D
    public var annotations: [MKAnnotation] = []
    public var showsUserLocation: Bool = true
    
    public init(centerCoordinate: Binding<CLLocationCoordinate2D>,
                annotations: [MKAnnotation] = [],
                showsUserLocation: Bool = true) {
        self._centerCoordinate = centerCoordinate
        self.annotations = annotations
        self.showsUserLocation = showsUserLocation
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = showsUserLocation
        return mapView
    }
    
    public func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the region based on centerCoordinate
        let region = MKCoordinateRegion(center: centerCoordinate,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        uiView.setRegion(region, animated: true)
        
        // Update annotations
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
    }
    
    public class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}

// MARK: - Route Calculation

/// A manager that computes routes between two coordinates.
public class RouteManager: ObservableObject {
    @Published public var route: MKRoute?
    
    /// Calculates a route (automobile transport) between source and destination.
    public func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                DispatchQueue.main.async {
                    self.route = route
                }
            }
        }
    }
}

// MARK: - Helper Extensions

public extension CLLocationCoordinate2D {
    /// Returns the distance (in meters) to another coordinate using the haversine formula.
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let earthRadius: CLLocationDistance = 6371000 // in meters
        
        let dLat = (coordinate.latitude - self.latitude) * .pi / 180
        let dLon = (coordinate.longitude - self.longitude) * .pi / 180
        
        let lat1 = self.latitude * .pi / 180
        let lat2 = coordinate.latitude * .pi / 180
        
        let a = sin(dLat / 2) * sin(dLat / 2) +
                sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return earthRadius * c
    }
}

// MARK: - Geocoding Functions

/// A manager to perform geocoding and reverse geocoding.
public class GeocoderManager: ObservableObject {
    private let geocoder = CLGeocoder()
    
    @Published public var placemark: CLPlacemark?
    
    public init() {}
    
    /// Reverse geocode a coordinate to obtain an address.
    public func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let first = placemarks?.first {
                DispatchQueue.main.async {
                    self.placemark = first
                }
            }
        }
    }
    
    /// Geocode an address string to retrieve a coordinate.
    public func geocode(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let first = placemarks?.first, let location = first.location {
                DispatchQueue.main.async {
                    completion(location.coordinate)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
