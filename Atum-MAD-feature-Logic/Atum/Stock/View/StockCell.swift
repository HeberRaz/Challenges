//
//  StockCell.swift
//  Atum
//
//  A table view cell to display the stock info provide by the Stock team

import UIKit

final class StockCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = String(describing: self)
    
    public var stockViewModel: StockViewModel? {
        didSet { configure() }
    }
    
    private let company: UILabel = {
        let label = UILabel()
        label.text = "APPLE"
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.text = "$120.00"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private let ticker: UILabel = {
        let label = UILabel()
        label.text = "APPL"
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [company, ticker])
        stack.spacing = 8
        stack.axis = .vertical
        addSubview(stack)
        
        stack.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, width: frame.width / 2)
        
        addSubview(price)
        price.anchor(top: self.topAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 8, paddingRight: 8, width: frame.width / 2)
    }
    
    
    private func configure() {
        guard let stockViewModel = stockViewModel else { return }
        company.attributedText = stockViewModel.company
        ticker.attributedText = stockViewModel.ticker
        price.attributedText = stockViewModel.currentStockPrice
    }
}
