//
//  DiceFullScreenViewController.swift
//  MiniAppApp
//
//  Created by user on 08.09.2024.
//

import UIKit

// MARK: - DiceFullScreenLayout
struct DiceFullScreenLayout {
    let height: CGFloat
    
    var diceLabelYPosition: CGFloat { return -(height / 8) }
    var diceLabelWidthMultiplier: CGFloat { return 0.5 }
    var diceLabelHeightMultiplier: CGFloat { return 0.2 }
    
    var diceButtonYPosition: CGFloat { return (height / 8)}
}

final class DiceFullScreenViewController: UIViewController {
    // MARK: - Properties
    private var fullScreenLayout: DiceFullScreenLayout?
    
    // MARK: - UI Elements
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var diceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    private lazy var diceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Roll D6", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(rollDice), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(diceLabel)
        view.addSubview(diceButton)
        
        fullScreenLayout = DiceFullScreenLayout(height: view.bounds.height)
        
        if let fullScreenLayout {
            NSLayoutConstraint.activate([
                diceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                diceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: fullScreenLayout.diceLabelYPosition),
                diceLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: fullScreenLayout.diceLabelWidthMultiplier),
                diceLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: fullScreenLayout.diceLabelHeightMultiplier),
                
                diceButton.centerXAnchor.constraint(equalTo: diceLabel.centerXAnchor),
                diceButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: fullScreenLayout.diceButtonYPosition),
                diceButton.widthAnchor.constraint(equalTo: diceLabel.widthAnchor),
                diceButton.heightAnchor.constraint(equalTo: diceLabel.heightAnchor)
            ])
        }
    }
    
    // MARK: - Actions
    @objc private func rollDice() {
        let diceRoll = Int.random(in: 1...6)
        diceLabel.text = "Roll result: \(diceRoll)"
    }
}
