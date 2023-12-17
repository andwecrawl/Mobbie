//
//  CommentTableViewCell.swift
//  Mobbie
//
//  Created by yeoni on 12/14/23.
//

import UIKit

protocol CommentDelegate {
    func delete(tag: Int, postID: String, commentID: String)
}

final class CommentTableViewCell: BaseTableViewCell {
    
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
    
    let settingButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        button.tintColor = .gray.withAlphaComponent(0.8)
        button.setImage(image, for: .normal)
        return button
    }()
    
    var postID: String?
    var commentUser: String?
    var comment: Comment?
    
    var delegate: CommentDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userLabel.text = ""
        timeLabel.text = "몇 시간 전"
        contentLabel.text = "내용이에용"
        settingButton.isHidden = false
    }
    
    
    override func configureHierarchy() {
        
        [
            userLabel,
            timeLabel,
            contentLabel,
            settingButton
        ]
            .forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        userLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
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
            make.bottom.equalToSuperview().inset(22)
        }
        
    }
    
    override func configureView() {
        userLabel.text = "웅냐?"
        timeLabel.text = "20분 전"
        contentLabel.text = "내용이에용"
        contentLabel.setLineSpacing(lineSpacing: 4)
        
        configureSettingButton()
    }
    
    
    func configureSettingButton() {
        
        guard let postID else { return }
        guard let comment else { return }
        
        let menuElement: [UIMenuElement] = [
            UIAction(title: "삭제하기", image: UIImage(systemName: "trash.fill"), handler: { _ in
                // 삭제하기 딜리게이트
                self.delegate?.delete(tag: self.tag, postID: postID, commentID: comment._id)
            }),
            UIAction(title: "공유하기", image: UIImage(systemName: "square.and.arrow.up"), handler: { _ in
                // 공유하깅
            })
        ]
        settingButton.menu = UIMenu(children: menuElement)
        settingButton.showsMenuAsPrimaryAction = true
    }
    
    func configureCell() {
        
        guard let commentUser else { return }
        guard let comment else { return }
        
        userLabel.text = commentUser
        timeLabel.text = comment.time.parsingToDate()
        contentLabel.text = comment.content
    }
    
}
