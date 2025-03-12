//
//  MapView.swift
//  TripOTap
//
//  Created by Rizwan Sultan on 11/03/2025.
//

import UIKit
import GoogleMaps

class MapView: UIView {
    
    var mapView: GMSMapView!
    var distanceLabel: UILabel!
    var switchToARButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMap()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMap()
        setupUI()
    }
    
    private func setupMap() {
        mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isMyLocationEnabled = true
        addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupUI() {
        // Distance Label
        distanceLabel = UILabel()
        distanceLabel.text = "Distance: -- meters"
        distanceLabel.textAlignment = .center
        distanceLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        distanceLabel.layer.cornerRadius = 8
        distanceLabel.layer.masksToBounds = true
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(distanceLabel)

        // Switch to AR Button
        switchToARButton = UIButton(type: .system)
        switchToARButton.setTitle("Switch to AR", for: .normal)
        switchToARButton.backgroundColor = UIColor.systemBlue
        switchToARButton.setTitleColor(.white, for: .normal)
        switchToARButton.layer.cornerRadius = 8
        switchToARButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(switchToARButton)

        // Constraints
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            distanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            distanceLabel.heightAnchor.constraint(equalToConstant: 40),
            
            switchToARButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchToARButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            switchToARButton.widthAnchor.constraint(equalToConstant: 120),
            switchToARButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
