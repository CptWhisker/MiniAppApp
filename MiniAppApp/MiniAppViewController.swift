//
//  ViewController.swift
//  MiniAppApp
//
//  Created by user on 07.09.2024.
//

import UIKit

enum MiniAppType {
    case dice, counter, animation
}

final class MiniAppViewController: UIViewController {
    private var expandedMiniApps: Set<IndexPath> = []
    private var calculatedCellHeight: (IndexPath) -> CGFloat {
        return { [weak self] indexPath in
            guard let self = self else { return 0 }
            let height = self.miniAppTableView.bounds.height
            return self.expandedMiniApps.contains(indexPath) ? height / 2 : height / 8
        }
    }
    
    private lazy var miniAppTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(miniAppTableView)
        
        NSLayoutConstraint.activate([
            miniAppTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            miniAppTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            miniAppTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            miniAppTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
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

extension MiniAppViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculatedCellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DiceCell(
            isExpanded: expandedMiniApps.contains(indexPath),
            cellHeight: calculatedCellHeight(indexPath),
            style: .default,
            reuseIdentifier: nil
        )
        
        cell.titleLabel.text = "Cell \(indexPath.row + 1)"
        cell.utilityButton.tag = indexPath.row
        cell.utilityButton.addTarget(self, action: #selector(toggleExpandCollapse), for: .touchUpInside)
        
        return cell
    }
}

extension MiniAppViewController: UITableViewDelegate {}
