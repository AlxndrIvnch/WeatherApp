//
//  SearchVC.swift
//  MusicApp
//
//  Created by Aleksandr on 20.07.2022.
//

import UIKit

class SearchVC: UIViewController {
    
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var searchController: UISearchController!
    
    var weatherModels = [Weather]()
    
    var longpress: UILongPressGestureRecognizer!
    var canMove: Bool = true
    
    weak var mainVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: SearchResultsTVC())
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Search location"
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(changeIsEdit(_:)))
        title = "Weather"
        
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: SearchCell.identifire, bundle: .main), forCellReuseIdentifier: SearchCell.identifire)
        tableView.reloadData()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        tableView.addGestureRecognizer(longpress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.hidesBackButton = false
    }
    
    func setup(with weatherModels: [Weather]) {
        self.weatherModels = weatherModels
    }
    
    @objc func changeIsEdit(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
        sender.title = tableView.isEditing ? "Done" : "Edit"
        if tableView.isEditing {
            tableView.removeGestureRecognizer(longpress)
        } else {
            tableView.addGestureRecognizer(longpress)
        }
        
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableView).y >= 0 ? longPress.location(in: tableView) : CGPoint(x: 0, y: 0)
        let indexPath = tableView.indexPathForRow(at: locationInView)
 
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        switch state {
        case .began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!) as! SearchCell?
                My.cellSnapshot = snapshotOfCell(cell!.contentView)
                My.cellSnapshot?.clipsToBounds = true
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.8
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        CoreDataManager.updateLocationsIndices(with: self.weatherModels.compactMap { $0.location })
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
        case .changed:
            if My.cellSnapshot != nil {
                
                My.cellSnapshot!.center.y = locationInView.y
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    
//                    guard let cell = tableView.cellForRow(at: indexPath!) else { return }
                    
//                    if indexPath!.row < Path.initialIndexPath!.row && cell.center.y > My.cellSnapshot!.center.y || indexPath!.row > Path.initialIndexPath!.row && cell.center.y < My.cellSnapshot!.center.y {
//                        weatherModels.insert(weatherModels.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
//                        tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
//                        Path.initialIndexPath = indexPath
//
//                    }
                    
                    weatherModels.insert(weatherModels.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                    tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                        Path.initialIndexPath = indexPath
                    
                }
                guard let row = indexPath?.row else { return }
                
                let top = tableView.bounds.minY + searchController.searchBar.frame.height + navigationController!.navigationBar.frame.height
               
                if My.cellSnapshot!.frame.minY < top - 10, row > 0 && canMove {
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: { () -> Void in
                        self.canMove = false
                        self.tableView.scrollToRow(at: IndexPath(row: row - 1, section: 0), at: .top, animated: false)
                    }) { self.canMove = $0 }
                }
                
                if My.cellSnapshot!.frame.maxY > tableView.bounds.maxY, row < weatherModels.count - 1 && canMove  {
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: { () -> Void in
                        self.canMove = false
                        self.tableView.scrollToRow(at: IndexPath(row: row + 1, section: 0), at: .bottom, animated: false)
                    }) { self.canMove = $0 }
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell?
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell?.center)!
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        CoreDataManager.updateLocationsIndices(with: self.weatherModels.compactMap { $0.location })
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
                })
            }
        }
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let forcast = weatherModels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifire, for: indexPath) as! SearchCell
        cell.setup(with: forcast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        weatherModels.insert(weatherModels.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        CoreDataManager.updateLocationsIndices(with: self.weatherModels.compactMap { $0.location })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mainVC.locations = self.weatherModels.compactMap { $0.location }
        mainVC.weatherModels = self.weatherModels
        mainVC.pagecontrol.currentPage = indexPath.row
        
        let weatherModel = mainVC.weatherModels[indexPath.row]
        
        if let code = weatherModel.current?.condition?.code, let isDay = weatherModel.current?.is_day == 1 ? true : false {
            mainVC.view.backgroundColor = BackgroundManager.getColor(with: code, and: isDay)
        }
        
        mainVC.collectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: false)
        navigationController?.customPop()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
            if let location = self?.weatherModels[indexPath.row].location {
                CoreDataManager.deleteLocation(location)
            }
            self?.weatherModels.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
            
        }
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = .black
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        NetworkManager.request(for: .search, with: text) { data in
            guard let data = data else { return }
            do {
                let locations = try JSONDecoder().decode([Location].self, from: data)
                let searchResultsVC = searchController.searchResultsController as! SearchResultsTVC
                searchResultsVC.searchVC = self
                searchResultsVC.locations = locations
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
}
