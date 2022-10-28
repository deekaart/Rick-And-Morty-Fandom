//
//  HomeViewController.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import UIKit
import SnapKit
import Kingfisher

class HomeViewController: BaseViewController<HomeViewModel> {

    private var charactersList: [Character] = [] {
        didSet {
            print("charactersList: \(charactersList.count)")
            DispatchQueue.main.async {
                self.charactersTableView.reloadData()
            }
        }
    }

    private var filteredCharactersList: [Character] = [] {
        didSet {
            print("charactersList: \(filteredCharactersList.count)")
            DispatchQueue.main.async {
                self.charactersTableView.reloadData()
            }
        }
    }
    var pageNumber = 1
    var filterPageNumber = 0
    var filterOption: CharacterFilter?
    var value: String?

    private lazy var searchResultsVC: SearchResultsController = {
        return SearchResultsController(vm: HomeViewModel())
    }()

    private lazy var searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()

    private let refreshControl = UIRefreshControl()

    private lazy var charactersTableView: UITableView = {
        let view = UITableView()

        self.view.addSubview(view)

        view.delegate = self
        view.dataSource = self
        view.register(CharacterTableViewCell.self, forCellReuseIdentifier: "\(CharacterTableViewCell.self)")
        view.rowHeight = 132.0
        view.backgroundColor = .clear
        view.separatorStyle = .singleLine
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupConstraints()
        self.setupNavBar()
        self.setupViews()
        self.feedTableView(for: self.pageNumber)
    }

    override func viewDidAppear(_ animated: Bool) {
        print(searchController.isActive)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.viewModel.cleanUpCache()
    }

    private func setupConstraints() {
        self.view.backgroundColor = .systemBackground
        
        self.charactersTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        definesPresentationContext = true

        navigationItem.searchController = searchController
        searchController.searchBar.scopeButtonTitles = CharacterFilter.allCases.map { $0.rawValue.capitalized }
        searchController.searchBar.delegate = self
    }

    private func setupViews() {
        self.refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        self.charactersTableView.addSubview(self.refreshControl)
    }

    func filterContentForSearchText(_ searchText: String,
                                    category: CharacterFilter) {
        self.filteredCharactersList = []

        self.filteredCharactersList = self.charactersList.filter { (character: Character) -> Bool in
            if isSearchBarEmpty {
                return true
            } else {
                switch category {
                case .name:
                    return character.name!.lowercased().contains(searchText.lowercased())
                case .species:
                    return character.species!.lowercased().contains(searchText.lowercased())
                case .status:
                    return character.status!.lowercased().contains(searchText.lowercased())
                case .gender:
                    return character.gender!.lowercased().contains(searchText.lowercased())
                }
            }
        }
    }

    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool {
      return searchController.isActive && (!isSearchBarEmpty)
    }

    private func feedTableView(for pageNumber: Int) {
        self.viewModel.fetchCharacters(pageNumber: pageNumber) { [weak self] fetchedList in
            self?.charactersList.append(contentsOf: fetchedList)

            DispatchQueue.main.async {
                self?.charactersTableView.tableFooterView = nil
                self?.charactersTableView.reloadData()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.refreshControl.endRefreshing()
            }
        }
    }

    private func feedTableViewByFilter(for pageNumber: Int) {
        guard let filterOption = self.filterOption else { return }
        guard let value = self.value else { return }

        self.viewModel.fetchCharacters(by: filterOption, value: value, pageNumber: self.filterPageNumber) { [weak self] fetchedList in
            self?.filteredCharactersList.append(contentsOf: fetchedList)

            DispatchQueue.main.async {
                self?.charactersTableView.tableFooterView = nil
                self?.charactersTableView.reloadData()
            }
        }
    }

    @objc func didPullToRefresh() {
        self.viewModel.cleanUpCache()
        self.charactersList.removeAll()
        self.feedTableView(for: 1)
    }

    private func createFooterSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))

        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()

        return footerView
    }

    private func pushDetailedInfoPage(for character: Character) {
        let vc = DetailViewController(vm: DetailViewModel())
        vc.character = character
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.filteredCharactersList.count
        }

        return self.charactersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CharacterTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        if isFiltering {
            cell.setupCell(character: self.filteredCharactersList[indexPath.row])

            if indexPath.row == self.filteredCharactersList.count - 1 {
                self.charactersTableView.tableFooterView = self.createFooterSpinner()
                self.filterPageNumber = self.filterPageNumber + 1
                self.feedTableViewByFilter(for: self.pageNumber)
            }
        } else {
            cell.setupCell(character: self.charactersList[indexPath.row])

            if indexPath.row == self.charactersList.count - 1 {
                self.charactersTableView.tableFooterView = self.createFooterSpinner()
                self.pageNumber = self.pageNumber + 1
                self.feedTableView(for: self.pageNumber)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.pushDetailedInfoPage(for: self.charactersList[indexPath.row])
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = CharacterFilter(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex].lowercased())
        self.filterOption = category
        self.value = searchBar.text
        self.filterPageNumber = 0
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }

    @objc func reload(_ searchBar: UISearchBar) {
        let category = CharacterFilter(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex].lowercased())
        print(searchBar.text!)
        filterContentForSearchText(searchBar.text!, category: category!)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = CharacterFilter(rawValue: searchBar.scopeButtonTitles![selectedScope].lowercased())
        self.filterOption = category
        self.value = searchBar.text
        self.filterPageNumber = 0
        self.filteredCharactersList.removeAll()
    }
}

