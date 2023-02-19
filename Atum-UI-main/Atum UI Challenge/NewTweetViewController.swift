//
//  NewTweetViewController.swift
//  Atum UI Challenge
//

import UIKit

class NewTweetViewController: UIViewController {

  @IBOutlet var image: UIImageView!
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var charactersLeftLabel: UILabel!
  @IBOutlet var bottomSpaceConstraint: NSLayoutConstraint!
  @IBAction func sendTweet(_ sender: Any) {
    //For now just dismiss the sheet. You need not add the tweet to the list
    dismiss(animated: true, completion: nil)
  }

  // MARK: - Private properties
  private var updatedText: String = "" {
    didSet {}
  }

  // TODO: Optional 7 Add a cancel: button to the top right of the view in the Storyboard and hook it up to dismiss this view controller

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addKeyboardWillHideNotification()
    addKeyboardWillChangeFrameNotification()
    // TODO: 6 Immediately start editing when the view appears - DONE
    descriptionTextView.becomeFirstResponder()

    // TODO: 9 Set up a delegate to the UITextView to cap the number of characters in descriptionTextView to 140
    //and update charactersLeftLabel with the number of characters left in descriptionTextView - DONE
    descriptionTextView.delegate = self
  }

  private func addKeyboardWillHideNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  private func addKeyboardWillChangeFrameNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }

  @objc private func onKeyboardWillHide() {
    self.bottomSpaceConstraint.constant = 8
    UIView.animate(withDuration: 1) {
      self.view.layoutIfNeeded()
    }
  }

  @objc private func onKeyboardWillChangeFrame(_ notification: NSNotification) {
    // TODO: 7 when the keyboard appears or disappears, move the Tweet button and the character count so it stays at the bottom of the screen, matching the animation and animation duration - DONE
    let keyboardSize: CGRect = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect()
    let keyboardHeight = keyboardSize.height
    self.bottomSpaceConstraint.constant = keyboardHeight
  }

  @IBAction func cancelButtonAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

extension NewTweetViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let currentText: String = textView.text ?? ""
    guard let stringRange: Range = Range(range, in: currentText) else { return false }
    updatedText = currentText.replacingCharacters(in: stringRange, with: text)
    if updatedText.count <= 140 {
      charactersLeftLabel.text = String(140 - updatedText.count)
    }
    return updatedText.count < 141
  }
}
