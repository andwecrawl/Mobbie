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
        label.font = Design.Font.preRegular.midFont
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
    
    let detailButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        button.tintColor = .gray.withAlphaComponent(0.8)
        button.setImage(image, for: .normal)
        return button
    }()
    
//    lazy var photoCollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
//        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
//        return view
//    }()
    
    let buttonStackView = UIStackView()
    
    var post: Posts?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userLabel.text = ""
        timeLabel.text = "20분 전"
        contentLabel.text = "밤은깊었는데잠은안오고늘어난두통과싸우고이리저리뒤척이다생각에잠겨또펜을붙잡고밤은깊었는데잠은안오고늘어난두통과싸우고이리저리뒤척이다생각에잠겨또펜을붙잡고밤은깊었는데"
    }
    
    
    override func configureHierarchy() {
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .equalSpacing
        buttonStackView.AddArrangedSubviews([commentButton, likedButton])
        
        [
            userLabel,
            timeLabel,
            contentLabel,
            buttonStackView,
            detailButton
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
        
        detailButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(6)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
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
        
        userLabel.text = post.creator.nick
        contentLabel.text = post.content ?? ""
        timeLabel.text = post.time.parsingToDate()
    }
}
