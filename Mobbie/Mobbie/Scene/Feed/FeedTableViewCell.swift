//
//  FeedCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/29.
//

import UIKit

final class FeedTableViewCell: BaseTableViewCell {
    
    let userLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.midFont
        return label
    }()
    
    let timeLabel = {
        let label = UILabel()
        label.textColor = .gray.withAlphaComponent(0.9)
        label.font = Design.Font.preRegular.smallFont
        return label
    }()
    
    let contentLabel = {
        let label = UILabel()
        label.font = Design.Font.preRegular.getFonts(size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let commentButton = {
        let button = UIButton()
        button.titleLabel?.font = Design.Font.preLight.largeFont
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "bubble.left", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .gray.withAlphaComponent(0.9)
        return button
    }()
    
    let likedButton = {
        let button = UIButton()
        button.titleLabel?.font = Design.Font.preLight.largeFont
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let heartImage = UIImage(systemName: "heart", withConfiguration: imageConfig)
        let filledHeartImage = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
        button.setImage(heartImage, for: .normal)
        button.setImage(filledHeartImage, for: .selected)
        button.tintColor = .gray.withAlphaComponent(0.9)
        return button
    }()
    
    let settingButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        button.tintColor = .gray.withAlphaComponent(0.8)
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var photoCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: fourPicCollectionViewLayout())
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        view.dataSource = self
        return view
    }()
    
    let contentStackView = UIStackView()
    let buttonStackView = UIStackView()
    
    var post: Posts?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userLabel.text = ""
        timeLabel.text = "몇 시간 전"
        contentLabel.text = "내용이에용"
        likedButton.isSelected = false
//        photoCollectionView.isHidden = false
    }
    
    
    override func configureHierarchy() {
        
//        contentStackView.axis = .vertical
//        contentStackView.spacing = 4
//        contentStackView.distribution = .equalSpacing
//        contentStackView.AddArrangedSubviews([contentLabel, photoCollectionView])
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .equalSpacing
        buttonStackView.AddArrangedSubviews([commentButton, likedButton])
        
        [
            userLabel,
            timeLabel,
            contentLabel,
//            contentStackView,
            photoCollectionView,
            buttonStackView,
            settingButton
        ]
            .forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        userLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets).inset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userLabel)
            make.leading.equalTo(userLabel.snp.trailing).offset(6)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        photoCollectionView.backgroundColor = .green
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentLabel)
            make.height.equalTo(200)
            
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp.bottom).offset(4)
            make.leading.equalTo(contentLabel)
            make.width.equalTo(80)
            make.height.equalTo(35)
            make.bottom.equalToSuperview().inset(4)
        }
        
    }
    
    override func configureView() {
        timeLabel.text = "20분 전"
        contentLabel.text = "밤은깊었는데잠은안오고늘어난두통과싸우고이리저리뒤척이다생각에잠겨또펜을붙잡고밤은깊었는데잠은안오고늘어난두통과싸우고이리저리뒤척이다생각에잠겨또펜을붙잡고밤은깊었는데잠은안오고늘어난두통과싸우고이리저리뒤척이다생각에잠겨또펜을붙잡고밤은깊었는데잠은안오고늘어난두통과싸우고이리저리뒤척이다생각에잠겨또펜을붙잡고"
        contentLabel.setLineSpacing(lineSpacing: 4)
    }
    
    func setCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureCell() {
        guard let post else { return }
        photoCollectionView.snp.updateConstraints { make in
            make.height.equalTo(250)
        }
        photoCollectionView.isHidden = false
        print(post.image.count)
        print(post.creator.nick, post.content, post.image)
        switch post.image.count {
        case 1:
            photoCollectionView.collectionViewLayout = onePicCollectionViewLayout()
        case 2:
            photoCollectionView.collectionViewLayout = twoPicCollectionViewLayout()
        case 3:
            photoCollectionView.collectionViewLayout = threePicCollectionViewLayout()
        case 4:
            photoCollectionView.collectionViewLayout = fourPicCollectionViewLayout()
        default:
            photoCollectionView.isHidden = true
            photoCollectionView.snp.remakeConstraints{ make in
                make.top.equalTo(contentLabel.snp.bottom).offset(4)
                make.horizontalEdges.equalTo(contentLabel)
                make.height.equalTo(0)
            }
        }
        photoCollectionView.reloadData()
        
        userLabel.text = post.creator.nick
        contentLabel.text = post.content ?? ""
        timeLabel.text = post.time.parsingToDate()
        
        if post.likes.contains(UserDefaultsHelper.shared.userID) {
            likedButton.isSelected = true
        } else {
            likedButton.isSelected = false
        }
    }
}


extension FeedTableViewCell {
    
    func onePicCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingItem])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
        return layout
    }
    
    func twoPicCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1.0)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingItem, trailingItem])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section

        }
        return layout
    }
    
    func threePicCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.3)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0)),
                repeatingSubitem: trailingItem, count: 2)

            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingItem, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section

        }
        return layout
    }
    
    func fourPicCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.3)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            let leadingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0)),
                repeatingSubitem: leadingItem, count: 2)
            

            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.3)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0)),
                repeatingSubitem: trailingItem, count: 2)

            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingGroup, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section

        }
        return layout
    }
    
}


extension FeedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let post else { return 0 }
        if post.image.count > 4 {
            return 0
        }
        return post.image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        guard let post else { return UICollectionViewCell() }
        
        cell.imagePath = post.image[indexPath.item]
        cell.configureCell()
        
        return cell
    }
    
}
