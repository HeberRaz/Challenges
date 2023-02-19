//
//  DetailStockViewModel.swift
//  Atum
//
//

import UIKit

// The ViewModel provided by the Portfolio team
struct PortfolioStatusViewModel {
  let stockRepository: StocksRepository = StocksRepository()
  //FIXME: The actual stock price and the company name will eventually be retrieved from a StockRepository
  let stockPrice: Double
  let companyName: String

  let portfolioRepository = PortfolioRepository()
  var portfolioStatus: PortfolioStatus


  // Initialize with the stockTicker abbreviation
  init(stockTicker: String) {
    portfolioStatus = portfolioRepository.portfolio(stockTicker: stockTicker)
    let stock = stockRepository.getSpecificStock(ticker: stockTicker)
    stockPrice = stock?.price ?? 0.0
    companyName = stock?.companyName ?? "no name found"
  }

  // returns a formatted string of the company name
  var company: NSMutableAttributedString {
    let title = NSMutableAttributedString(string: companyName, attributes: [ .font: UIFont.boldSystemFont(ofSize: 20)])
    return title
  }

  // returns a formatted string of the stock abbreviation
  var ticker: NSMutableAttributedString {
    let ticker = NSMutableAttributedString(string: portfolioStatus.stockTicker, attributes: [ .font: UIFont.boldSystemFont(ofSize: 11), .foregroundColor: UIColor.lightGray])
    return ticker
  }

  // returns a formatted string of the total value of all stocks of this kind in the portfolio
  var portfolioTotal: NSMutableAttributedString {
    let price = NSMutableAttributedString(string: "$ " + String(format: "%.2f", Double(portfolioStatus.amountOfStocks) * stockPrice), attributes: [.font:UIFont.boldSystemFont(ofSize: 20)])
    return price
  }

  // returns a formatted string of the number of stocks in the portfolio
  var currentNumberOfStocks: NSMutableAttributedString {
    let title = NSMutableAttributedString(string: "Number of stocks is \(portfolioStatus.amountOfStocks)", attributes: [ .font: UIFont.boldSystemFont(ofSize: 14)])
    return title
  }

  // returns a formatted string of the current price of this stock in the portfolio
  var currentStockPrice: NSMutableAttributedString {
    let price = NSMutableAttributedString(string: "$" + String(format: "%.2f", stockPrice), attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
    return price
  }

  // MARK: Methods
  mutating func buyStock() {
    portfolioStatus = portfolioRepository.buy(prevPortfolioStatus: portfolioStatus, amount: 1)
  }

  mutating func sellStock() throws {
    portfolioStatus = try portfolioRepository.sell(prevPortfolioStatus: portfolioStatus, amount: 1)
  }

  func getOutOfStocksAlert() -> UIAlertController {
    let alert: UIAlertController = UIAlertController(title: Localizables.stockAlertTitle, message: Localizables.stockAlertMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Localizables.stockAlertButtonTitle, style: .default, handler: { action in
    }))
    return alert
  }
}
