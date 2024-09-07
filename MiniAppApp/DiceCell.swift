import UIKit

struct DiceCellLayout {
    let cellHeight: CGFloat
    
    var titleLabelPadding: CGFloat { return 16 }
    var utilityButtonPadding: CGFloat { return -16 }
    
    var collapsedTitleYPosition: CGFloat { return cellHeight / 2 }
    var expandedTitleYPosition: CGFloat { return cellHeight / 8 }
    
    var diceLabelTopPadding: CGFloat { return (cellHeight / 4) + (cellHeight / 12) }
    var diceButtonTopPadding: CGFloat { return diceLabelTopPadding + (cellHeight / 4) + (cellHeight / 12) }
    
    var labelWidthMultiplier: CGFloat { return 0.5 }
    var labelHeightMultiplier: CGFloat { return 0.25 }
}

final class DiceCell: UITableViewCell {
    var isExpanded: Bool
    var cellHeight: CGFloat
    private let layout: DiceCellLayout
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
    
    lazy var diceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    lazy var diceButton: UIButton = {
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
    
    init(isExpanded: Bool, cellHeight: CGFloat, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.isExpanded = isExpanded
        self.cellHeight = cellHeight
        self.layout = DiceCellLayout(cellHeight: cellHeight)
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
        contentView.addSubview(diceLabel)
        contentView.addSubview(diceButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.titleLabelPadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: isExpanded ? layout.expandedTitleYPosition : layout.collapsedTitleYPosition),
            
            utilityButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: layout.utilityButtonPadding),
            utilityButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            diceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            diceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.diceLabelTopPadding),
            diceLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: layout.labelWidthMultiplier),
            diceLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: layout.labelHeightMultiplier),
            
            diceButton.centerXAnchor.constraint(equalTo: diceLabel.centerXAnchor),
            diceButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.diceButtonTopPadding),
            diceButton.widthAnchor.constraint(equalTo: diceLabel.widthAnchor),
            diceButton.heightAnchor.constraint(equalTo: diceLabel.heightAnchor)
        ])
        
        diceLabel.isHidden = !isExpanded
        diceButton.isHidden = !isExpanded
    }
    
    @objc private func rollDice() {
        let diceRoll = Int.random(in: 1...6)
        diceLabel.text = "Roll result: \(diceRoll)"
    }
}
