//
//  CounterFullScreenViewController.swift
//  MiniAppApp
//
//  Created by user on 08.09.2024.
//

import UIKit
struct CounterFullScreenLayout {
    let height: CGFloat
    let width: CGFloat
    let isLandscape: Bool
    
    var counterLabelYPosition: CGFloat { return -(height / 8) }
    var counterLabelWidthMultiplier: CGFloat { return 0.5 }
    var counterLabelHeightMultiplier: CGFloat { return 0.2 }
    
    var counterButtonYPosition: CGFloat { return (height / 8) }
    //    var counterButtonWidth: CGFloat { return (width / 3) }
    var counterButtonWidth: CGFloat { return isLandscape ? (height / 4) : (width / 3) }
    var counterButtonSpacing: CGFloat { return (width / 9) }
}

final class CounterFullScreenViewController: UIViewController {
    private var fullScreenLayout: CounterFullScreenLayout?
    private var activeConstraints: [NSLayoutConstraint] = []
    private var counterValue: Int = 0 {
        didSet {
            counterLabel.text = "\(counterValue)"
        }
    }
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(counterValue)"
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        return label
    }()
    private lazy var incrementButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(incrementValue), for: .touchUpInside)
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        return button
    }()
    private lazy var decrementButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(decrementValue), for: .touchUpInside)
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        return button
    }()
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [incrementButton, decrementButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
                
        view.addSubview(counterLabel)
        view.addSubview(buttonsStackView)
        
        updateLayout()
    }
    
    private func updateLayout() {
        NSLayoutConstraint.deactivate(activeConstraints)
        activeConstraints.removeAll()
        
        let isLandscape = view.bounds.width > view.bounds.height
        fullScreenLayout = CounterFullScreenLayout(height: view.bounds.height, width: view.bounds.width, isLandscape: isLandscape)
        
        if let fullScreenLayout {
            activeConstraints = [
                counterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                counterLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: fullScreenLayout.counterLabelYPosition),
                counterLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: fullScreenLayout.counterLabelWidthMultiplier),
                counterLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: fullScreenLayout.counterLabelHeightMultiplier),
                
                buttonsStackView.centerXAnchor.constraint(equalTo: counterLabel.centerXAnchor),
                buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: fullScreenLayout.counterButtonYPosition),
                
                incrementButton.widthAnchor.constraint(equalToConstant: fullScreenLayout.counterButtonWidth),
                incrementButton.heightAnchor.constraint(equalTo: incrementButton.widthAnchor),
                decrementButton.widthAnchor.constraint(equalTo: incrementButton.widthAnchor),
                decrementButton.heightAnchor.constraint(equalTo: incrementButton.heightAnchor)
            ]
            
            NSLayoutConstraint.activate(activeConstraints)
            
            buttonsStackView.spacing = fullScreenLayout.counterButtonSpacing
        }
    }
    
    @objc private func incrementValue() {
        counterValue += 1
    }
    
    @objc private func decrementValue() {
        counterValue -= 1
    }
}
