import UIKit
import MapKit
import CoreLocationUI
import AVFoundation

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var doneButton: UIButton!
    var locationButton: CLLocationButton!
    
    let locationManager = CLLocationManager()
    
    var weatherModels: [Weather]!
    
    weak var mainVC: MainVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationButton()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MKAnnotationView")
        
        mapView.delegate = self
        addPins()
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        longpress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longpress)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        mainVC.locations = self.weatherModels.compactMap { $0.location }
        mainVC.weatherModels = self.weatherModels
        if let selectedAnnotation = mapView.selectedAnnotations.first, let weatherModel = weatherModels.first(where:{ selectedAnnotation.coordinate == $0.location?.getCLLocation() ?? CLLocationCoordinate2D(latitude: 0, longitude: 0) })  {
            
            if let index = weatherModels.firstIndex(where: { $0.location == weatherModel.location }) {
                mainVC.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
            }
            if let code = weatherModel.current?.condition?.code {
                let isDay = weatherModel.current?.is_day == 1 ? true : false
                
                mainVC.view.backgroundColor = BackgroundManager.getColor(with: code, and: isDay)
            }
        }
        self.dismiss(animated: true)
    }
    
    @objc func locationButtonTapped() {
        mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)), animated: true)
    }
    
    func setup(with weatherModels: [Weather]) {
        self.weatherModels = weatherModels
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAutorization()
    }
    
    func setupLocationButton() {
        locationButton = CLLocationButton()
        view.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        locationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        locationButton.cornerRadius = 10
        locationButton.icon = .arrowFilled
        locationButton.backgroundColor = UIColor(white: 0.33, alpha: 0.8)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside )
        locationButton.isHidden = true
    }
    
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        } else {
            let alert = UIAlertController(title: "Location service is disabled", message: "Do you want to turn it on?", preferredStyle: .alert)
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
                guard let url = URL(string: "App-prefs:root=LOCATION_SERVICES") else { return }
                UIApplication.shared.open(url)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(submitAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }
    
    func checkAutorization() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            let alert = UIAlertController(title: "Location is denied", message: "Do you want to turn it on?", preferredStyle: .alert)
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
                guard let url = URL(string: "App-prefs:root=LOCATION_SERVICES") else { return }
                UIApplication.shared.open(url)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(submitAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            locationButton.isHidden = false
        @unknown default:
            break
        }
    }
    
    private func addPins() {
        for weatherModel in weatherModels {
            guard let coordinates = weatherModel.location?.getCLLocation() else { continue }
            let _ = addPin(with: weatherModel.location?.name, and: coordinates)
        }
    }
    
    func addPin(with title: String?, and coordinates: CLLocationCoordinate2D) -> MKPointAnnotation {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.title = title
        pointAnnotation.coordinate = coordinates
        mapView.addAnnotation(pointAnnotation)
        
        if coordinates == weatherModels[mainVC.pageControl.currentPage].location?.getCLLocation() {
            mapView.selectAnnotation(pointAnnotation, animated: true)
            mapView.setRegion(MKCoordinateRegion(center: pointAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)), animated: true)
        }
        
        return pointAnnotation
    }
    
    @objc func longPressGestureRecognized(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            AudioServicesPlaySystemSound(1306)
            
            let locationInView = sender.location(in: mapView)
            let coordinates = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
            let previewVC = storyboard.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
            previewVC.mapVC = self
            previewVC.setup(with: "\(coordinates.latitude),\(coordinates.longitude)")
            present(previewVC, animated: true)
        }
    }
    
}

extension MapVC: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAutorization()
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MKAnnotationView", for: annotation) as! MKMarkerAnnotationView
        
        guard let weatherModel = weatherModels.first(where: { $0.location?.getCLLocation() == annotation.coordinate }) else { return annotationView }
        
        annotationView.markerTintColor = BackgroundManager.getColor(with: weatherModel.current?.condition?.code ?? 0, and: (weatherModel.current?.is_day ?? 1).bool)
        
        annotationView.glyphImage = {
            let size: CGFloat = 1000
            
            let pointView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            pointView.backgroundColor = .clear
            
            let tempLable = UILabel(frame: pointView.bounds)
            pointView.addSubview(tempLable)
            tempLable.clipsToBounds = true
            tempLable.numberOfLines = 1
            tempLable.textAlignment = .center
            if let temp = weatherModel.current?.temp_c {
                tempLable.text = String(Int(temp)) + "°"
            }
            tempLable.font = UIFont.systemFont(ofSize: size, weight: .bold)
            tempLable.adjustsFontSizeToFitWidth = true
            
            return UIImage.image(from: pointView)
            
        }()
        
        annotationView.selectedGlyphImage = {
            let size: CGFloat = 1000
            
            let pointView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            pointView.backgroundColor = .clear
            
            let tempLable = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size * 0.4))
            pointView.addSubview(tempLable)
            
            tempLable.clipsToBounds = true
            tempLable.numberOfLines = 1
            tempLable.textAlignment = .center
            if let temp = weatherModel.current?.temp_c {
                tempLable.text = String(Int(temp)) + "°"
            }
            tempLable.font = UIFont.systemFont(ofSize: size, weight: .bold)
            tempLable.adjustsFontSizeToFitWidth = true
            
            let minMaxLable = UILabel(frame: CGRect(x: 0, y: tempLable.frame.maxY, width: size, height: size * 0.6))
            pointView.addSubview(minMaxLable)
            minMaxLable.clipsToBounds = true
            minMaxLable.numberOfLines = 0
            minMaxLable.textAlignment = .center
            minMaxLable.text = weatherModel.current?.condition?.text
            minMaxLable.font = UIFont.systemFont(ofSize: size, weight: .bold)
            minMaxLable.adjustsFontSizeToFitWidth = true
            
            return UIImage.image(from: pointView)
            
        }()
        
        return annotationView
    }
    
}
