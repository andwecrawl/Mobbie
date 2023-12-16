//
//  FeedCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/29.
//

import UIKit
import RxSwift

protocol FeedDelegate {
    func like(tag: Int, result: Bool)
    func delete(tag: Int, postID: String)
    func modifiy()
    func moveComment(tag: Int)
}

final class FeedTableViewCell: BaseTableViewCell {
    
    enum FeedTableViewCellType {
        case feed
        case detail
    }

    
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
        label.font = Design.Font.preRegular.getFonts(size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let commentButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
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
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
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
    
    let shareButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
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
    
    var type: FeedTableViewCellType?
    
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
        buttonStackView.AddArrangedSubviews([commentButton, likedButton, shareButton])
        
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
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentLabel)
            make.height.equalTo(180)
            
        }
        
        buttonStackView.spacing = 10
        buttonStackView.distribution = .equalSpacing
        buttonStackView.alignment = .leading
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp.bottom)
            make.leading.equalTo(contentLabel)
            make.trailing.equalTo(photoCollectionView).inset(100)
            make.height.equalTo(35)
            make.bottom.equalToSuperview().inset(4)
        }
        
        [commentButton, likedButton, shareButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height).multipliedBy(1.25)
            }
        }
    }
    
    override func configureView() {
        guard let type else { return }
        if type == .detail {
            contentLabel.font = Design.Font.preRegular.getFonts(size: 18)
        } else {
            contentLabel.font = Design.Font.preRegular.largeFont
        }
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
        
        userLabel.text = post.creator.nick
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
        
        let menuElement: [UIMenuElement] = [
            UIAction(title: "수정하기", image: UIImage(systemName: "pencil.line"), handler: { _ in
                self.delegate?.modifiy()
            }),
            UIAction(title: "삭제하기", image: UIImage(systemName: "trash.fill"), handler: { _ in
                self.deleteButtonTapped()
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
    
    @objc func deleteButtonTapped() {
        guard let post else { return }
        MoyaAPIManager.shared.fetchInSignProgress(.deletePost(postID: post._id), type: DeletePostResponse.self)
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    DispatchQueue.main.async {
                        owner.delegate?.delete(tag: self.tag, postID: result._id)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}

