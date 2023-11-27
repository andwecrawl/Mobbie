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
    
    let informationLabel = {
        let label = UILabel()
        label.text = "새싹 동료들과의 소통,\n모두 Mobbie에서"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    let descriptionLabel = {
        let label = UILabel()
        label.text = "익명으로 편하게\n동료들과 소통해요!"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .systemGray2
        return label
    }()
    
    let nextButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGreen
        config.title = "시작하기"
        button.configuration = config
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
            make.top.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(52)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(informationLabel.snp.bottom).offset(24)
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
        
        print("bind")
        nextButton.rx.tap
            .bind { _ in
                let vc = JoinViewController()
                vc.joinType = .email
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
}
