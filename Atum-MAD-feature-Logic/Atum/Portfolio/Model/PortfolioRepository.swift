//
//  PortfolioRepository.swift
//  Atum
//
//  This is the Portfolio Repository class provided by the Portfolio Repository team.

//  Try to use this file AS IS so as to not have to cycle changes back trough another group.

//  The StockRepository provides 3 basic functions:

//  portfolio(stockTicker: String) provides a PortfolioStatus with the number of stocks of the given Stock Ticker string

//  buy(prevPortfolioStatus: PortfolioStatus, amount: Int) initiates a purchase of a given number of stocks and returns a new PortfolioStatus

//  sell(prevPortfolioStatus: PortfolioStatus, amount: Int) initiates a sale of a given number of stocks. This call throws ErrorBuying if there are not enough to sell and returns an updated PortfolioStatus

import Foundation

final class PortfolioRepository {
    
    // Add a random sleep to simulate a network request delay
    private func randomSleep() {
        let sleepTime = Int.random(in: 500000...1500000)
        usleep(useconds_t(sleepTime))
    }
    
    // Return the Portfolio Status of a given ticker
    public func portfolio(stockTicker: String) -> PortfolioStatus {
        return PortfolioStatus(
            stockTicker: stockTicker,
            amountOfStocks: Int.random(in: 2...5)  // we generate a random number of stocks
        )
    }
    
    // Buy a given number of stocks, returning the new Portfolio Status, which could have changed in the meantime by someone else
    public func buy(prevPortfolioStatus: PortfolioStatus, amount: Int) -> PortfolioStatus {
        randomSleep()
        return PortfolioStatus(stockTicker: prevPortfolioStatus.stockTicker, amountOfStocks: prevPortfolioStatus.amountOfStocks + amount )
    }
    
    // Sell a given number of stocks, returning the new Portfolio Status, which could have changed in the meantime by someone else
    // Throws ErrorBuying when you try to sell more than you currently have.
    public func sell(prevPortfolioStatus: PortfolioStatus, amount: Int) throws -> PortfolioStatus {
        randomSleep()
        if prevPortfolioStatus.amountOfStocks < amount {
            throw ErrorBuying.minimumNumberOfStocks
        }

        return PortfolioStatus(stockTicker: prevPortfolioStatus.stockTicker, amountOfStocks: prevPortfolioStatus.amountOfStocks - amount)
    }
}


enum ErrorBuying: Error {
    case minimumNumberOfStocks
}
