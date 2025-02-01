//
//  DetailViewController.swift
//  Art Gallery
//
//  Created by Игорь Клевжиц on 31.01.2025.
//

import UIKit

class DetailAtristViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.alwaysBounceVertical = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var artistPhotoImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.clipsToBounds = true
        element.layer.cornerRadius = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var autorLabel: UILabel = {
        let element = UILabel()
        element.text = "Autor"
        element.textColor = .lightGray
        element.font = .systemFont(ofSize: 20)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let element = UILabel()
        element.textColor = .white
        element.font = .systemFont(ofSize: 20, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var bioLabel: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 20, weight: .bold)
        element.text = "Biography"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var bioTextLabel: UILabel = {
        let element = UILabel()
        element.textColor = .lightGray
        element.numberOfLines = 0
        element.font = .systemFont(ofSize: 20)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var worksLabel: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 20, weight: .bold)
        element.text = "Works"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var worksStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var backButton: UIButton = {
        let element = UIButton(type: .system)
        element.tintColor = .white
        element.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Private Properties
    
    private var artist: Artist?
    
    // MARK: - Private Methods
    
    @objc private func paitingTapped(_ sender: UIButton) {
        navigationController?.pushViewController(PaitingViewController(with: artist!.works[sender.tag]), animated: true)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Life Cycle
    
    init(with artist: Artist) {
        super.init(nibName: nil, bundle: nil)
        self.artist = artist
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        let backButtonItem = UIBarButtonItem()
            backButtonItem.title = ""
            navigationItem.backBarButtonItem = backButtonItem
    }
    
}

extension DetailAtristViewController {
    
    // MARK: - Set Views
    
    private func setViews() {
        
        artistPhotoImageView.image = UIImage(named: artist?.image ?? "0")
        artistNameLabel.text = artist?.name
        bioTextLabel.text = artist?.bio
        
        view.addSubview(scrollView)
        scrollView.addSubview(artistPhotoImageView)
        artistPhotoImageView.addSubview(autorLabel)
        artistPhotoImageView.addSubview(artistNameLabel)
        scrollView.addSubview(bioLabel)
        scrollView.addSubview(bioTextLabel)
        scrollView.addSubview(worksLabel)
        scrollView.addSubview(worksStackView)
        view.addSubview(backButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        for (index, work) in artist!.works.enumerated()  {
            
            let button = UIButton(type: .system)
            button.tag = index
            button.addTarget(self, action: #selector(paitingTapped), for: .touchUpInside)
            
            let imageView = UIImageView(image: UIImage(named: work.image))
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20
            imageView.contentMode = .scaleAspectFill
            
            let label = UILabel()
            label.text = work.title
            label.font = .systemFont(ofSize: 20)
            
            let spacingView = UIView()
            
            worksStackView.addArrangedSubview(imageView)
            worksStackView.addArrangedSubview(label)
            worksStackView.addArrangedSubview(spacingView)
            worksStackView.addArrangedSubview(button)
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: worksStackView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: worksStackView.trailingAnchor),
                imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
                
                label.leadingAnchor.constraint(equalTo: worksStackView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: worksStackView.trailingAnchor),
                label.heightAnchor.constraint(equalToConstant: 30),
                
                spacingView.heightAnchor.constraint(equalToConstant: 10),
                
                button.topAnchor.constraint(equalTo: imageView.topAnchor),
                button.leadingAnchor.constraint(equalTo: worksStackView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: worksStackView.trailingAnchor),
                button.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ])
        }
        
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            artistPhotoImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            artistPhotoImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            artistPhotoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            artistPhotoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            artistPhotoImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            autorLabel.leadingAnchor.constraint(equalTo: artistPhotoImageView.leadingAnchor, constant: 20),
            autorLabel.bottomAnchor.constraint(equalTo: artistPhotoImageView.bottomAnchor, constant: -30),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: artistPhotoImageView.leadingAnchor, constant: 20),
            artistNameLabel.bottomAnchor.constraint(equalTo: autorLabel.topAnchor, constant: -10),
            
            bioLabel.topAnchor.constraint(equalTo: artistPhotoImageView.bottomAnchor, constant: 30),
            bioLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            
            bioTextLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 20),
            bioTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            bioTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            
            worksLabel.topAnchor.constraint(equalTo: bioTextLabel.bottomAnchor, constant: 40),
            worksLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            
            worksStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            worksStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            worksStackView.topAnchor.constraint(equalTo: worksLabel.bottomAnchor, constant: 20),
            worksStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),

            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
        
    }
}

