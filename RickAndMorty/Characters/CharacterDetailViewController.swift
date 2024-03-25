//
//  CharacterDetailViewController.swift
//  RickAndMortyiOS
//
//  Created by Uzma Sayyed on 2/5/24.
//

import UIKit
import SDWebImage

class CharacterDetailViewController: UIViewController {
    //UI Variables
    @UsesAutoLayout
    var characterImageView = UIImageView()
    @UsesAutoLayout
    var nameLabel = UILabel()
    @UsesAutoLayout
    private var genderLabel = UILabel()
    @UsesAutoLayout
    private var speciesLabel = UILabel()
    @UsesAutoLayout
    private var labelsStackView = UIStackView()
    //Variables
    private var character: RickAndMortyCharacter
    
    private var episodesSectionHeaderView: UIView!
    private var episodesTableView: UITableView!
    private var episodes: [Episode] = []

    init(character: RickAndMortyCharacter) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
        configureLabels()
        configureViewLayout()
        configureNavBar()
        configureEpisodesSection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableHero()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableHero()
    }
    
    private func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = character.name
    }
    
    private func configureImage () {
        characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let imageURL = URL(string: character.imageUrl) else { return }
        characterImageView.sd_setImage(with: imageURL)
        view.addSubview(characterImageView)
    }
    
    private func configureLabels() {
        nameLabel.text = "Name: \(character.name)"
        nameLabel.font = .preferredFont(forTextStyle: .title1)
        nameLabel.textColor = .gray
        
        genderLabel.text = "Gender: \(character.gender)"
        genderLabel.font = .preferredFont(forTextStyle: .title2)
        genderLabel.textColor = .gray
        
        speciesLabel.text = "Species: \(character.species)"
        speciesLabel.font = .preferredFont(forTextStyle: .title2)
        speciesLabel.textColor = .gray
        
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .leading
        labelsStackView.spacing   = 4.0
        
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(genderLabel)
        labelsStackView.addArrangedSubview(speciesLabel)
        
        view.addSubview(labelsStackView)
    }
    
    private func configureViewLayout() {
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            labelsStackView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 8.0),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
        ])
    }
    
    private func configureEpisodesSection() {
        episodesSectionHeaderView = UIView()
        episodesSectionHeaderView.backgroundColor = .systemBackground
        let titleLabel = UILabel()
        titleLabel.text = "Episodes"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        episodesSectionHeaderView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: episodesSectionHeaderView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: episodesSectionHeaderView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: episodesSectionHeaderView.bottomAnchor, constant: -8)
        ])
        
        episodesTableView = UITableView()
        episodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.reuseIdentifier)
        episodesTableView.dataSource = self
        episodesTableView.delegate = self
        view.addSubview(episodesSectionHeaderView)
        view.addSubview(episodesTableView)
    }

//    private func fetchEpisodes() {
//        let episodesRequest = EpisodesRequest(name: "Rick", page: 1)
//        let networkClient = NetworkClient()
//
//        networkClient.sendRequest(episodesRequest) { result in
//            switch result {
//            case .success(let response):
//                print("Episodes fetched successfully:", response.data)
////                episodes = CharacterService.shared.fetchEpisodes(for: character)
//                episodesTableView.reloadData()
//            case .failure(let error):
//                print("Error fetching episodes:", error)
//            }
//        }
//
//       
//    }
    
}

extension CharacterDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.reuseIdentifier, for: indexPath) as! EpisodeTableViewCell
        
        // Configure the cell with the episode data
        let episode = episodes[indexPath.row]
        cell.configure(with: episode)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return the title for the section
        return "Episodes"
    }
}
