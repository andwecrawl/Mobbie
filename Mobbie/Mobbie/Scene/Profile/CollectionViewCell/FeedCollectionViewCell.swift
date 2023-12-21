//
//  FeedCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit
import RxSwift

final class FeedCollectionViewCell: BaseCollectionViewCell {
    
    private let userLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.midFont
        return label
    }()
    
    private let timeLabel = {
        let label = UILabel()
        label.textColor = .gray.withAlphaComponent(0.9)
        label.font = Design.Font.preRegular.smallFont
        return label
    }()
    
    private let contentLabel = {
        let label = UILabel()
        label.font = Design.Font.preRegular.midFont
        label.numberOfLines = 0
        return label
    }()
    
    private let commentButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 11, weight: .medium)
        let image = UIImage(systemName: "bubble.left", withConfiguration: imageConfig)
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = Design.Font.preLight.smallFont
        titleContainer.foregroundColor = .gray.withAlphaComponent(0.9)
        config.attributedTitle = AttributedString("10", attributes: titleContainer)
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 4
        button.configuration = config
        button.tintColor = .gray.withAlphaComponent(0.8)
        return button
    }()
    
    let likedButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let heartImage = UIImage(systemName: "heart", withConfiguration: imageConfig)
        let filledHeart = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
        button.setImage(heartImage, for: .normal)
        button.setImage(filledHeart, for: .selected)
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = Design.Font.preLight.smallFont
        titleContainer.foregroundColor = .gray.withAlphaComponent(0.9)
        config.attributedTitle = AttributedString("10", attributes: titleContainer)
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.tintColor = .gray.withAlphaComponent(0.8)
        return button
    }()
    
    let remobbButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let image = UIImage(systemName: "arrow.2.squarepath", withConfiguration: imageConfig)
        var config = UIButton.Configuration.plain()
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.tintColor = .gray.withAlphaComponent(0.8)
        return button
    }()
    
    let shareButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig)
        var config = UIButton.Configuration.plain()
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.tintColor = .gray.withAlphaComponent(0.8)
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
    
    let buttonStackView = UIStackView()
    let disposeBag = DisposeBag()
    
    var pushed: Bool?
    var post: Post?
    var delegate: FeedDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userLabel.text = ""
        timeLabel.text = "몇 시간 전"
        contentLabel.text = "내용이에용"
        likedButton.isSelected = false
        settingButton.isHidden = false
    }
    

    override func configureHierarchy() {
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .equalSpacing
        buttonStackView.AddArrangedSubviews([commentButton, remobbButton, likedButton, shareButton])
        
        [
            userLabel,
            timeLabel,
            contentLabel,
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
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets).inset(20)
            make.leading.equalTo(userLabel.snp.trailing).offset(6)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(contentLabel)
            make.height.equalTo(180)
            
        }
        
        buttonStackView.spacing = 10
        buttonStackView.distribution = .equalSpacing
        buttonStackView.alignment = .leading
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp.bottom).offset(8)
            make.leading.equalTo(contentLabel)
            make.trailing.equalTo(photoCollectionView).inset(40)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(8)
        }
        
        [commentButton, likedButton, remobbButton, shareButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height).multipliedBy(1.25)
            }
        }
    }
    
    override func configureView() {
        timeLabel.text = "20분 전"
        contentLabel.text = "내용이에용"
        contentLabel.setLineSpacing(lineSpacing: 4)
    }
    
    func configureCell() {
        guard let post else { return }
        
        photoCollectionView.snp.updateConstraints { make in
            make.height.equalTo(220)
        }
        
        photoCollectionView.isHidden = false
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
        
        userLabel.text = post.nickname ?? "앗! 닉네임 오류!"
        contentLabel.text = post.content ?? ""
        timeLabel.text = post.time.parsingToDate()
        
        if post.likes.contains(UserDefaultsHelper.shared.userID) {
            likedButton.tintColor = .systemRed
            likedButton.isSelected = true
        } else {
            likedButton.tintColor = .gray.withAlphaComponent(0.9)
            likedButton.isSelected = false
        }
        
        var titleContainer = AttributeContainer()
        titleContainer.font = Design.Font.preLight.smallFont
        titleContainer.foregroundColor = .gray.withAlphaComponent(0.9)
        
        var likeConfig = likedButton.configuration
        let likeCount = post.likes.count
        likeConfig?.attributedTitle = likeCount == 0 ? AttributedString("  ", attributes: titleContainer) : AttributedString("\(likeCount)", attributes: titleContainer)
        likedButton.configuration = likeConfig
        
        var commentConfig = commentButton.configuration
        let commentCount = post.comments.count
        commentConfig?.attributedTitle = commentCount == 0 ? AttributedString("  ", attributes: titleContainer) : AttributedString("\(commentCount)", attributes: titleContainer)
        commentButton.configuration = commentConfig
        
        
        configureButton()
    }
    
    func configureButton() {
        guard let post else { return }
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        likedButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        let menuElement: [UIMenuElement] = [
            UIAction(title: "삭제하기", image: UIImage(systemName: "trash.fill"), handler: { _ in
                self.delegate?.delete(tag: self.tag, postID: post._id)
            }),
            UIAction(title: "공유하기", image: UIImage(systemName: "square.and.arrow.up"), handler: { _ in
                self.shareButtonTapped()
            })
        ]
        settingButton.menu = UIMenu(children: menuElement)
        settingButton.showsMenuAsPrimaryAction = true
        
        
        settingButton.isHidden = post.creator._id == UserDefaultsHelper.shared.userID ? false : true
    }
    
    @objc func commentButtonTapped() {
        delegate?.moveComment(tag: self.tag)
    }
    
    @objc func likeButtonTapped() {
        guard let post else { return }
        MoyaAPIManager.shared.fetchInSignProgress(.liked(postID: post._id), type: likedResponse.self)
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    DispatchQueue.main.async {
                        owner.delegate?.like(tag: self.tag, result: result.isSuccess)
                    }
                    print(result)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
    }
    
    
    @objc func shareButtonTapped() {
        guard let post else { return }
        var thumb = UIImage()
        if let imageURL = post.image.first {
            KingfisherHelper.shared.fetchImage(imageURL: imageURL) { image, size in
                thumb = image
            } errorHandler: { error in
                print(error)
                self.delegate?.alert(title: error.localizedDescription)
                return
            }
        } else {
            contentView.backgroundColor = .background
            thumb = contentView.asImage()
        }
        let title = "\(post.nickname ?? "")님의 게시글 공유하기"
        let content = post.content ?? ""
        
        let items = [SharePinNumberActivityItemSource(title: title, content: content, image: thumb)]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        delegate?.share(activeVC: activityVC)
    }
    
}
