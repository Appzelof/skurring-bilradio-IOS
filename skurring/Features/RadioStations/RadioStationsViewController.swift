//
//  RadioStationsViewController.swift
//  skurring
//
//  Created by Daniel Bornstedt on 20/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

protocol SearchListener: class {
    func didSearchFor(searchText: String)
}
class RadioStationsViewController: UIViewController {
    
    private var buttonTag = 0
    private lazy var tableView = makeTableView()
    private lazy var searchBar = makeSearchBar()

    weak var searchListener: SearchListener?

    private var dismissed: () -> Void?

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
        addConstraints()
    }

    init(completion: @escaping () -> ()) {
        dismissed = completion
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setButtonTag(tag: Int) {
        buttonTag = tag
    }

    private func makeTableView() -> UITableView {
        let tableView = RadioStationsTableView(radioStationsViewController: self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.buttonTag = buttonTag
        tableView.tableViewHandlerDelegate = self
        return tableView
    }

    private func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.barStyle = .default
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .white
        return searchBar
    }

    private func addConstraints() {
        NSLayoutConstraint.activate(
            [
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                searchBar.heightAnchor.constraint(equalToConstant: 50),

                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ]
        )
    }
}

extension RadioStationsViewController: TableViewHandlerDelegate, UISearchBarDelegate, UITextFieldDelegate {
    func dismissTableView() {
        self.dismiss(animated: true, completion: nil)
        dismissed()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchListener?.didSearchFor(searchText: searchText)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
