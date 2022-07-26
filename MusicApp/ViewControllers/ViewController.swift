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
    
    var timer: Timer?
    
    var locations = [Location]()
    
    var weatherModels = [Weather]() {
        didSet {
            
            weatherModels = locations.compactMap { location -> Weather? in
                let weatherModel = weatherModels.first { $0.location == location }
                return weatherModel
            }
            
            collectionView.reloadData()
            pagecontrol.numberOfPages = weatherModels.count
            
            guard view.backgroundColor == .black else { return }
            let weatherModel = weatherModels.first
            if let code = weatherModel?.current?.condition?.code {
                let isDay = weatherModel?.current?.is_day == 1 ? true : false
                self.view.backgroundColor = BackgroundManager.getColor(with: code, and: isDay)
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
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            
            guard let self = self else { return }
            
            NetworkManager.groupRequest(for: .forecast, with: self.locations.map({ $0.getNameRegionCountryString() })) { dataArray in
                
                for data in dataArray {
                    guard let data = data else { return }
                    do {
                        let weatherModel = try JSONDecoder().decode(Weather.self, from: data)
                        self.weatherModels.append(weatherModel)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                print("Updated")
            }
        }
        timer?.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        timer?.invalidate()
    }
    
    func setup(with models: [Weather], and locations: [Location]) {
        self.locations = locations
        self.weatherModels = models
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
        let isDay = weatherModel.current?.is_day == 1 ? true : false
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
            self.view.backgroundColor = BackgroundManager.getColor(with: code, and: isDay)
        }
        
    }
    
}
