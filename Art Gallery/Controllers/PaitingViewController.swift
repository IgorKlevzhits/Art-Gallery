//
//  PaitingViewController.swift
//  Art Gallery
//
//  Created by Игорь Клевжиц on 31.01.2025.
//

import UIKit

class PaitingViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var paitingImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var paitingTitleLabel: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 20, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var infoTextLabel: UILabel = {
        let element = UILabel()
        element.textColor = .lightGray
        element.numberOfLines = 0
        element.font = .systemFont(ofSize: 20)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var expandButton: UIButton = {
        let element = UIButton(type: .system)
        element.layer.cornerRadius = 10
        element.tintColor = .white
        element.backgroundColor = .black
        element.setTitle("Развернуть", for: .normal)
        element.titleLabel?.font = .systemFont(ofSize: 20)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var closeButton: UIButton = {
        let element = UIButton(type: .system)
        element.tintColor = .black
        element.setImage(UIImage(systemName: "multiply.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        element.alpha = 0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Private Properties
    
    private var work: Work?
    private var imageWidth: CGFloat = 0
    private var imageHeight: CGFloat = 0
    private var constraints: [NSLayoutConstraint] = []
    
    // MARK: - Private Methods
    
    @objc private func expandButtonTapped(_ sender: UIButton) {
        guard let image = paitingImageView.image else { return }
        
        imageWidth = image.size.width
        imageHeight = image.size.height
        let imageViewSize = view.bounds.size
        
        UIView.animate(withDuration: 0.5, animations: {
            self.paitingTitleLabel.alpha = 0
            self.infoTextLabel.alpha = 0
            self.expandButton.alpha = 0
        }) { _ in
            self.expandImageView(imageWidth: self.imageWidth, imageHeight: self.imageHeight, imageViewSize: imageViewSize)
        }
    }

    private func expandImageView(imageWidth: CGFloat, imageHeight: CGFloat, imageViewSize: CGSize) {
        let aspectRatio = imageWidth / imageHeight
        let newWidth: CGFloat
        let newHeight: CGFloat
        
        if aspectRatio > 1 {
            newWidth = imageViewSize.width
            newHeight = imageViewSize.width * aspectRatio
        } else {
            newWidth = imageViewSize.width
            newHeight = newWidth * (imageHeight / imageWidth)
        }
        
        let centerX = imageViewSize.width / 2
        let centerY = imageViewSize.height / 2
        
        NSLayoutConstraint.deactivate(paitingImageView.constraints)
        
        NSLayoutConstraint.activate([
            paitingImageView.widthAnchor.constraint(equalToConstant: newWidth),
            paitingImageView.heightAnchor.constraint(equalToConstant: newHeight),
            paitingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paitingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            if aspectRatio > 1 {
                self.paitingImageView.transform = CGAffineTransform(rotationAngle: .pi / -2)
            } else {
                self.paitingImageView.transform = CGAffineTransform.identity
            }
            self.paitingImageView.frame = CGRect(
                x: centerX - newWidth / 2,
                y: centerY - newHeight / 2,
                width: newWidth,
                height: newHeight
            )
            self.closeButton.alpha = 1
        })
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        NSLayoutConstraint.deactivate(paitingImageView.constraints)
        setupConstraints()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.paitingImageView.transform = CGAffineTransform.identity
            
            self.closeButton.alpha = 0
            
            self.paitingImageView.frame = CGRect(
                x: 0,
                y: 0,
                width: self.view.bounds.width,
                height: self.view.bounds.height * 0.3
            )
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.paitingTitleLabel.alpha = 1
                self.infoTextLabel.alpha = 1
                self.expandButton.alpha = 1
            }
        }
    }


    
    // MARK: - Life Cycle
    
    init(with work: Work) {
        super.init(nibName: nil, bundle: nil)
        self.work = work
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setViews()
        setupConstraints()
    }
}

private extension PaitingViewController {
    
    // MARK: - Set Views
    
    func setViews() {
        
        paitingImageView.image = UIImage(named: work?.image ?? "0")
        paitingTitleLabel.text = work?.title
        infoTextLabel.text = work?.info
        
        view.addSubview(paitingImageView)
        view.addSubview(paitingTitleLabel)
        view.addSubview(infoTextLabel)
        view.addSubview(expandButton)
        view.addSubview(closeButton)
        
        
        expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

    }
    
    // MARK: - Setup Constraints
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            paitingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paitingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paitingImageView.topAnchor.constraint(equalTo: view.topAnchor),
            paitingImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            paitingTitleLabel.topAnchor.constraint(equalTo: paitingImageView.bottomAnchor, constant: 30),
            paitingTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            infoTextLabel.topAnchor.constraint(equalTo: paitingTitleLabel.bottomAnchor, constant: 20),
            infoTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            expandButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            expandButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expandButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            expandButton.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
    }
}
