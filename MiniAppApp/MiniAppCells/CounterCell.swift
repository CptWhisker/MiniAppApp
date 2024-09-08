import UIKit

// MARK: - CounterCellLayout
struct CounterCellLayout {
    let cellHeight: CGFloat
    
    var utilityButtonEdgeInsets: UIEdgeInsets { return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)}
    var utilityButtonPadding: CGFloat { return -16 }
    var utilityButtonWidth: CGFloat { return 75 }
    var utilityButtonHeightMultiplier: CGFloat { return 0.5 }
    
    var titleLabelPadding: CGFloat { return 16 }
    var titleLabelYPositionCollapsed: CGFloat { return cellHeight / 2 }
    var titleLabelYPositionExpanded: CGFloat { return cellHeight / 8 }
    
    var counterLabelTopPadding: CGFloat { return (cellHeight / 4) + (cellHeight / 12) }
    var counterButtonTopPadding: CGFloat { return counterLabelTopPadding + (cellHeight / 4) + (cellHeight / 12) }
    
    var labelWidthMultiplier: CGFloat { return 0.5 }
    var labelHeightMultiplier: CGFloat { return 0.25 }
    
    var buttonsStackWidthMultiplier: CGFloat { return 0.5 }
}

final class CounterCell: UITableViewCell {
    // MARK: - Properties
    private let isColored: Bool
    private var isExpanded: Bool
    private var cellHeight: CGFloat
    private weak var delegate: MiniAppCellDelegate?
    private let layout: CounterCellLayout
    private var counterValue: Int = 0 {
        didSet {
            counterLabel.text = "\(counterValue)"
        }
    }
    
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
        button.titleEdgeInsets = layout.utilityButtonEdgeInsets
        return button
    }()
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
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
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
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
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
        stackView.spacing = contentView.bounds.width / 12
        stackView.distribution = .fillEqually
        return stackView
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
    
    // MARK: - Initializers
    init(isColored: Bool, isExpanded: Bool, cellHeight: CGFloat, delegate: MiniAppCellDelegate, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.isColored = isColored
        self.isExpanded = isExpanded
        self.cellHeight = cellHeight
        self.delegate = delegate
        self.layout = CounterCellLayout(cellHeight: cellHeight)
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
        contentView.addSubview(counterLabel)
        contentView.addSubview(buttonsStackView)
        contentView.addSubview(fullScreenButton)
        
        if isColored {
            incrementButton.setTitleColor(.red, for: .normal)
            incrementButton.layer.borderColor = UIColor.red.cgColor
            incrementButton.backgroundColor = UIColor.red.withAlphaComponent(0.1)
            
            decrementButton.setTitleColor(.blue, for: .normal)
            decrementButton.layer.borderColor = UIColor.blue.cgColor
            decrementButton.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.titleLabelPadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: isExpanded ? layout.titleLabelYPositionExpanded : layout.titleLabelYPositionCollapsed),
            
            utilityButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: layout.utilityButtonPadding),
            utilityButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            utilityButton.widthAnchor.constraint(equalToConstant: layout.utilityButtonWidth),
            utilityButton.heightAnchor.constraint(equalTo: utilityButton.widthAnchor, multiplier: layout.utilityButtonHeightMultiplier),
            
            counterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            counterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.counterLabelTopPadding),
            counterLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: layout.labelWidthMultiplier),
            counterLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: layout.labelHeightMultiplier),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: counterLabel.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.counterButtonTopPadding),
            buttonsStackView.heightAnchor.constraint(equalTo: counterLabel.heightAnchor),
            
            fullScreenButton.trailingAnchor.constraint(equalTo: utilityButton.trailingAnchor),
            fullScreenButton.topAnchor.constraint(equalTo: utilityButton.bottomAnchor, constant: 16),
            fullScreenButton.widthAnchor.constraint(equalTo: utilityButton.widthAnchor),
            fullScreenButton.heightAnchor.constraint(equalTo: utilityButton.heightAnchor)
        ])
        
        counterLabel.isHidden = !isExpanded
        buttonsStackView.isHidden = !isExpanded
        fullScreenButton.isHidden = !isExpanded
    }
    
    // MARK: - Actions
    @objc private func incrementValue() {
        counterValue += 1
    }
    
    @objc private func decrementValue() {
        counterValue -= 1
    }
    
    @objc private func presentFullScreen() {
        let viewController = CounterFullScreenViewController(isColored: isColored)

        delegate?.didTapFullScreenButton(viewController)
    }
}
