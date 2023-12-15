//
//  CommentInputView.swift
//  Mobbie
//
//  Created by yeoni on 12/15/23.
//

import UIKit
import SnapKit

final class CommentInputView: UIView {
    
    private let userLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.midFont
        return label
    }()
    
    let textView = {
        let view = UITextView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        view.font = Design.Font.preRegular.getFonts(size: 15)
        view.textColor = .white
        return view
    }()  
    
    private let placeholderLabel = {
        let label = UILabel()
        label.text = "답글 게시하기"
        label.textColor = .gray.withAlphaComponent(0.6)
        label.font = Design.Font.preRegular.getFonts(size: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureHierarchy() {
        
        [
            userLabel,
            placeholderLabel,
            textView
        ]
            .forEach { self.addSubview($0) }
    }
    
    func setConstraints() {
        userLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets).inset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(textView).inset(4)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(4)
        }
    }
    
    func configureView() {
        userLabel.text = "안뇽하세요?"
        textView.text = "hellopeople"
    }
}
