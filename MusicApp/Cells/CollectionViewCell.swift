//
//  CollectionViewCell.swift
//  MusicApp
//
//  Created by Aleksandr on 18.07.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    var weatherModel: Weather?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cityNameLable: UILabel!
    @IBOutlet weak var degreeLable: UILabel!
    @IBOutlet weak var disciptionLable: UILabel!
    @IBOutlet weak var symbolLable: UILabel!
    
    @IBOutlet weak var headerViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var topLableVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    
    var headerHight: CGFloat = 300
    var collectionViewTopConstant: CGFloat {
        get {
            headerHight + 20
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        
        register()
        setupViews()
        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
    }
    
    func setupCell(with model: Weather) {
        self.weatherModel = model
        self.awakeFromNib()
    }
    
    private func setupViews() {
        headerViewHight.constant = headerHight
        
        topLableVerticalConstraint.constant = -headerHight * 0.3
        
        collectionViewTopConstraint.constant = collectionViewTopConstant
        collectionView.layer.cornerRadius = 20
        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        cityNameLable.text = weatherModel?.location?.name
        cityNameLable.font = UIFont.systemFont(ofSize: headerHight / 7, weight: .light)
        
        degreeLable.text = "\(Int(weatherModel?.current?.temp_c ?? 0))"
        degreeLable.font = UIFont.systemFont(ofSize: headerHight / 3, weight: .light)
        degreeLable.textColor = .white
        
        symbolLable.text = "°"
        symbolLable.font = UIFont.systemFont(ofSize: headerHight / 3, weight: .light)
        symbolLable.textColor = .white
        
        disciptionLable.text = "\(weatherModel?.current?.condition?.text ?? "")\nMax: 27°, min: 14°"
        disciptionLable.font = UIFont.systemFont(ofSize: headerHight / 15, weight: .light)
        disciptionLable.textColor = .white
        
    }
    
    private func register() {
        collectionView.register(UINib(nibName: HourForecastCell.identifire, bundle: .main), forCellWithReuseIdentifier: HourForecastCell.identifire)
        collectionView.register(UINib(nibName: DayForecastCell.identifire, bundle: .main), forCellWithReuseIdentifier: DayForecastCell.identifire)
        collectionView.register(UINib(nibName: CurrentWeatherCell.identifire, bundle: .main), forCellWithReuseIdentifier: CurrentWeatherCell.identifire)
        collectionView.register(UINib(nibName: UvCell.identifire, bundle: .main), forCellWithReuseIdentifier: UvCell.identifire)
    }
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .hourForecast(let hourForecast):
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourForecastCell.identifire, for: indexPath) as? HourForecastCell else { fatalError() }
                
                cell.setup(with: hourForecast)
                return cell
                
            case .dayForecast(let dayForecast):
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayForecastCell.identifire, for: indexPath) as? DayForecastCell else { fatalError() }
                
                let location = self?.weatherModel?.location
                cell.setup(with: dayForecast, and: location)
                return cell
                
            case .current(let currentWeather):
                
                switch currentWeather {
                case 0:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UvCell.identifire, for: indexPath) as? UvCell else { fatalError() }
                    
                    guard let current = self?.weatherModel?.current else { fatalError() }
                    cell.setup(with: current)
                    
                    return cell
                default:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.identifire, for: indexPath) as? CurrentWeatherCell else { fatalError() }
                    
                    guard let current = self?.weatherModel?.current else { fatalError() }
                    cell.setup(with: current, and: currentWeather)
                    
                    return cell
                }
                
            }
            
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        snapshot.appendSections([.horizontalList, .verticalList, .grid2])
        
        if var hoursForecast = weatherModel?.forecast?.forecastday?.first?.hour {
            
            let date = weatherModel?.location?.getDate()
            let currentHour = date?.hour ?? 100
            
            let sunrise = weatherModel?.forecast?.forecastday?.first?.astro?.getDate(for: .sunrise)?.time ?? Time(0, 0)
            let sunset = weatherModel?.forecast?.forecastday?.first?.astro?.getDate(for: .sunset)?.time ?? Time(0, 0)
            let nextDaySunrise = weatherModel?.forecast?.forecastday?[1].astro?.getDate(for: .sunrise)?.time ?? Time(0, 0)
            let nextDaySunset = weatherModel?.forecast?.forecastday?[1].astro?.getDate(for: .sunset)?.time ?? Time(0, 0)
            
            let sunriseTimeString = "\(sunrise.hour):\(sunrise.minute)"
            let sunsetTimeString = "\(sunset.hour):\(sunset.minute)"
            let nextDaySunriseTimeString = "\(nextDaySunrise.hour):\(nextDaySunrise.minute)"
            let nextDaySunsetTimeString = "\(nextDaySunset.hour):\(nextDaySunset.minute)"
            
            if let sunriseIndex = hoursForecast.firstIndex(where: { sunrise < ($0.getDate()?.time ?? Time(0, 0)) }) {
                hoursForecast.insert(HourForecast(time: "\(sunriseTimeString)", condition: Condition(code: nil, icon: "sunrise.fill", text: "Sunrise"), temp_c: nil, is_day: nil, chance_of_rain: nil, chance_of_snow: nil), at: sunriseIndex)
            }
            
            if let sunsetIndex = hoursForecast.firstIndex(where: { sunset < ($0.getDate()?.time ?? Time(0, 0)) }) {
                hoursForecast.insert(HourForecast(time: "\(sunsetTimeString)", condition: Condition(code: nil, icon: "sunset.fill", text: "Sunset"), temp_c: nil, is_day: nil, chance_of_rain: nil, chance_of_snow: nil), at: sunsetIndex)
            }
            
            var hoursForecastFromCurrentTime = hoursForecast.filter { forecast in
                return forecast.getDate()?.time.hour ?? -1 >= currentHour
            }
            
            if var nextDayHoursForecast = weatherModel?.forecast?.forecastday?[1].hour {
                
                if let nextDaySunriseIndex = nextDayHoursForecast.firstIndex(where: { nextDaySunrise < ($0.getDate()?.time ?? Time(0, 0)) }) {
                    nextDayHoursForecast.insert(HourForecast(time: "\(nextDaySunriseTimeString)", condition: Condition(code: nil, icon: "sunrise.fill", text: "Sunrise"), temp_c: nil, is_day: nil, chance_of_rain: nil, chance_of_snow: nil), at: nextDaySunriseIndex)
                }
                
                if let nextDaySunsetIndex = nextDayHoursForecast.firstIndex(where: { nextDaySunset < ($0.getDate()?.time ?? Time(0, 0)) }) {
                    nextDayHoursForecast.insert(HourForecast(time: "\(nextDaySunsetTimeString)", condition: Condition(code: nil, icon: "sunset.fill", text: "Sunset"), temp_c: nil, is_day: nil, chance_of_rain: nil, chance_of_snow: nil), at: nextDaySunsetIndex)
                }
                
                hoursForecastFromCurrentTime.append(contentsOf: nextDayHoursForecast.filter { forecast in
                    let hour = forecast.getDate()?.time.hour ?? -1
                    return hour < currentHour
                })
            }
            
            hoursForecastFromCurrentTime[0].setCurrent()
            
            let hourForecastItems = hoursForecastFromCurrentTime.map({ hourForecast -> ItemType in
                return ItemType.hourForecast(hourForecast)
            })
            snapshot.appendItems(hourForecastItems, toSection: .horizontalList)
        }
        
        if let daysForecast = weatherModel?.forecast?.forecastday {
            let dayForecastItems = daysForecast.map({ dayForecast -> ItemType in
                return ItemType.dayForecast(dayForecast)
            })
            snapshot.appendItems(dayForecastItems, toSection: .verticalList)
        }
        
        if let _ = weatherModel?.current {
            
            let items = [0, 1, 2, 3, 4, 5, 6].map { number in
                return ItemType.current(number)
            }
            snapshot.appendItems(items, toSection: .grid2)
        }
        
        dataSource.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, layoutEnvirnment) -> NSCollectionLayoutSection? in
            let section = SectionType(rawValue: sectionIndex)!
            switch section {
            case .horizontalList:
                return self?.createHorizontalListSection()
            case .verticalList:
                return self?.createVerticalListSection()
            case .grid2:
                return self?.createGrid2Section()
            }
        }, configuration: config)
        
        layout.register(RoundedBackgroundView.self, forDecorationViewOfKind: RoundedBackgroundView.identifier)
        
        return layout
        
    }
    
    private func createHorizontalListSection() -> NSCollectionLayoutSection  {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: RoundedBackgroundView.identifier)]
        
        return section
    }
    
    private func createVerticalListSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: RoundedBackgroundView.identifier)]
        
        return section
    }
    
    private func createGrid2Section() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return section
    }
    
}

extension CollectionViewCell: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = collectionView.contentOffset.y
        
        guard offset < headerHight else { return }
        
        let decreaseAlphaMin: CGFloat = 60
        let decreaseAlphaMax: CGFloat = 160
        let increaseAlphaMax: CGFloat = 180
        let moveCollectionViewMin: CGFloat = 0
        let moveCollectionViewMax: CGFloat = 200
        
        degreeLable.text = offset <= 160 ? "\(Int(weatherModel?.current?.temp_c ?? 0))" : "\(Int(weatherModel?.current?.temp_c ?? 0))° | \(weatherModel?.current?.condition?.text ?? "")"
        degreeLable.font = offset <= 160 ? UIFont.systemFont(ofSize: headerHight / 3, weight: .light) : UIFont.systemFont(ofSize: 16, weight: .light)
        
        if offset >= moveCollectionViewMin, offset <= moveCollectionViewMax  { //move collectionView
            self.collectionViewTopConstraint.constant = self.collectionViewTopConstant - offset
            
            
        } else {
            self.degreeLable.textColor = offset < moveCollectionViewMin ? .white.withAlphaComponent(1) : .white.withAlphaComponent(0)
            self.symbolLable.textColor = offset < moveCollectionViewMin ? .white.withAlphaComponent(1) : .white.withAlphaComponent(0)
            self.disciptionLable.textColor = offset < moveCollectionViewMin ? .white.withAlphaComponent(1) : .white.withAlphaComponent(0)
        }
        
        if offset > moveCollectionViewMax {
            self.collectionViewTopConstraint.constant = self.collectionViewTopConstant - moveCollectionViewMax
        }
        
        if offset < moveCollectionViewMin {
            self.collectionViewTopConstraint.constant = self.collectionViewTopConstant
        }
        
        if offset >= decreaseAlphaMin, offset <= decreaseAlphaMax {
            let alpha = (1 - ((offset - decreaseAlphaMin) / (decreaseAlphaMax - decreaseAlphaMin)))
            
            self.symbolLable.textColor = .white.withAlphaComponent(alpha)
            self.degreeLable.textColor = .white.withAlphaComponent(alpha)
            self.disciptionLable.textColor = .white.withAlphaComponent(alpha)
            
        }
        
        if offset > decreaseAlphaMax {
            let alpha = offset <= increaseAlphaMax ? ((offset - decreaseAlphaMax) / (increaseAlphaMax - decreaseAlphaMax)) :  1
            
            self.disciptionLable.textColor = .white.withAlphaComponent(0)
            self.degreeLable.textColor = .white.withAlphaComponent(alpha)
            
        }
        
        if offset <= decreaseAlphaMin { // move header
            self.headerViewHight.constant = self.headerHight - offset * 0.5
        }
        
    }
    
}

extension CollectionViewCell {
    
    enum SectionType: Int {
        case horizontalList
        case verticalList
        case grid2
    }
    
    enum ItemType: Hashable {
        case hourForecast(HourForecast)
        case dayForecast(DayForecastGroup)
        case current(Int)
    }
    
    enum CurrentWeatherType: Hashable {
        case uvIndex
    }
}
