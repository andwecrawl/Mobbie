//
//  IntroViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/09.
//

import UIKit
import RxSwift
import RxCocoa


final class IntroViewController: BaseViewController {
    
    private let informationLabel = {
        let label = UILabel()
        label.text = "새싹 동료들과의 소통,\n모두 Mobbie에서"
        label.font = Design.Font.preBold.exlargeFont
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "익명으로 편하게\n동료들과 소통해요!"
        label.font = Design.Font.preMedium.midFont
        label.textColor = .systemGray2
        return label
    }()
    
    private let nextButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.highlightOrange
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = Design.Font.preMedium.largeFont
        button.layer.cornerRadius = 8
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [
            informationLabel,
            nextButton,
            descriptionLabel
        ]
            .forEach({ view.addSubview($0) })
        
    }
    
    override func setConstraints() {
        
        informationLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(52)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(informationLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(informationLabel)
        }
    }
    
    override func configureView() {
        informationLabel.numberOfLines = 0
        informationLabel.setLineSpacing(lineSpacing: 6)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setLineSpacing(lineSpacing: 5)
    }
    
    func bind() {
        
        nextButton.rx.tap
            .bind { _ in
                let vc = JoinViewController()
                vc.joinType = .email
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
}
