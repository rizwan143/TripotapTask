//
//  ViewController.swift
//  TripOTap
//
//  Created by Rizwan Sultan on 10/03/2025.
//

import UIKit
import GoogleMaps
import CoreLocation

// MARK: - MapViewController
class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // MARK: - Properties
    private var locationManager = CLLocationManager()
    private var mapViewContainer: MapView!
    private var objectLocation = CLLocation(latitude: 30.671763221328565, longitude: 73.12964554230939)
    private var notificationTimer: Timer?
    private var hasSentNotification = false
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupMapView()
    }
    
    // MARK: - Setup Methods
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            objectLocation = locationManager.location!
        } else {
            showAlert(title: "Tripotap", message: "Please enable your location from settings")
        }
    }
    
    private func setupMapView() {
        mapViewContainer = MapView(frame: view.bounds)
        view.addSubview(mapViewContainer)
        
        mapViewContainer.mapView.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 15)
        mapViewContainer.mapView.camera = camera
        mapViewContainer.switchToARButton.addTarget(self, action: #selector(switchToAR), for: .touchUpInside)
    }
    
    // MARK: - Location Handling
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: mapViewContainer.mapView.camera.zoom)
        mapViewContainer.mapView.animate(to: camera)
        
        let distance = userLocation.distance(from: objectLocation)
        mapViewContainer.distanceLabel.text = String(format: "Distance: %.2f meters", distance)
        
        let marker = GMSMarker(position: objectLocation.coordinate)
        marker.icon = UIImage(systemName: "car")?.withTintColor(.blue)
        marker.map = mapViewContainer.mapView
        
        checkProximity(userLocation: userLocation, objectLocation: objectLocation)
    }
    
    func checkProximity(userLocation: CLLocation, objectLocation: CLLocation) {
        let distance = userLocation.distance(from: objectLocation)
        if distance < 50, !hasSentNotification {
            sendNotification()
            hasSentNotification = true
            notificationTimer?.invalidate()
            notificationTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { [weak self] _ in
                self?.hasSentNotification = false
            }
        }
    }
    
    // MARK: - Notifications
    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "You're Close!"
        content.body = "You're within 50 meters of the AR object."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "ProximityNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // MARK: - Navigation
    @objc private func switchToAR() {
        let arViewController = ARViewController()
        arViewController.objectLocation = objectLocation
        navigationController?.pushViewController(arViewController, animated: true)
    }
    
    // MARK: - Alerts
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
