//
//  SearchResultsController.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 28.10.22.
//

import UIKit

class SearchResultsController: BaseViewController<HomeViewModel> {

    var pageNumber = 0
    var filteredCharactersList: [Character] = [] {
        didSet {
            print(self.filteredCharactersList.count)

            DispatchQueue.main.async {
                self.charactersTableView.reloadData()
            }
        }
    }

    var filterOption: CharacterFilter?
    var value: String?

    lazy var charactersTableView: UITableView = {
        let view = UITableView()

        self.view.addSubview(view)

        view.delegate = self
        view.dataSource = self
        view.register(CharacterTableViewCell.self, forCellReuseIdentifier: "\(CharacterTableViewCell.self)")
        view.rowHeight = 132.0
        view.backgroundColor = .clear
        view.separatorStyle = .singleLine
        view.showsVerticalScrollIndicator = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        setupUI()
    }

    private func setupUI() {
        self.charactersTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func createFooterSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))

        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()

        return footerView
    }

    private func feedTableView(for pageNumber: Int) {
        guard self.filterOption != nil else { return }
        guard self.value != nil else { return }

        self.viewModel.fetchCharacters(by: filterOption!, value: value!, pageNumber: self.pageNumber) { [weak self] fetchedList in
//            self?.filteredCharactersList.removeAll()
            self?.filteredCharactersList.append(contentsOf: fetchedList)
            DispatchQueue.main.async {
                self?.charactersTableView.tableFooterView = nil
                self?.charactersTableView.reloadData()
            }
        }
    }

    private func pushDetailedInfoPage(for character: Character) {
        let vc = DetailViewController(vm: DetailViewModel())
        vc.character = character
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredCharactersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CharacterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setupCell(character: self.filteredCharactersList[indexPath.row])

        if indexPath.row == self.filteredCharactersList.count - 1 {
            self.charactersTableView.tableFooterView = self.createFooterSpinner()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.charactersTableView.tableFooterView = nil
            }
            self.pageNumber = self.pageNumber + 1
            self.feedTableView(for: self.pageNumber)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.pushDetailedInfoPage(for: self.filteredCharactersList[indexPath.row])
    }
}
