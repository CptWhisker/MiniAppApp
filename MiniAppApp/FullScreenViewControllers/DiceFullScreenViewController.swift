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
    private var diceType: DiceType
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
        label.text = "Roll result:"
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    private lazy var diceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Roll \(diceType.description)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(rollDice), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    init(diceType: DiceType) {
        self.diceType = diceType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullScreenLayout = DiceFullScreenLayout(height: view.bounds.height)
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        setupSubViews()
        setupConstraints()
    }
    
    private func setupSubViews() {
        view.addSubview(diceLabel)
        view.addSubview(diceButton)
    }
    
    private func setupConstraints() {
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
    
    private func configureNavigationBar() {
        navigationItem.title = "Dice"
        let backButtonImage = UIImage(named: "arrowBackward")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(dismissViewController))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Actions
    @objc private func rollDice() {
        let diceRoll = Int.random(in: 1...diceType.rawValue)
        diceLabel.text = "Roll result: \(diceRoll)"
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
