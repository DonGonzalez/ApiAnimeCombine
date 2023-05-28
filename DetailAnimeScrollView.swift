//
//  fdgdfgfd.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import UIKit

class DetailAnimeScrollView: UIScrollView {
    
    var data: SingleAnime?
    
    init(data: SingleAnime) {
        super.init(frame: .zero)
        self.data = data
        self.config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let animeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 150, height: 200)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.textAlignment = .center
        label.isHighlighted = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createAtLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.isHighlighted = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.textAlignment = .justified
        label.isHighlighted = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let updatedAtLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.isHighlighted = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.isHighlighted = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.addArrangedSubview(createAtLabel)
        stackView.addArrangedSubview(updatedAtLabel)
        stackView.addArrangedSubview(episodeLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        createAtLabel.text = String("Created:\n\(data?.data.attributes.createdAt ?? "")")
        descriptionLabel.text = String("Description:\n\(data?.data.attributes.description ?? "")")
        updatedAtLabel.text = String("Updated:\n\(data?.data.attributes.updatedAt ?? "")")
        episodeLabel.text = String("Episode:\n\(data?.data.attributes.episodeCount ?? -1)")
        return stackView
    }()
    
    private func config() {
        titleLabel.text = data?.data.attributes.canonicalTitle
        self.addSubview(titleLabel)
        // this !! to discuss with my mentor
        animeImage.loadImage(url: (data?.data.attributes.posterImage?.tiny))
       // ?? "https://media.kitsu.io/anime/poster_images/1/tiny.jpg"
        self.addSubview(animeImage)
        self.addSubview(textStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            animeImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            animeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animeImage.widthAnchor.constraint(equalToConstant: 150),
            animeImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: animeImage.bottomAnchor, constant: 20),
            textStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textStackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20),
            textStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}

