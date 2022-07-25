//
//  ViewController.swift
//  MusicApp
//
//  Created by Aleksandr on 15.07.2022.
//
import Alamofire
import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    var pagecontrol: UIPageControl!
    
    var locations = [Location]()
  
    var weatherModels = [Weather]() {
        didSet {
            
            weatherModels = locations.compactMap { location -> Weather? in
                let weatherModel = weatherModels.first { $0.location == location }
                return weatherModel
            }
            
            collectionView.reloadData()
            pagecontrol.numberOfPages = weatherModels.count
            
            let weatherModel = weatherModels.first
            if let code = weatherModel?.current?.condition?.code {
                self.view.backgroundColor = BackgroundManager.getColor(with: code)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupPagecontrol()
        setupCollectionView()
        setupToolbar()
        
        locations = CoreDataManager.getAllLocations()
        
        if locations.isEmpty {
            goToSearchVC()
            
        } else {
            for location in locations {
                
                NetworkManager.request(for: .forecast, with: location.getNameRegionCountryString()) { [weak self] data in
                    
                    guard let data = data, let self = self else { return }
                    
                    do {
                        let weatherModel = try JSONDecoder().decode(Weather.self, from: data)
                        var array = self.weatherModels
                        array.append(weatherModel)
                        self.weatherModels = array
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupPagecontrol() {
        pagecontrol = UIPageControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width / 2, height: 1)))
        pagecontrol.hidesForSinglePage = true
        pagecontrol.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    private func setupToolbar() {
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let list = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(goToSearchVC))
        let map = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: nil)
        let pagecontrol = UIBarButtonItem(customView: pagecontrol)
        
        let items: [UIBarButtonItem] = [map, space, pagecontrol, space, list]
        
        toolbar.items = items
        
        let appearence = UIToolbarAppearance()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor  = .secondarySystemFill.withAlphaComponent(0.4)
        toolbar.standardAppearance = appearence
    }
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc private func goToSearchVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.mainVC = self
        vc.setup(with: weatherModels)
        navigationController?.customPushFromRight(vc)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.setupCell(with: weatherModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index = Int(round(scrollView.contentOffset.x / (scrollView.frame.width)))
        pagecontrol.currentPage = index
        let weatherModel = weatherModels[index]
        guard let code = weatherModel.current?.condition?.code else { return }
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = BackgroundManager.getColor(with: code)
        }
        
    }
    
}
