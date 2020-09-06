//
//  RadioStationsTableView.swift
//  skurring
//
//  Created by Daniel Bornstedt on 20/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewHandlerDelegate: class {
    func dismissTableView()
}

final class RadioStationsTableView: UITableView {

    var buttonTag = 0

    weak var tableViewHandlerDelegate: TableViewHandlerDelegate?

    private var radioImage: UIImage?

    private var coreDataManager = CoreDataManager()

    private var radioStations: [RadioStation]? {
        didSet {
            reloadData()
        }
    }

    private var nonFilteredRadioStations: [RadioStation]? = []

    init(radioStationsViewController: RadioStationsViewController) {
        super.init(frame: .zero, style: .grouped)
        register(RadioStationTableViewCell.self, forCellReuseIdentifier: "tableCell")
        radioStationsViewController.searchListener = self
        configureTableView()
        fetchData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func fetchData() {
        NetworkManager.shared.fetchRadioStation { radioStations in
            self.radioStations = radioStations
            self.nonFilteredRadioStations = radioStations
            self.reloadData()
        }
    }
}

extension RadioStationsTableView: UITableViewDataSource, UITableViewDelegate {
    private func configureTableView() {
        delegate = self
        dataSource = self
        backgroundColor = .black
        separatorStyle = .none
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radioStations?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let stations = radioStations,
            let radioImageData = cellForRow(at: indexPath)?.imageView?.image?.pngData(),
            cellForRow(at: indexPath)?.imageView?.image != nil
        else { return }

        coreDataManager.saveChannel(
            radioStation: stations[indexPath.row],
            imageData: radioImageData,
            buttonTag: buttonTag
        )

        tableViewHandlerDelegate?.dismissTableView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(
                withIdentifier: "tableCell") as? RadioStationTableViewCell
        else { return UITableViewCell() }

        if let radioStations = radioStations {
            cell.updateUI(with: radioStations[indexPath.row])
        }
        return cell
    }
}

extension RadioStationsTableView: SearchListener {
    func didSearchFor(searchText: String) {
        radioStations = nonFilteredRadioStations
        if !searchText.isEmpty {
            radioStations = radioStations?.filter {
                $0.name?.capitalized.contains(searchText.capitalized) == true
            }
        }
    }
}

fileprivate class RadioStationTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurePrerequisits()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(
            x: 10,
            y: contentView.frame.origin.y,
            width: 80,
            height: contentView.frame.height
        )
    }

    override func prepareForReuse() {
        textLabel?.text = nil
        imageView?.image = nil
    }

    func configurePrerequisits() {
        backgroundColor = .clear
        textLabel?.textColor = .white
        textLabel?.textAlignment = .right
        imageView?.contentMode = .scaleAspectFit
        selectionStyle = .none
    }

     func updateUI(with radioStation: RadioStation) {
        let imageURL = radioStation.imageURL ?? ""
        let radioName = radioStation.name ?? ""

        NetworkManager.shared.fetchRadioImage(url: imageURL) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.textLabel?.text = radioName
                self.imageView?.image = image
                self.setNeedsLayout()
            }
        }
    }
}

