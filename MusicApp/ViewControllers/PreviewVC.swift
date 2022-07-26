//
//  PreviewVC.swift
//  MusicApp
//
//  Created by Aleksandr on 22.07.2022.
//

import UIKit

class PreviewVC: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var searchVC: SearchVC?
    weak var mapVC: MapVC?
    
    var weatherModel: Weather! {
        didSet {
            collectionView.reloadData()
            guard let code = weatherModel.current?.condition?.code else { return }
            let isDay = weatherModel.current?.is_day == 1 ? true : false 
            self.view.backgroundColor = BackgroundManager.getColor(with: code, and: isDay)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        navigationBar.standardAppearance = appearence
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    func setup(with location: Location) {

        NetworkManager.request(for: .forecast, with: location.getNameRegionCountryString()) { [weak self] (result: Result<Weather,Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let weatherModel):
                self.weatherModel = weatherModel
                if !(self.searchVC?.weatherModels.contains(where: { $0.location == weatherModel.location }) ?? true) {
                    self.navItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.addLocation))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setup(with coordinates: String) {
        NetworkManager.request(for: .forecast, with: coordinates) { [weak self] (result: Result<Weather,Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let weatherModel):
                
                guard let location = weatherModel.location else { return }
                NetworkManager.request(for: .forecast, with: location.getNameRegionCountryString()) { (result: Result<Weather,Error>) in
                    
                    switch result {
                    case .success(let weatherModel):
                        self.weatherModel = weatherModel
                        if !(self.mapVC?.weatherModels.contains(where: { $0.location == weatherModel.location }) ?? true) {
                            self.navItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.addLocation))
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true)
    }
    
    @objc func addLocation() {
       
        guard let location = weatherModel.location else { return }
        
        CoreDataManager.saveLocation(location)

        searchVC?.weatherModels.append(weatherModel)
        searchVC?.tableView.reloadData()
        searchVC?.searchController.searchBar.text?.removeAll()
        searchVC?.dismiss(animated: false)
        searchVC?.searchController.searchBar.searchTextField.resignFirstResponder()
        
        mapVC?.weatherModels.append(weatherModel)
        if let coordinates = weatherModel.location?.getCLLocation() {
            if let annotation = mapVC?.addPin(with: weatherModel.location?.name, and: coordinates) {
                mapVC?.mapView.selectAnnotation(annotation, animated: false)
            }
        }
        
        self.dismiss(animated: true)
        
    }
    
}

extension PreviewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModel == nil ? 0 : 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setupCell(with: weatherModel)
        cell.frame = view.frame
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
