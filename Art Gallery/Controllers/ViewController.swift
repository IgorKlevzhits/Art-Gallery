//
//  ViewController.swift
//  Art Gallery
//
//  Created by Игорь Клевжиц on 28.01.2025.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Artists"
        element.font = .systemFont(ofSize: 24, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var addButton: UIButton = {
        let element = UIButton(type: .system)
        element.tintColor = .black
        element.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var searchBar: UISearchBar = {
        let element = UISearchBar()
        element.searchTextField.font = .systemFont(ofSize: 16)
        element.placeholder = "Search"
        element.searchBarStyle = .minimal
        element.delegate = self
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var artistTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.dataSource = self
        element.delegate = self
        element.register(ArtistTabelViewCell.self, forCellReuseIdentifier: ArtistTabelViewCell.reuseIdentifier)
        element.separatorStyle = .none
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Private Properties
    
    private let spacing: CGFloat = 20
    
    private var dataSource: ArtistsResponse = ArtistsResponse(artists: [])
    private var filteredDataSource: ArtistsResponse = ArtistsResponse(artists: []) 
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://cdn.accelonline.io/OUR6G_IgJkCvBg5qurB2Ag/files/YPHn3cnKEk2NutI6fHK04Q.json"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let artists = try JSONDecoder().decode(ArtistsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.dataSource = artists
                    self.filteredDataSource = artists
                    self.artistTableView.reloadData()
                }
            } catch {
                print(error)
            }
            
        }.resume()

        let backImage = UIImage(systemName: "arrow.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = ""
        navigationItem.backBarButtonItem = backButtonItem
        
        view.backgroundColor = .white
        setViews()
        setupConstraints()
    }
}

extension ViewController {
    
    // MARK: - Set Views
    
    private func setViews() {
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(searchBar)
        view.addSubview(artistTableView)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor),
            
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            
            artistTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            artistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            artistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            artistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Delegate and Data Sourse for Artist Table View

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataSource.artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ArtistTabelViewCell.reuseIdentifier,
            for: indexPath)
        as! ArtistTabelViewCell
        
        let artist = filteredDataSource.artists[indexPath.row]
        cell.configureCell(with: artist)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = filteredDataSource.artists[indexPath.row]
        navigationController?.pushViewController(DetailAtristViewController(with: artist), animated: true)
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Фильтруем данные на основе текста поиска
        if searchText.isEmpty {
            filteredDataSource = dataSource  // Если строка поиска пустая, показываем все
        } else {
            filteredDataSource.artists = dataSource.artists.filter { artist in
                return artist.name.lowercased().contains(searchText.lowercased())  // Фильтрация по имени
            }
        }
        artistTableView.beginUpdates()
        artistTableView.reloadSections([0], with: .automatic)
        artistTableView.endUpdates()
    }
}

