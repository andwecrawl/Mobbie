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
        label.font = Design.Font.preSemiBold.exlargeFont
        return label
    }()
    
    private let validationButton = {
        let button = UIButton()
        button.setTitle("이메일 확인", for: .normal)
        button.backgroundColor = UIColor.highlightOrange
        button.layer.cornerRadius = 4
        button.titleLabel?.font = Design.Font.preRegular.smallFont
        return button
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "몇 자 이상 입력해 주세요!"
        label.font = Design.Font.preRegular.midFont
        label.numberOfLines = 0
        label.textColor = .systemGray2
        return label
    }()
    
    private let inputTextField = {
        let textField = UITextField()
        textField.placeholder = "무언가를 입력해 주세요!"
        textField.font = .systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        NetworkCheck.shared.completion = { vc in
            self.present(vc, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [
            informationLabel,
            descriptionLabel,
            inputTextField,
            lineView,
            validationButton,
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
        } else if joinType == .email {
            remakeConstraintsForValidation()
        }
        lineView.backgroundColor = .gray
    }
    
    func remakeConstraintsForValidation() {
        inputTextField.snp.remakeConstraints { make in
            make.horizontalEdges.equalTo(informationLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(44)
        }
        
        validationButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(16)
            make.trailing.equalTo(informationLabel)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
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
            validationButtonTap: validationButton.rx.tap,
            validationButtonIsEnabled: validationButton.rx.isEnabled,
            nextButtonIsEnabled: nextButton.rx.isEnabled
            
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
        output.isValid
            .bind(with: self) { owner, isValid in
                owner.validationButton.backgroundColor = isValid ? .highlightOrange : .gray
                owner.validationButton.backgroundColor = isValid ? .highlightOrange : .gray
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.isValidToNext, output.text)
            .bind(with: self) { owner, tuple in
                    owner.nextButton.backgroundColor = tuple.0 ? .highlightOrange : .gray
                
                if !tuple.1.isEmpty {
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
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + self.view.safeAreaInsets.bottom)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.nextButton.transform = .identity
    }
}
