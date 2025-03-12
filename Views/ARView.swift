//
//  ARView.swift
//  TripOTap
//
//  Created by Rizwan Sultan on 11/03/2025.
//


import UIKit

/// ARView handles the UI components such as distance label and back button
class ARView: UIView {
    
    // MARK: - UI Elements
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(distanceLabel)
        addSubview(backButton)
        distanceLabel.bringSubviewToFront(self)
        backButton.bringSubviewToFront(self)
        // Constraints
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            distanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            distanceLabel.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
