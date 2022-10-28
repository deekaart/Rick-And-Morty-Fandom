//
//  DetailVC.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: BaseViewController<DetailViewModel> {

    var character: Character?
    var info: [Section] = []

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()

        self.view.addSubview(view)

        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false

        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()

        self.scrollView.addSubview(view)

        view.axis = .vertical
        view.alignment = .center
        view.contentMode = .scaleAspectFit
        view.distribution = .equalSpacing
        view.spacing = 16

        return view
    }()

    private lazy var characterImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 300.0, height: 300.0))

        view.backgroundColor = .darkGray
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill

        return view
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        label.textColor = Colors.shared.text

        let imageWidthHeight: CGFloat = 15.0

        guard var image = UIImage(named: "alive")?.resizedImage(size: CGSize(width: 10, height: 10)) else {
            return UILabel()
        }

        guard let character = self.character else { return UILabel() }

        switch character.status {
        case .alive:
            image = image.withTintColor(.systemGreen)
        case .dead:
            image = image.withTintColor(.systemRed)
        case .unknown:
            image = image.withTintColor(.systemPurple)
        case .none:
            image = image.withTintColor(.systemPurple)
        }

        let imageAttachment = NSTextAttachment(image: image)
        imageAttachment.bounds = CGRect(x: 0, y: -0.5, width: imageWidthHeight, height: imageWidthHeight)

        let attachmentString = NSAttributedString(attachment: imageAttachment)

        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: " \(character.status?.rawValue ?? "Not Found")")
        completeText.append(textAfterIcon)

        label.textAlignment = .center
        label.attributedText = completeText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    private lazy var characterNameLabel: UILabel = {
        let view = UILabel()

        view.textColor = Colors.shared.text
        view.font = UIFont.systemFont(ofSize: 36.0, weight: .medium)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping

        return view
    }()

    private lazy var detailedInfoTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)

        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let character = self.character else { return }

        self.setupData(character: character)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupUI()
        self.setupConstraints()
    }

    private func setupConstraints() {

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.contentLayoutGuide.snp.top)
            make.left.equalTo(self.scrollView.contentLayoutGuide.snp.left)
            make.centerX.equalTo(self.scrollView.snp.centerX)
            make.bottom.equalTo(self.scrollView.contentLayoutGuide.snp.bottom)
        }

        self.characterImageView.snp.makeConstraints { make in
            make.width.height.equalTo(300.0)
        }

        self.detailedInfoTableView.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.width.equalTo(self.view.frame.width)
        }
    }

    private func setupUI() {
        self.title = "Character"
        self.view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never

        self.stackView.addArrangedSubview(self.characterImageView)
        self.stackView.addArrangedSubview(self.characterNameLabel)
        self.stackView.addArrangedSubview(self.statusLabel)
        self.stackView.addArrangedSubview(self.detailedInfoTableView)
    }

    func setupData(character: Character) {
        if let imageURL = character.image {
            self.characterImageView.kf.setImage(with: URL(string: imageURL),
                                                options: [
                                                    .processor(DownsamplingImageProcessor(size: CGSize(width: 100.0, height: 100.0))),
                                                    .scaleFactor(UIScreen.main.scale),
                                                    .cacheOriginalImage
                                                ])
        }

        self.characterNameLabel.text = character.name
        self.character = character

        self.info = self.viewModel.getCharacterInfoList(character: character)
    }

    deinit {
        print("DetailViewController DEALLOCATED")
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.info.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.info[section].title
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.appColor(.rmgreen)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.info[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.backgroundColor = UIColor.appColor(.gray)
        cell.textLabel?.textColor = UIColor.appColor(.text)

        switch self.info[indexPath.section] {
        case .gender(let value), .species(let value), .type(let value), .origin(let value):
            if value.isEmpty {
                cell.textLabel?.text = "Not Found"
            } else {
                cell.textLabel?.text = value
            }
        }

        return cell
    }
}
