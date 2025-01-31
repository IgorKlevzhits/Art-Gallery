//
//  ArtistTabelViewCell.swift
//  Art Gallery
//
//  Created by Игорь Клевжиц on 29.01.2025.
//

import UIKit

class ArtistTabelViewCell: UITableViewCell {
    
    private lazy var photoArtistImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.layer.cornerRadius = 20
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let element = UILabel()
        element.textColor = .lightGray
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var artistBioLabel: UILabel = {
        let element = UILabel()
        element.numberOfLines = 2
        element.font = .systemFont(ofSize: 18, weight: .medium)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        photoArtistImageView.image = nil
    }
    
    func configureCell(with artist: Artist) {
        photoArtistImageView.image = UIImage(named: artist.image)
        artistNameLabel.text = artist.name
        artistBioLabel.text = artist.bio
    }
    
    private func setupLayout() {
        
        guard photoArtistImageView.superview == nil else { return }
        
        contentView.addSubview(photoArtistImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(artistBioLabel)
        
        NSLayoutConstraint.activate([
            photoArtistImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photoArtistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoArtistImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            photoArtistImageView.widthAnchor.constraint(equalTo: photoArtistImageView.heightAnchor),
            
            artistNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: photoArtistImageView.trailingAnchor, constant: 10),
            artistNameLabel.bottomAnchor.constraint(equalTo: artistBioLabel.topAnchor, constant: 10),
            
            artistBioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistBioLabel.leadingAnchor.constraint(equalTo: photoArtistImageView.trailingAnchor, constant: 10),
            artistBioLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
