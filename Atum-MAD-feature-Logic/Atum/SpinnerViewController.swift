//
//  SpinnerViewController.swift
//  Atum
//
//  A Utility view provided as a convenience to hide the user interface during long running tasks.
//

import UIKit

class SpinnerViewController: UIViewController {

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    public func add(to parent: UIViewController) {
        
        // add the spinner view controller
        parent.addChild(self)
        self.view.frame = parent.view.frame
        parent.view.addSubview(self.view)
        self.didMove(toParent: parent)
    }

    public func remove()
    {
        // wait two seconds to simulate some work happening
        // then remove the spinner view controller
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
