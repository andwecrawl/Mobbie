//
//  JoinViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/09.
//

import UIKit
import RxSwift
import RxCocoa



final class JoinViewController: BaseViewController, TransitionProtocol {
    
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
    
    private var nextButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.highlightOrange
        button.setTitle("다음으로", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let viewModel = JoinViewModel()
    
    let disposeBag = DisposeBag()
    
    var joinType: JoinType?
    var userInfo: UserInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        print("\(userInfo?.id), \(userInfo?.password), \(userInfo?.phoneNumber)")
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
            make.top.equalTo(informationLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(informationLabel)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(informationLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(44)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalTo(inputTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(inputTextField)
            make.height.equalTo(2)
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
        inputTextField.placeholder = joinType?.placeholder
        if joinType == .password {
            inputTextField.isSecureTextEntry = true
        }
        lineView.backgroundColor = .gray
    }
    
    func bind() {
        
        viewModel.joinType = joinType
        viewModel.completionHandler = { str in
            self.sendOneSideAlert(title: str, message: "다시 입력해 주세요.")
        }
        
        let input = JoinViewModel.Input(
            userInput: inputTextField.rx.text.orEmpty,
            userInfo: userInfo ?? UserInfo(id: "", password: "", phoneNumber: ""), 
            tap: nextButton.rx.tap,
            nextButtonIsEnabled: nextButton.rx.isEnabled
            
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
        Observable.combineLatest(output.isValid, output.text)
            .bind(with: self) { owner, tuple in
                if !tuple.1.isEmpty {
                    owner.nextButton.backgroundColor = tuple.0 ? .highlightOrange : .gray
                    
                    owner.lineView.backgroundColor = tuple.0 ? .highlightOrange : .systemRed
                }
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withLatestFrom(output.isValid, resultSelector: { _, isValid in
                if isValid {
                    return true
                } else {
                    return false
                }
            })
            .filter({ $0 == true })
            .withLatestFrom(output.userInfo, resultSelector: { _, value in
                return value
            })
            .bind(with: self, onNext: { owner, userInfo in
                if owner.joinType == .email {
                    
                    let vc = JoinViewController()
                    vc.joinType = .password
                    vc.userInfo = userInfo
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if owner.joinType == .password {
                    
                    let vc = JoinViewController()
                    vc.joinType = .phoneNumber
                    vc.userInfo = userInfo
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    
                    UserDefaultsHelper.shared.haveBeenBefore = true
                    
                    let vc = WelcomeViewController()
                    vc.userInfo = userInfo
                    
                    self.transitionTo(vc)
                    
                }
            })
            .disposed(by: disposeBag)
    }
}

extension JoinViewController {
    func sendOneSideAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "okay", style: .default, handler: nil)
        alert.addAction(okay)
        present(alert, animated: true)
    }
}
