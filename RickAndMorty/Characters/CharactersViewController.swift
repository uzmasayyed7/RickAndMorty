//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/5/24.
//

import UIKit

import UIKit
import Combine
import Resolver
import Hero
import ViewAnimator

class CharactersViewController: UIViewController {
    //UI Variable
    private var collectionView: UICollectionView!
    private let searchController = UISearchController()
    //Variables
    private var dataSource: UICollectionViewDiffableDataSource<Section, RickAndMortyCharacter>!
    private var cancellables = Set<AnyCancellable>()
    @LazyInjected private var charactersViewModel: CharactersViewModel 
    let sectionHeading : [String] = ["Alive","Dead","Unknown"]
    private let animations = [AnimationType.from(direction: .top, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureSearchController()
        setupCollectionView()
        configureDataSource()
        setViewModelListeners()
        setSearchControllerListeners()
        Task {
            await charactersViewModel.getCharacters()
        }
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
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.characterFilterSymbol, style: .plain, target: self, action: #selector(filterButtonClicked))
        title = "Characters"
    }
    
    @objc private func filterButtonClicked() {
        let characterFilterVC = CharacterFilterViewController(currentStatus: charactersViewModel.currentStatus,
                                                              currentGender: charactersViewModel.currentGender)
        characterFilterVC.filterDelegate = self
        characterFilterVC.modalPresentationStyle = .custom
        characterFilterVC.transitioningDelegate = self
        self.present(characterFilterVC, animated: true)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(hex: 0x191970)
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    
    private func setViewModelListeners() {
        Publishers.CombineLatest(charactersViewModel.isFirstLoadingPageSubject, charactersViewModel.charactersSubject).sink { [weak self] (isLoading, characters) in
            DispatchQueue.main.async {
                if isLoading {
                    self?.collectionView.setLoading()
                } else {
                    self?.collectionView.restore()
                    self?.createSnapshot(from: characters)
                    if characters.isEmpty {
                        self?.collectionView.setEmptyMessage(message: "No character found")
                    } else {
                        self?.collectionView.restore()
                    }
                }
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Collection View Data Source Configurations
extension CharactersViewController: UICollectionViewDelegate {
    fileprivate enum Section {
        case main
    }
    
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, RickAndMortyCharacter>(collectionView: collectionView) {(collectionView, indexPath, characterModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier, for: indexPath) as? CharacterCollectionViewCell
            cell?.set(with: characterModel)
            return cell
        }
        
        // Register supplementary view for section headers
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CharacterCollectionHeaderView.reuseIdentifier, for: indexPath) as? CharacterCollectionHeaderView else {
                fatalError("Failed to dequeue CharacterCollectionHeaderView")
            }
            headerView.configure(with: self.sectionHeading[indexPath.section])
            return headerView
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCharacter = charactersViewModel.charactersSubject.value[indexPath.row]
        let characterDetailVC = CharacterDetailViewController(character: currentCharacter)
        
        characterDetailVC.characterImageView.heroID = currentCharacter.uuid.uuidString
        characterDetailVC.nameLabel.heroID = currentCharacter.name
        
        showHero(characterDetailVC)
       
    }
    
    private func createSnapshot(from addedCharacters: [RickAndMortyCharacter]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RickAndMortyCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(addedCharacters)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        // Perform animations on visible cells
        collectionView.performBatchUpdates(nil, completion: { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(views: self.collectionView.visibleCells,
                           animations: self.animations,
                           completion: nil)
        })
    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let collectionViewContentSizeHeight = collectionView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (collectionViewContentSizeHeight - 100 - scrollViewHeight) {
            Task {
                await charactersViewModel.getCharacters()
            }
        }
    }
}

// MARK: - Search bar methods
extension CharactersViewController: UISearchBarDelegate {
    private func configureSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search a Character"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.backgroundColor = .gray
    }
    
    private func setSearchControllerListeners(){
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .map {
                ($0.object as! UISearchTextField).text
            }
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] (searchQuery) in
                self?.charactersViewModel.isFirstLoadingPageSubject.value = true
                Task { [weak self] in
                    await self?.getCharactersBySearchQuery(searchQuery: searchQuery ?? "")
                }
            }
            .store(in: &cancellables)
    }
    
    private func getCharactersBySearchQuery(searchQuery: String) async {
        if searchQuery.count > 2 {
            charactersViewModel.currentSearchQuery = searchQuery
            charactersViewModel.canLoadMorePages = true
            charactersViewModel.currentPage = 1
            await charactersViewModel.getCharacters()
        }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if charactersViewModel.currentSearchQuery != "" {
            Task {
                await getCharactersBySearchQuery(searchQuery: "")
            }
        }
    }
}

// MARK: - Bottom Sheet Presentation

extension CharactersViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - Filter Delegate
extension CharactersViewController: CharacterFilterDelegate {
    func didFilterTapped(selectedStatus: String, selectedGender: String) {
        charactersViewModel.currentStatus = selectedStatus
        charactersViewModel.currentGender = selectedGender
        charactersViewModel.isFirstLoadingPageSubject.value = true
        charactersViewModel.canLoadMorePages = true
        charactersViewModel.currentPage = 1
        Task {
            await charactersViewModel.getCharacters()
        }
    }
}


