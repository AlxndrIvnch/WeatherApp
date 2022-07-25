//
//  RoundedBackgroundView.swift
//  MusicApp
//
//  Created by Aleksandr on 20.07.2022.
//

import UIKit

class RoundedBackgroundView: UICollectionReusableView {
    static let identifier = "RoundedBackgroundView"
    
    private var insetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.4629999995, green: 0.4629999995, blue: 0.5019999743, alpha: 0.4)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(insetView)

        NSLayoutConstraint.activate([
            insetView.leadingAnchor.constraint(equalTo: leadingAnchor),
            insetView.trailingAnchor.constraint(equalTo: trailingAnchor),
            insetView.topAnchor.constraint(equalTo: topAnchor),
            insetView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
