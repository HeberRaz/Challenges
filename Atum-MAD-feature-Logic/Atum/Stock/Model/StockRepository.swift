//
//  StockRepository.swift
//  Atum
//
//  This is the Stock Repository class provided by the Stock Repository team.

//  Try to use this file AS IS so as to not have to cycle changes back trough another group.

//  The StockRepository provides 2 basic functions:

//  getAllStocks() provides a list of all the stocks

//  getSpecificStock(ticker: String) provides the current Stock details of any stock given its stockTicker

//  The notification didReceiveStockUpdate fires every few seconds with an update.
//      The UserInfo dictionary contains a stockInfoKey with an array of Stocks that have changed.

import Foundation

extension Notification.Name {
    static let didReceiveStockUpdate = Notification.Name("didReceiveStockUpdate")
}

let stockInfoKey = "stockInfo"


final class StocksRepository {
    private let generator = StockGenerator()

    public func getAllStocks() -> [Stock] {
        return generator.getStocks()
    }
    
    public func getSpecificStock(ticker: String) -> Stock? {
        return generator.getStock(ticker: ticker)
    }
}




//      --------------------------------------------------------------
// This class is private and you should not need to know how it works to use the StockRepository


fileprivate final class StockGenerator {
    
    private var timer : Timer? = nil {
           willSet {
               timer?.invalidate()
           }
    }
    
    var alwaysShow: [Stock] {
        let apple = Stock(price: 120.0, ticker: "APPL", companyName: "Apple")
        let alphabet = Stock(price: 16320.0, ticker: "GOOGL", companyName: "Alphabet Inc")
        let tesla = Stock(price: 400.8, ticker: "TSLA", companyName: "Tesla")
        let procter = Stock(price: 138.6, ticker: "PG", companyName: "Procter & Gamble")
        
        return [apple, alphabet, procter, tesla]
    }
    
    var maybeShow: [Stock] {
        let facebook = Stock(price: 273.55, ticker: "FB", companyName: "Facebook, Inc")
        let microsoft = Stock(price: 216.81, ticker: "MSFT", companyName: "Microsoft Corporation")
        let twitter = Stock(price: 51.44, ticker: "TWTR", companyName: "Twitter, Inc")
        let walmart = Stock(price: 144.50, ticker: "WMT", companyName: "Walmart")
        
        let values = [microsoft, walmart, twitter, facebook]
        return values
    }
    
    fileprivate func getStocks() -> [Stock] {
        var randomStocks = maybeShow
        randomStocks.append(contentsOf: alwaysShow)
        randomStocks = randomStocks.map { stock in return stock.variedPrice() }
        return randomStocks.shuffled()
    }
    
    fileprivate func getStock(ticker: String) -> Stock? {
        if let stock = find(value: ticker, in: maybeShow) ?? find(value: ticker, in: alwaysShow) {
            return stock.variedPrice()
        } else {
            return nil
        }
    }
    
    private func find(value searchTicker: String, in array: [Stock]) -> Stock? {
        
        for (index, value) in array.enumerated() {
            if value.ticker == searchTicker {
                return array[index]
            }
        }
        return nil
    }
        
        init() {
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
                if let self = self {
                    let stocks = self.getStocks()
                        .compactMap{ Bool.random() ? $0 : nil }
                    NotificationCenter.default.post(name: .didReceiveStockUpdate, object: nil, userInfo: [stockInfoKey: stocks])
                }
            }
        }

        deinit {
            timer?.invalidate()
        }
}

extension Stock {
    func variedPrice() -> Stock {
        return Stock(price:self.price * Double.random(in: 0.98...1.02), ticker: self.ticker, companyName: self.companyName)
    }
}
