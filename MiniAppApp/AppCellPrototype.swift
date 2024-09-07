//
//  AppCellPrototype.swift
//  MiniAppApp
//
//  Created by user on 07.09.2024.
//

import UIKit

final class AppCellPrototype: UITableViewCell {
    var isExpanded: Bool
    var cellHeight: CGFloat
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var utilityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        return button
    }()
    
    init(isExpanded: Bool, cellHeight: CGFloat, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.isExpanded = isExpanded
        self.cellHeight = cellHeight
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        utilityButton.setTitle(isExpanded ? "Collapse" : "Expand", for: .normal)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(utilityButton)

        
        print(cellHeight)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: isExpanded ? (cellHeight / 8) : (cellHeight / 2)),
            
            utilityButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            utilityButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
    }
}
