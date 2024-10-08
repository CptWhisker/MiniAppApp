import UIKit

// MARK: - DiceCellLayout
struct DiceCellLayout {
    let cellHeight: CGFloat
    
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

public final class DiceCell: UITableViewCell {
    // MARK: - Properties
    private var diceType: DiceType
    private var isExpanded: Bool
    private var cellHeight: CGFloat
    private weak var delegate: MiniAppCellDelegate?
    private let layout: DiceCellLayout
    
    // MARK: - UI Elements
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
        return button
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
    private lazy var fullScreenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Full", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(presentFullScreen), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    init(diceType: DiceType, isExpanded: Bool, cellHeight: CGFloat, delegate: MiniAppCellDelegate, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.diceType = diceType
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
    
    // MARK: - UI Configuration
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
    
    // MARK: - Actions
    @objc private func rollDice() {
        let diceRoll = Int.random(in: 1...diceType.rawValue)
        diceLabel.text = "Roll result: \(diceRoll)"
    }
    
    @objc private func presentFullScreen() {
        let viewController = DiceFullScreenViewController(diceType: diceType)

        delegate?.didTapFullScreenButton(viewController)
    }
}

