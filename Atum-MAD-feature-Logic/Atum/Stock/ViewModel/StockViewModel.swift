//
//  StockViewModel.swift
//  Atum
//
//

import UIKit

protocol StockType {
    var company: NSMutableAttributedString { get }
    var ticker: NSMutableAttributedString { get }
    var currentStockPrice: NSMutableAttributedString { get }
}

struct StockViewModel: StockType {
    let stock: Stock
    
    var company: NSMutableAttributedString {
        let title = NSMutableAttributedString(string: stock.companyName, attributes: [ .font: UIFont.boldSystemFont(ofSize: 14)])
        return title
    }
    
    var ticker: NSMutableAttributedString {
        let ticker = NSMutableAttributedString(string: stock.ticker, attributes: [ .font: UIFont.boldSystemFont(ofSize: 11), .foregroundColor: UIColor.lightGray])
        return ticker
    }
    
    var currentStockPrice: NSMutableAttributedString {
        let price = NSMutableAttributedString(string: String(format: "%.2f", stock.price), attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        return price
    }
}
