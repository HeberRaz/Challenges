//
//  HomeController.swift
//  Atum
//
//  A bare bones table view controller provided by the Stock info team

import UIKit

final class StockListTableViewController: UITableViewController {

  // MARK: Properties
  private var stockListViewModel = StockListViewModel()
  private var selectedStockIndex: IndexPath?
    private var token: Any?

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    
      checkStocksUpdateII()
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        token.map { NotificationCenter.default.removeObserver($0) }
    }

  // MARK: Helpers
  private func configureUI() {
    title = "Atum"

    tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.identifier)
    tableView.rowHeight = 60
  }
    
    private func checkStocksUpdate() {
        NotificationCenter.myCenter.addObserver(self, selector: #selector(someFunc), name: .didReceiveStockUpdate, object: nil)
    }
    
    private func checkStocksUpdateII() {
        var notificationCounter = 0
        token = NotificationCenter.myCenter.addObserver(forName: .didReceiveStockUpdate,
                                                        object: nil,
                                                        queue: .current) { notification in
            
            notificationCounter += 1
            print(notificationCounter)
            self.stockListViewModel.stocks = notification.userInfo![stockInfoKey] as! [Stock]
            self.tableView.reloadData()
            
        }
    }
    
    @objc private func someFunc(_ notification: Notification) {
        stockListViewModel.stocks = notification.userInfo![stockInfoKey] as! [Stock]
        tableView.reloadData()
    }
}

extension StockListTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stockListViewModel.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as! StockCell

    cell.stockViewModel = stockListViewModel.stockViewModel(at: indexPath.row)
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let stockViewModel: StockViewModel = stockListViewModel.stockViewModel(at: indexPath.row)
    let portfolioStatusViewModel: PortfolioStatusViewModel = PortfolioStatusViewModel(stockTicker: stockViewModel.stock.ticker)
    let portfolioStatusViewController: PortfolioStatusViewController = PortfolioStatusViewController(portfolioStatusViewModel: portfolioStatusViewModel)
    portfolioStatusViewController.delegate = self
    selectedStockIndex = indexPath
    navigationController?.pushViewController(portfolioStatusViewController, animated: true)
  }

  //FIXME: Handle row selection to push a PortfolioStatusViewController
  //Hint: stockListViewModel will give you a PortfolioStatusViewModel if asked

  //  stockTitle.attributedText = portfolioStatusViewModel.company
  //  stockTicker.attributedText = portfolioStatusViewModel.ticker
  //  stockTotal.attributedText = portfolioStatusViewModel.portfolioTotal
  //  currentNumberOfStocks.attributedText = portfolioStatusViewModel.currentNumberOfStocks
  //  currentStockPrice.attributedText = portfolioStatusViewModel.currentStockPrice
}

extension StockListTableViewController: PortfolioStatusViewControllerDelegate {
  func updateStocks(someParam: PortfolioStatusViewModel) {
    stockListViewModel.stocks[selectedStockIndex!.row].price = someParam.stockPrice
  }
}
