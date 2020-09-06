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

    private var radioStations: [RadioStation]? = []

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
        NetworkManager.shared.fetchRadioStation { radioStation in
            guard let radioStation = radioStation else { return }
            self.radioStations?.append(radioStation)
            self.nonFilteredRadioStations?.append(radioStation)
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

        let radioName = stations[indexPath.row].name ?? ""
        let radioCountry = stations[indexPath.row].radioCountry ?? ""
        let radioURL = stations[indexPath.row].radioURL ?? ""
        let radioHQURL = stations[indexPath.row].radioHQURL ?? ""

        coreDataManager.saveChannel(radioName: radioName,
                                    radioCountry: radioCountry,
                                    radioURL: radioURL,
                                    radioHQURL: radioHQURL,
                                    radioImage: radioImageData,
                                    buttonTag: buttonTag)

        tableViewHandlerDelegate?.dismissTableView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "tableCell") as? RadioStationTableViewCell else { return UITableViewCell() }

        if let radioStations = radioStations {
            let imageURL = radioStations[indexPath.row].imageURL ?? ""
            let radioName = radioStations[indexPath.row].name ?? ""
            
            NetworkManager.shared.fetchRadioImage(url: imageURL) { image in
                cell.updateCell(radioImage: image, radioName: radioName)
            }
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
        imageView?.image = nil
        textLabel?.text = nil
    }

    func configurePrerequisits() {
        backgroundColor = .clear
        textLabel?.textColor = .white
        textLabel?.textAlignment = .right
        imageView?.contentMode = .scaleAspectFit
        selectionStyle = .none
    }

    func updateCell(radioImage: UIImage?, radioName: String?) {
        DispatchQueue.main.async {
            self.imageView?.image = radioImage
            self.textLabel?.text = radioName
        }
    }
}

