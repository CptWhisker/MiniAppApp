//
//  ViewController.swift
//  MiniAppApp
//
//  Created by user on 07.09.2024.
//

import UIKit

// MARK: - MiniAppType
enum MiniAppType {
    case dice, counter
}

// MARK: MiniAppCellDelegate Protocol
protocol MiniAppCellDelegate: AnyObject {
    func didTapFullScreenButton(_ viewController: UIViewController)
}

final class MiniAppViewController: UIViewController {
    // MARK: - Properties
    private var expandedMiniApps: Set<IndexPath> = []
    private var miniApps: [MiniAppType] = []
    private var calculatedCellHeight: (IndexPath) -> CGFloat {
        return { [weak self] indexPath in
            guard let self = self else { return 0 }
            let height = self.miniAppTableView.bounds.height
            return self.expandedMiniApps.contains(indexPath) ? height / 2 : height / 8
        }
    }
    
    // MARK: - UI Elements
    private lazy var miniAppTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMiniApps()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.miniAppTableView.reloadData()
        }, completion: nil)
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.addSubview(miniAppTableView)
        
        NSLayoutConstraint.activate([
            miniAppTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            miniAppTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            miniAppTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            miniAppTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - Private Methods
    private func configureMiniApps() {
        let appTypes: [MiniAppType] = [.dice, .counter]
        
        miniApps = (0..<12).map { _ in
            appTypes.randomElement() ?? .dice
        }
    }
    
    // MARK: - Actions
    @objc func toggleExpandCollapse(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if expandedMiniApps.contains(indexPath) {
            expandedMiniApps.remove(indexPath)
        } else {
            expandedMiniApps.insert(indexPath)
        }
        
        miniAppTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension MiniAppViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miniApps.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculatedCellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let miniAppType = miniApps[indexPath.row]
        
        switch miniAppType {
        case .counter:
            let cell = CounterCell(
                isExpanded: expandedMiniApps.contains(indexPath),
                cellHeight: calculatedCellHeight(indexPath),
                delegate: self,
                style: .default,
                reuseIdentifier: nil
            )
            
            cell.titleLabel.text = "Counter"
            cell.utilityButton.tag = indexPath.row
            cell.utilityButton.addTarget(self, action: #selector(toggleExpandCollapse), for: .touchUpInside)
            return cell
        case .dice:
            let cell = DiceCell(
                isExpanded: expandedMiniApps.contains(indexPath),
                cellHeight: calculatedCellHeight(indexPath),
                delegate: self,
                style: .default,
                reuseIdentifier: nil
            )
            
            cell.titleLabel.text = "Dice"
            cell.utilityButton.tag = indexPath.row
            cell.utilityButton.addTarget(self, action: #selector(toggleExpandCollapse), for: .touchUpInside)
            
            return cell
        }
    }
}

// MARK: - MiniAppCellDelegate Implementation
extension MiniAppViewController: MiniAppCellDelegate {
    func didTapFullScreenButton(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}
