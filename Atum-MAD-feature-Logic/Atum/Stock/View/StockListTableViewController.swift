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

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  // MARK: Helpers
  private func configureUI() {
    title = "Atum"

    tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.identifier)
    tableView.rowHeight = 60
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
