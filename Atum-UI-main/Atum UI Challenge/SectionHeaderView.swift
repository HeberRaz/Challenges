//
//  SectionHeaderView.swift
//  Atum UI Challenge
//
//  Solution - Create a section header in code
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
  static let reuseIdentifier: String = String(describing: SectionHeaderView.self)

  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var settingsButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()


  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    // TODO: 3 Add a Settings button at the end of the header row. It can just print a message to the console
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(settingsButton)

    descriptionLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
    descriptionLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
    descriptionLabel.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor).isActive = true
    descriptionLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true

    displaySettingsButton()
  }

  private func displaySettingsButton() {
    settingsButton.setTitle("Settings", for: UIControl.State.normal)
    settingsButton.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
    NSLayoutConstraint.activate([
      settingsButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
      settingsButton.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
      settingsButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      settingsButton.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
    ])
    settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: UIControl.Event.touchUpInside)
  }

  @objc private func settingsButtonAction() {
    print("Settings button was tapped")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

