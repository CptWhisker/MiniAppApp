import UIKit

struct DiceCellLayout {
    let cellHeight: CGFloat
    
    var utilityButtonEdgeInsets: UIEdgeInsets { return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)}
    var utilityButtonPadding: CGFloat { return -16 }
    var utilityButtonWidth: CGFloat { return 75 }
    var utilityButtonHeightMultiplier: CGFloat { return 0.5 }
    
    var titleLabelPadding: CGFloat { return 16 }
    var titleLabelYPositionCollapsed: CGFloat { return cellHeight / 2 }
    var titleLabelYPositionExpanded: CGFloat { return cellHeight / 8 }
    
    var diceLabelTopPadding: CGFloat { return (cellHeight / 4) + (cellHeight / 12) }
    var diceButtonTopPadding: CGFloat { return diceLabelTopPadding + (cellHeight / 4) + (cellHeight / 12) }
    
    var labelWidthMultiplier: CGFloat { return 0.5 }
    var labelHeightMultiplier: CGFloat { return 0.25 }
}

struct DiceFullScreenLayout {
    let height: CGFloat
    
    var diceLabelYPosition: CGFloat { return -(height / 8) }
    var diceLabelWidthMultiplier: CGFloat { return 0.5 }
    var diceLabelHeightMultiplier: CGFloat { return 0.2 }
    
    var diceButtonYPosition: CGFloat { return (height / 8)}
}

final class DiceCell: UITableViewCell {
    var isExpanded: Bool
    var cellHeight: CGFloat
    private weak var delegate: MiniAppCellDelegate?
    private let layout: DiceCellLayout
    private var fullScreenLayout: DiceFullScreenLayout?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var utilityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleEdgeInsets = layout.utilityButtonEdgeInsets
        return button
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
    
    private lazy var fullScreenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Full", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleEdgeInsets = layout.utilityButtonEdgeInsets
        button.addTarget(self, action: #selector(presentFullScreen), for: .touchUpInside)
        return button
    }()
    
    init(isExpanded: Bool, cellHeight: CGFloat, delegate: MiniAppCellDelegate, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.isExpanded = isExpanded
        self.cellHeight = cellHeight
        self.delegate = delegate
        self.layout = DiceCellLayout(cellHeight: cellHeight)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
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
        contentView.addSubview(fullScreenButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.titleLabelPadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: isExpanded ? layout.titleLabelYPositionExpanded : layout.titleLabelYPositionCollapsed),
            
            utilityButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: layout.utilityButtonPadding),
            utilityButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            utilityButton.widthAnchor.constraint(equalToConstant: layout.utilityButtonWidth),
            utilityButton.heightAnchor.constraint(equalTo: utilityButton.widthAnchor, multiplier: layout.utilityButtonHeightMultiplier),
            
            diceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            diceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.diceLabelTopPadding),
            diceLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: layout.labelWidthMultiplier),
            diceLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: layout.labelHeightMultiplier),
            
            diceButton.centerXAnchor.constraint(equalTo: diceLabel.centerXAnchor),
            diceButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.diceButtonTopPadding),
            diceButton.widthAnchor.constraint(equalTo: diceLabel.widthAnchor),
            diceButton.heightAnchor.constraint(equalTo: diceLabel.heightAnchor),
            
            fullScreenButton.trailingAnchor.constraint(equalTo: utilityButton.trailingAnchor),
            fullScreenButton.topAnchor.constraint(equalTo: utilityButton.bottomAnchor, constant: 16),
            fullScreenButton.widthAnchor.constraint(equalTo: utilityButton.widthAnchor),
            fullScreenButton.heightAnchor.constraint(equalTo: utilityButton.heightAnchor)
        ])
        
        diceLabel.isHidden = !isExpanded
        diceButton.isHidden = !isExpanded
        fullScreenButton.isHidden = !isExpanded
    }
    
    @objc private func rollDice() {
        let diceRoll = Int.random(in: 1...6)
        diceLabel.text = "Roll result: \(diceRoll)"
    }
    
    @objc private func presentFullScreen() {
        let viewController = DiceFullScreenViewController()
        
        fullScreenLayout = DiceFullScreenLayout(height: viewController.view.bounds.height)
        
        if let fullScreenLayout {
            viewController.addElements(
                uiElements: [diceLabel, diceButton],
                layoutConstraints: [
                    diceLabel.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                    diceLabel.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor, constant: fullScreenLayout.diceLabelYPosition),
                    diceLabel.widthAnchor.constraint(equalTo: viewController.view.widthAnchor, multiplier: fullScreenLayout.diceLabelWidthMultiplier),
                    diceLabel.heightAnchor.constraint(equalTo: viewController.view.heightAnchor, multiplier: fullScreenLayout.diceLabelHeightMultiplier),
                    
                    diceButton.centerXAnchor.constraint(equalTo: diceLabel.centerXAnchor),
                    diceButton.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor, constant: fullScreenLayout.diceButtonYPosition),
                    diceButton.widthAnchor.constraint(equalTo: diceLabel.widthAnchor),
                    diceButton.heightAnchor.constraint(equalTo: diceLabel.heightAnchor)
                ],
                actions: [#selector(rollDice): diceButton]
            )
        }

        delegate?.didTapFullScreenButton(viewController)
    }
}

