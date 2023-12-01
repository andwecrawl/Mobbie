//
//  WelcomeViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

final class WelcomeViewController: BaseViewController, TransitionProtocol {
    
    private let animationView: LottieAnimationView = {
       let lottieView = LottieAnimationView(name: "congratulations")
       lottieView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
       return lottieView
    }()
    
    private let informationLabel = {
        let label = UILabel()
        label.text = "환영합니다!"
        label.font = .systemFont(ofSize: 33, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "Mobbie와 함께\n즐거운 시간 보내세요!"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .systemGray2
        return label
    }()
    
    private let nextButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.highlightOrange
        button.setTitle("시작하기", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    let viewModel = WelcomeViewModel()
    
    var userInfo: UserInfo?
    
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
            descriptionLabel,
            animationView
        ]
            .forEach({ view.addSubview($0) })
        
    }
    
    override func setConstraints() {
        
        informationLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(informationLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(informationLabel)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(52)
        }
        
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        informationLabel.numberOfLines = 0
        informationLabel.setLineSpacing(lineSpacing: 6)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setLineSpacing(lineSpacing: 5)
        
        animationView.loopMode = .playOnce
        animationView.play()
    }
    
    func bind() {
        guard let userInfo else { return }
        
        let input = WelcomeViewModel.Input(
            tap: nextButton.rx.tap,
            userInfo: userInfo
        )
        guard let output = viewModel.transform(input: input) else { return }
        
        output.tap
            .bind(with: self, onNext: { owner, _ in
                
                self.transitionTo(FeedViewController())
                
            })
            .disposed(by: disposeBag)
        
    }
    
}
