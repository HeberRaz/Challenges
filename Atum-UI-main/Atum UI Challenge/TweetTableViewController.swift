
import UIKit

// Solution - Renamed the generic UIViewController to be a UITableViewController
// view controllers and cell prototypes are in the Storyboard

class TweetTableViewController: UITableViewController {

  private let viewModelHelper = ViewModelHelper()
  private var numberOfRows: Int {
    return viewModelHelper.tweetCount() == 0 ? 1 : viewModelHelper.tweetCount()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addTweet))
    // TODO: 1
    viewModelHelper.loadUserProfile(locally: true, completion: { [weak self] in
      if let name = self?.viewModelHelper.userProfileViewModel()?.name() {
        self?.title = name
      }
    })

    // TODO: Optional 1 Switch to loading these over the network by setting locally: false
    viewModelHelper.loadTweets(locally: true, completion: { [weak self] in
      if let count = self?.viewModelHelper.tweetCount() {
        print("Loaded \(count) tweets")
      }
    })
    self.tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
  }

  // TODO: 4 Create an add bar button item that calls the addTweet() function provided
  @IBAction func addTweet() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let newTweetVC = storyboard.instantiateViewController(identifier: "newTweetViewController") as! NewTweetViewController
    self.present(newTweetVC, animated: true)
  }

  // MARK: - Table view data source
  // TODO: 2 Update the table view to show the real tweets when they are available

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //Hint: If you get the TweetViewModel from the viewModelHelper, you can use it to configure a new TweetTableViewCell
    //Hint: This cell is in the storyboard with the identifier TweetTableViewCell
    let cell: TweetTableViewCell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.reuseIdentifier) as? TweetTableViewCell ?? TweetTableViewCell()
    let userName = viewModelHelper.tweetCount() == 0 ? "Loading..." : viewModelHelper.userProfileViewModel()?.userProfile.name
    let description = viewModelHelper.tweetCount() == 0 ? "Loading" : viewModelHelper.tweetViewModel(at: indexPath.row)?.text()
    cell.userLabel.text = userName
    cell.descriptionLabel.text = description
    return cell
    // TODO: Optional 2 - When there are no cells yet, return a single cell that says "Loading" - DONE
  }

  // This is how we hide the header view in Compact/Landscape
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    // TODO: Optional 3 Bonus: Hide the section header in landscape - DONE
    let height = UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight ?
    CGFloat.zero : 50
    return height
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as? SectionHeaderView
    else { return nil }

    // We let the viewModel configure the view just like the cells
    if let userProfileViewModel = viewModelHelper.userProfileViewModel() {
      view.descriptionLabel.text = userProfileViewModel.description()
    }
    return view
  }

  // Solution - For Details we set up a segue in the Storyboard. Here we just need to give it a view model
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let indexPath = tableView.indexPathForSelectedRow {
      let destination = segue.destination as! TweetDetailViewController
      let tweetViewModel = viewModelHelper.tweetViewModel(at: indexPath.row)
      destination.tweetViewModel = tweetViewModel
    }
    // TODO: Optional 4 - The segue to the detail is already set up but you need to get the destination and give it a tweetViewModel - DONE
  }

  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
  }
}

