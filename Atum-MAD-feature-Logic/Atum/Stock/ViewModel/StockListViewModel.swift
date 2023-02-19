//
//  StockListViewModel.swift
//  Atum

import Foundation

class StockListViewModel {
    private let stocksRepository = StocksRepository()
    var stocks: [Stock]

    init() {
        stocks = stocksRepository.getAllStocks()
    }
    
    var count: Int { stocks.count }
    
    func stockViewModel(at index: Int) -> StockViewModel {
        return StockViewModel(stock: stocks[index])
    }
}
