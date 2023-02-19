//
//  StockDetailController.swift
//  Atum
//
//  The stock detail view controller provided by the Portfolio team

import UIKit

// Delegate protocol form the class that will be sending data
protocol PortfolioStatusViewControllerDelegate: AnyObject {
  func updateStocks(someParam: PortfolioStatusViewModel)
}

final class PortfolioStatusViewController: UIViewController {

  weak var delegate: PortfolioStatusViewControllerDelegate?
  // MARK: Properties
  private var portfolioStatusViewModel: PortfolioStatusViewModel
  private let spinner: SpinnerViewController

  private let stockTotal: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 20)
    label.text = "120.0"
    return label
  }()

  private let stockPriceTitle: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 20)
    label.text = "Current Price:"
    return label
  }()

  private let stockTitle: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 16)
    label.text = "APPLE"
    return label
  }()

  private let stockTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 16)
    label.text = "Portfolio"
    return label
  }()

  private let stockTicker: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "APPL"
    return label
  }()

  private let currentNumberOfStocks: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "Number of stocks is 1"
    return label
  }()

  private let currentStockPrice: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "1968.00"
    label.textAlignment = .center
    return label
  }()

  private let buyButton: UIButton = {
    let button = UIButton()
    button.setTitle("Buy", for: .normal)
    button.backgroundColor = .systemBlue
    button.addTarget(self, action: #selector(buy), for: .touchUpInside)
    button.layer.cornerRadius = 5
    return button
  }()

  private let sellButton: UIButton = {
    let button = UIButton()
    button.setTitle("Sell", for: .normal)
    button.backgroundColor = .systemRed
    button.addTarget(self, action: #selector(sell), for: .touchUpInside)
    button.layer.cornerRadius = 5
    return button
  }()

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  init(portfolioStatusViewModel: PortfolioStatusViewModel) {
    self.portfolioStatusViewModel = portfolioStatusViewModel
    self.spinner = SpinnerViewController()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Selectors

  @objc private func buy() {
    showSpinner()
    DispatchQueue.global(qos: .background).async {
      self.portfolioStatusViewModel.buyStock()
      DispatchQueue.main.async {
        self.displayStockData()
        self.hideSpinner()
        self.delegate?.updateStocks(someParam: self.portfolioStatusViewModel)
      }
    }
  }

  @objc private func sell() throws {
    showSpinner()
    DispatchQueue.global(qos: .background).async {
      do {
        try self.portfolioStatusViewModel.sellStock()
        DispatchQueue.main.async {
          self.displayStockData()
          self.hideSpinner()
        }
      } catch {
        DispatchQueue.main.async {
          self.showOutOfStocksAlert()
          self.hideSpinner()
        }
      }
    }
  }

  // MARK: helpers

  private func configureUI() {
    view.backgroundColor = .white

    let generalInfoStack = UIStackView(arrangedSubviews: [stockTitle, stockTitleLabel])
    generalInfoStack.spacing = 10
    view.addSubview(generalInfoStack)
    generalInfoStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 40)

    let stockNumberStack = UIStackView(arrangedSubviews: [stockTicker, currentNumberOfStocks])
    view.addSubview(stockNumberStack)
    stockNumberStack.anchor(top: generalInfoStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 40)

    let stockPriceStack = UIStackView(arrangedSubviews: [stockPriceTitle, currentStockPrice])
    stockPriceStack.spacing = 10
    view.addSubview(stockPriceStack)
    stockPriceStack.anchor(top: currentNumberOfStocks.bottomAnchor, left: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 40)

    view.addSubview(stockTotal)
    stockTotal.anchor(top: stockPriceStack.bottomAnchor, left: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 40)

    let buttonsStack = UIStackView(arrangedSubviews: [buyButton, sellButton])
    buttonsStack.axis = .horizontal
    buttonsStack.spacing = 8
    buttonsStack.contentMode = .scaleAspectFit
    buttonsStack.distribution = .fillEqually
    view.addSubview(buttonsStack)
    buttonsStack.anchor( left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 50)
    displayStockData()
  }

  private func displayStockData() {
    stockTitle.attributedText = portfolioStatusViewModel.company
    stockTicker.attributedText = portfolioStatusViewModel.ticker
    stockTotal.attributedText = portfolioStatusViewModel.portfolioTotal
    currentNumberOfStocks.attributedText = portfolioStatusViewModel.currentNumberOfStocks
    currentStockPrice.attributedText = portfolioStatusViewModel.currentStockPrice
  }

  private func showOutOfStocksAlert() {
    let alert = portfolioStatusViewModel.getOutOfStocksAlert()
    self.present(alert, animated: true, completion: nil)
  }
}

extension PortfolioStatusViewController {
  func showSpinner() {
    spinner.add(to: self)
  }

  func hideSpinner() {
    spinner.remove()
  }
}

