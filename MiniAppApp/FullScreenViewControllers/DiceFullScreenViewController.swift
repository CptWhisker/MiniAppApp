//
//  DiceFullScreenViewController.swift
//  MiniAppApp
//
//  Created by user on 08.09.2024.
//

import UIKit

final class DiceFullScreenViewController: UIViewController {
    private var uiElements: Set<UIView>?
    private var layoutConstraints: [NSLayoutConstraint]?
    private var actions: [Selector: UIButton]?
    private var diceLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
        configureActions()
    }
    
    private func configureUI() {
        guard let uiElements,
              let layoutConstraints else { return }
        
        uiElements.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func configureActions() {
        guard let actions else { return }
        
        for (action, button) in actions {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
    }
    
    @objc private func rollDice() {
        guard let diceLabel else { return }
        
        let diceRoll = Int.random(in: 1...6)
        diceLabel.text = "Roll result: \(diceRoll)"
    }
    
    func addElements(uiElements: Set<UIView>, layoutConstraints: [NSLayoutConstraint], actions: [Selector: UIButton]) {
        self.uiElements = uiElements
        self.layoutConstraints = layoutConstraints
        self.actions = actions
        
        self.diceLabel = uiElements.compactMap { $0 as? UILabel }.first
    }
}
