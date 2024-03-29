//
//  MapViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import MapKit

var routes: [MKRoute] = []
var num: Int = 0
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationPermission()
        addLongGestureRecognizer()
    }

    private var currentCoordinate: CLLocationCoordinate2D?
    private var destinationCoordinate: CLLocationCoordinate2D?

    func addLongGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleLongPressGesture(_ :)))
        self.view.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        destinationCoordinate = coordinate

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Pinned"
        mapView.addAnnotation(annotation)
    }

    func checkLocationPermission() {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.requestLocation()
        case .denied, .restricted:
            //popup gosterecegiz. go to settings butonuna basildiginda
            //kullaniciyi uygulamamizin settings sayfasina gonder
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }

    @IBAction func showCurrentLocationTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }

    @IBAction func drawRouteButtonTapped(_ sender: UIButton) {
        guard let currentCoordinate = currentCoordinate,
              let destinationCoordinate = destinationCoordinate else {
                  // log
                  // alert
            return
        }

        let sourcePlacemark = MKPlacemark(coordinate: currentCoordinate)
        let source = MKMapItem(placemark: sourcePlacemark)

        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let destination = MKMapItem(placemark: destinationPlacemark)

        let directionRequest = MKDirections.Request()
        directionRequest.source = source
        directionRequest.destination = destination
        directionRequest.transportType = .automobile
        directionRequest.requestsAlternateRoutes = true

        let direction = MKDirections(request: directionRequest)

        direction.calculate { response, error in
            guard error == nil else {
                //log error
                //show error
                print(error?.localizedDescription)
                return
            }

            if let tempRoutes = response?.routes {
                routes = tempRoutes
            }
            guard let polyline: MKPolyline = routes.first?.polyline else { return }
            
            for route in routes {
                self.mapView.addOverlay(route.polyline, level: .aboveLabels)

                let rect = route.polyline.boundingMapRect
                let region = MKCoordinateRegion(rect)
                self.mapView.setRegion(region, animated: true)
            }
            
            //Odev 1 navigate buttonlari ile diger route'lar gosterilmelidir.
        }
    }
    
    
    //This function for left button for drawing new path
    @IBAction func leftButton(_ sender: Any) {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        
        if routes.count > num && num >= 0{
            self.mapView.addOverlay(routes[num].polyline, level: .aboveLabels)
            let rect = routes[num].polyline.boundingMapRect
            let region = MKCoordinateRegion(rect)
            self.mapView.setRegion(region, animated: true)
            num = num + 1
            num = num % 3
        }
    }
    
    //This function for right button for drawing new path
    @IBAction func rightButton(_ sender: Any) {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        
        if routes.count > num  && num >= 0{
            self.mapView.addOverlay(routes[num].polyline, level: .aboveLabels)
            let rect = routes[num].polyline.boundingMapRect
            let region = MKCoordinateRegion(rect)
            self.mapView.setRegion(region, animated: true)
            num = num - 1
            print(num)
            if num == -1 {
                num = 2
            }
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        currentCoordinate = coordinate
        print("latitude: \(coordinate.latitude)")
        print("longitude: \(coordinate.longitude)")

        mapView.setCenter(coordinate, animated: true)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .magenta
        renderer.lineWidth = 8
        return renderer
    }
}
