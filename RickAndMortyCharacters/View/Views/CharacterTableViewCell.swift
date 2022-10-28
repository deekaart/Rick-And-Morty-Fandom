//
//  CharacterTableViewCell.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import UIKit
import SnapKit
import Kingfisher

private enum LabelKeys: String {
    case name = "Name"
    case status = "Status"
    case species = "Species"
    case gender = "Gender"
}

class CharacterTableViewCell: UITableViewCell {

    private lazy var characterImage: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0))

        self.contentView.addSubview(view)

        view.backgroundColor = .systemGray
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = view.frame.height / 2

        return view
    }()

    private lazy var infoStackView: UIStackView = {
        let view = UIStackView()

        self.contentView.addSubview(view)

        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 8

        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = Colors.shared.text
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()

        label.textColor = Colors.shared.text
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        return label
    }()

    private lazy var speciesLabel: UILabel = {
        let label = UILabel()

        label.textColor = Colors.shared.text
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        return label
    }()

    private lazy var genderLabel: UILabel = {
        let label = UILabel()

        label.textColor = Colors.shared.text
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        return label
    }()

    private lazy var chevronImage: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 16.0, height: 16.0))

        self.contentView.addSubview(view)

        view.image = UIImage(named: "ic-forward")?.withTintColor(UIColor.appColor(.rmgreen) ?? .systemGreen)
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor.appColor(.rmgreen)

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCellConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCellConstraints() {
        self.backgroundColor = .clear
        self.infoStackView.addArrangedSubview(self.nameLabel)
        self.infoStackView.addArrangedSubview(self.statusLabel)
        self.infoStackView.addArrangedSubview(self.speciesLabel)
        self.infoStackView.addArrangedSubview(self.genderLabel)

        self.characterImage.snp.makeConstraints { make in
            make.width.height.equalTo(100.0)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(16.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }

        self.infoStackView.snp.makeConstraints { make in
            make.left.equalTo(self.characterImage.snp.right).offset(16)
            make.right.lessThanOrEqualTo(self.chevronImage.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }

        self.chevronImage.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

    func setupCell(character: Character) {
        self.nameLabel.attributedText = makeUpAttributedText(from: character.name, labelKey: .name)
        self.statusLabel.attributedText = makeUpAttributedText(from: character.status?.rawValue, labelKey: .status)
        self.speciesLabel.attributedText = makeUpAttributedText(from: character.species, labelKey: .species)
        self.genderLabel.attributedText = makeUpAttributedText(from: character.gender?.rawValue, labelKey: .gender)
        
        if let imageURL = character.image {
            self.characterImage.kf.setImage(with: URL(string: imageURL),
                                            options: [
                                                .processor(DownsamplingImageProcessor(size: CGSize(width: 100.0, height: 100.0))),
                                                .scaleFactor(UIScreen.main.scale),
                                                .cacheOriginalImage
                                            ])
        }
    }

    private func makeUpAttributedText(from string: String?, labelKey: LabelKeys) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: "\(labelKey.rawValue): ", attributes: [
            .font : UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.appColor(.rmgreen) ?? UIColor.systemGreen
        ])

        attrStr.append(NSAttributedString(string: string ?? "Not Found"))

        return attrStr
    }

}
