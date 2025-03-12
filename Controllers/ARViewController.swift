//
//  ARViewController 2.swift
//  TripOTap
//
//  Created by Rizwan Sultan on 11/03/2025.
//


import UIKit
import ARKit
import SceneKit
import CoreLocation

/// ARViewController handles AR scene rendering, user location tracking, and navigation.
class ARViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    var sceneView: ARSCNView!
    var arView: ARView!
    var objectLocation = CLLocation()
    var locationManager = CLLocationManager()
    var userLocation: CLLocation?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        setupLocationManager()
        setupARView()
        setupCustomView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        sceneView.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        runARConfiguration()
        
    }
    
    // MARK: - Setup Methods
    /// Configures AR SceneView
    func setupARView() {
        sceneView = ARSCNView(frame: view.frame)
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        
       

    }
    
    /// Runs ARWorldTrackingConfiguration for AR session
    func runARConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    /// Configures and starts location services
//    func setupLocationManager() {
//        locationManager.delegate = self
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestAlwaysAuthorization()
//            locationManager.allowsBackgroundLocationUpdates = true
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//        } else {
//            print("Location services are not enabled.")
//        }
//        objectLocation = locationManager.location ?? CLLocation()
//    }

    func setupLocationManager() {
        locationManager.delegate = self
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager.requestAlwaysAuthorization()
                    self.locationManager.allowsBackgroundLocationUpdates = true
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    self.locationManager.startUpdatingLocation()
                }
            } else {
                DispatchQueue.main.async {
                    print("Location services are not enabled.")
                }
            }
            self.objectLocation = self.locationManager.location ?? CLLocation()
        }
    }

    
    /// Adds the ARView containing UI components
    func setupCustomView() {
        arView = ARView(frame: view.bounds)
        view.addSubview(arView)
        view.bringSubviewToFront(arView)

        // Add action for back button
        arView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }

    // MARK: - AR Interaction Methods
    /// Handles tap gesture to interact with AR objects
//    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
//        let location = gesture.location(in: sceneView)
//        let hitResults = sceneView.hitTest(location, options: nil)
//        
//        if let node = hitResults.first?.node, node.name == "ARObject" {
//            animateAndRemove(node: node)
//        }
//    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)

        if let node = hitResults.first?.node {
            print("Tapped on node: \(node.name ?? "Unnamed")")
            animateAndRemove(node: node)
        } else {
            print("No AR object tapped")
        }
    }
    
    /// Animates and removes an AR object
    func animateAndRemove(node: SCNNode) {
        let scaleAction = SCNAction.scale(to: 0.1, duration: 0.5)
        let fadeAction = SCNAction.fadeOut(duration: 0.5)
        let groupAction = SCNAction.group([scaleAction, fadeAction])
        
        node.runAction(groupAction) {
            node.removeFromParentNode()
        }
    }

    // MARK: - Location Manager Delegate
    /// Updates user location and calculates distance to the object
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        userLocation = latestLocation
        
        let distance = latestLocation.distance(from: objectLocation)
        arView.distanceLabel.text = String(format: "Distance: %.2f meters", distance)
        
        print("User location updated: \(latestLocation.coordinate), Distance: \(distance)")
        
        addNavigationArrow(userLocation: latestLocation, objectLocation: objectLocation)
        placeObject()
    }

    // MARK: - AR Object Placement
    /// Places an AR object at a predefined location
    func placeObject() {
        let scene = sceneView.scene
        scene.rootNode.childNode(withName: "ARObject", recursively: true)?.removeFromParentNode()
        
        let sphereGeometry = SCNSphere(radius: 0.1)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        let objectNode = SCNNode(geometry: sphereGeometry)
        objectNode.name = "ARObject"
        objectNode.position = SCNVector3(0, 0, -1)
        
        scene.rootNode.addChildNode(objectNode)
    }

    // MARK: - Navigation
    /// Handles navigation back to the previous screen
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    /// Adds a navigation arrow pointing towards the AR object
    func addNavigationArrow(userLocation: CLLocation, objectLocation: CLLocation) {
        let scene = sceneView.scene
        scene.rootNode.childNode(withName: "NavigationArrow", recursively: true)?.removeFromParentNode()
        
        let arrowGeometry = SCNCylinder(radius: 0.05, height: 0.3)
        arrowGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let arrowNode = SCNNode(geometry: arrowGeometry)
        arrowNode.name = "NavigationArrow"
        arrowNode.position = SCNVector3(0, 0, -1)

        let coneGeometry = SCNCone(topRadius: 0, bottomRadius: 0.1, height: 0.2)
        coneGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let coneNode = SCNNode(geometry: coneGeometry)
        coneNode.position = SCNVector3(0, 0.25, 0)
        
        arrowNode.addChildNode(coneNode)
        scene.rootNode.addChildNode(arrowNode)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
