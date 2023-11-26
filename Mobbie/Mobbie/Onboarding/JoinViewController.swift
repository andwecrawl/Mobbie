//
//  JoinViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/09.
//

import UIKit
import RxSwift
import RxCocoa



final class JoinViewController: BaseViewController {
    
    private let informationLabel = {
        let label = UILabel()
        label.text = "이메일을 입력해 주세요."
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "몇 자 이상 입력해 주세요!"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .systemGray2
        return label
    }()
    
    private let inputTextField = {
        let textField = UITextField()
        textField.placeholder = "무언가를 입력해 주세요!"
        textField.font = .systemFont(ofSize: 18)
        return textField
    }()
    
    private let lineView = UIView()
    
    private let nextButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGreen
        config.title = "다음으로"
        button.configuration = config
        return button
    }()
    
    private let viewModel = JoinViewModel()
    
    let disposeBag = DisposeBag()
    
    var joinType: JoinType?
    var userInfo = UserInfo(id: "", password: "", phoneNumber: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [
            informationLabel,
            descriptionLabel,
            inputTextField,
            lineView,
            nextButton
        ]
            .forEach({ view.addSubview($0) })
        
    }
    
    override func setConstraints() {
        
        informationLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(informationLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(informationLabel)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(informationLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalTo(inputTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(inputTextField)
            make.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(52)
        }
        
    }
    
    override func configureView() {
        
        informationLabel.text = joinType?.rawValue
        descriptionLabel.text = joinType?.requirement
        if joinType == .phoneNumber {
            inputTextField.isSecureTextEntry = true
        }
        lineView.backgroundColor = .gray
    }
    
    func bind() {
        
        viewModel.joinType = joinType
        
        let input = JoinViewModel.Input(
            userInput: inputTextField.rx.text.orEmpty,
            tap: nextButton.rx.tap,
            userInfo: userInfo
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
//        nextButton.rx.isEnabled
//        nextButton.rx.configuration
//        lineView.rx.backgroundColor
        output.isValid
            .bind(with: self) { owner, isValid in
                
                owner.nextButton.isEnabled = isValid
                var config = UIButton.Configuration.filled()
                config.baseBackgroundColor = isValid ? .systemGreen : .gray
                config.title = "다음으로"
                owner.nextButton.configuration = config
                
                owner.lineView.backgroundColor = isValid ? .systemGreen : .systemRed
            }
            .disposed(by: disposeBag)
        
        
        output.tap
            .bind(with: self, onNext: { owner, _ in
                
                if owner.joinType == .email {
                    
                    let vc = JoinViewController()
                    vc.joinType = .password
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if owner.joinType == .password {
                    
                    let vc = JoinViewController()
                    vc.joinType = .phoneNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let SceneDelegate = windowScene?.delegate as? SceneDelegate
                    
                    let vc = FeedViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    
                    UserDefaultsHelper.shared.haveBeenBefore = true
                    SceneDelegate?.window?.rootViewController = nav
                    SceneDelegate?.window?.makeKeyAndVisible()
                    
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    
}

