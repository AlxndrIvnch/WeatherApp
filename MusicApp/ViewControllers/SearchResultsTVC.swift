//
//  SearchResultsTVC.swift
//  MusicApp
//
//  Created by Aleksandr on 20.07.2022.
//

import UIKit

class SearchResultsTVC: UITableViewController {
    
    weak var searchVC: SearchVC?
    
    var locations: [Location]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        
        if let location = locations?[indexPath.row] {
            var content = cell.defaultContentConfiguration()
            content.text = (location.name ?? "")  + ", " + (location.region ?? "")  + ", " + (location.country ?? "")
            cell.contentConfiguration = content
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let location = locations?[indexPath.row] else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let previewVC = storyboard.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
        previewVC.searchVC = self.searchVC
        previewVC.setup(with: location)
        present(previewVC, animated: true)
      
    }
}
