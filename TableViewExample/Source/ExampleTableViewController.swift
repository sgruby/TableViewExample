//
//  ExampleTableViewController.swift
//  TableViewExample
//
//  Created by Scott Gruby on 12/3/18.
//  Copyright © 2018 Scott Gruby. All rights reserved.
//

import UIKit

public extension NSObject {
    static func className() -> String {
        return String(describing: self)
    }
}

class ExampleTableViewController: UITableViewController {
    var wordArray: [String] = []
    var cellData: [CellData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let dataPlistUrl = Bundle.main.url(forResource: "SampleData", withExtension: "plist"), let data = try? Data(contentsOf: dataPlistUrl) {
            if let plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String: Any] {
                if let words = plist?["Words"] as? [String] {
                    wordArray = words.sorted()
                }
            }
        }

        title = "Example"

        tableView.register(UINib(nibName: "ExampleTableViewCell", bundle: Bundle(for: ExampleTableViewCell.self)), forCellReuseIdentifier: ExampleTableViewCell.className())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        for _ in 0..<50 {
            let imageNumber = Int(arc4random_uniform(1000))
            let data: CellData = CellData(label1: getRandomString(), label2: getRandomString(), label3: getRandomString(), label4: getRandomString(), label5: getRandomString(), label6: getRandomString(), imageUrlString: "https://picsum.photos/300/300/?image=\(imageNumber)")
            cellData.append(data)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ExampleTableViewCell.className(), for: indexPath) as? ExampleTableViewCell {
            cell.cellWidth = tableView.frame.width
            cell.cellData = cellData[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: "")
    }

    // MARK: - View overrides

    // When rotating, the width of the cell changes so we need to adjust it.
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if let visibleCells = tableView.visibleCells as? [ExampleTableViewCell] {
            for cell in visibleCells {
                cell.cellWidth = tableView.frame.width
            }
        }
        super.willTransition(to: newCollection, with: coordinator)
    }

    // MARK: - Utility functions
    func getRandomString() -> String? {
        // Each line will contain between 0 and 5 words
        let numberWords = Int(arc4random_uniform(5))
        var randomString: String = ""
        for _ in 0..<numberWords {
            // Get a random word in the list
            let wordEntry = Int(arc4random_uniform(UInt32(wordArray.count)))
            if randomString.isEmpty == false {
                randomString += " "
            }

            randomString += wordArray[wordEntry]
        }

        return randomString.isEmpty == false ? randomString : nil
    }
}
