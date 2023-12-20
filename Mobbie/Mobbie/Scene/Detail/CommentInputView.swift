//
//  CommentInputView.swift
//  Mobbie
//
//  Created by yeoni on 12/15/23.
//

import UIKit
import SnapKit

final class CommentInputView: UIView {
    
    let userLabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "유저닉네임이보여용"
        label.font = Design.Font.preSemiBold.midFont
        return label
    }()
    
    let capsuleView = UIView()
    
    let textView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = Design.Font.preRegular.getFonts(size: 13)
        view.textColor = .white
        view.contentInset = UIEdgeInsets(top: 1, left: 2, bottom: 2, right: 2)
        return view
    }()  
    
    let placeholderLabel = {
        let label = UILabel()
        label.text = "답글 게시하기"
        label.textColor = .lightGray
        label.font = Design.Font.preRegular.getFonts(size: 13)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        setConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureHierarchy() {
        
        capsuleView.backgroundColor = .darkGray.withAlphaComponent(0.8)
        capsuleView.layer.cornerRadius = 12
        
        [
            userLabel,
            capsuleView,
            placeholderLabel,
            textView
        ]
            .forEach { self.addSubview($0) }
        
    }
    
    func setConstraints() {
        
        userLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textView).inset(8)
            make.leading.equalTo(textView).inset(8)
        }
        
        capsuleView.snp.makeConstraints { make in
            make.size.equalTo(textView).multipliedBy(1.05)
            make.center.equalTo(textView)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configureView() {
        self.backgroundColor = .background
        userLabel.text = UserDefaultsHelper.shared.nickname
        userLabel.isHidden = true
    }
}
