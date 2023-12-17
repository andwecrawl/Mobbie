//
//  LoginViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/09.
//

import UIKit
import RxSwift

final class LoginViewController: BaseViewController, TransitionProtocol {
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Mobbie"
        label.textColor = UIColor.highlightMint
        label.font = Design.Font.chab.getFonts(size: 48)
        return label
    }()

    private let idTextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "아이디를 입력해 주세요."
        view.textAlignment = .center
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        return view
    }()
    
    private let passwordTextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "비밀번호를 입력해 주세요."
        view.textAlignment = .center
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        return view
    }()
    
    private let loginButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.highlightOrange
        return button
    }()
    
    private let signUpButton = {
        let button = UIButton()
        button.setTitle("새로운 계정 만들기", for: .normal)
        button.titleLabel?.font = Design.Font.preRegular.smallFont
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    let viewModel = LoginViewModel()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkCheck.shared.completion = { vc in
            self.present(vc, animated: true)
        }
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [
            titleLabel,
            idTextField,
            passwordTextField,
            loginButton,
            signUpButton
        ]
            .forEach {
                view.addSubview($0)
            }
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(130)
        }
        
        idTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(idTextField)
            make.top.equalTo(idTextField.snp.bottom).offset(8)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(idTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(idTextField)
            make.top.equalTo(loginButton.snp.bottom).offset(12)
            make.height.equalTo(30)
        }
        
    }
    
    override func configureView() {
        passwordTextField.isSecureTextEntry = true
        
        bind()
    }
    
    
    func bind() {
        
        let input = LoginViewModel.Input(
            loginButtonTapped: loginButton.rx.tap,
            signUpButtonTapped: signUpButton.rx.tap,
            id: idTextField.rx.text.orEmpty,
            password: passwordTextField.rx.text.orEmpty
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
        
        output.canTryLogin
            .bind(with: self) { owner, value in
                owner.loginButton.isEnabled = value
                owner.loginButton.backgroundColor = value ? .highlightOrange : .gray
            }
            .disposed(by: disposeBag)
        
        
        output.canLogin
            .bind(with: self) { owner, login in
                if login {
                    self.transitionTo(FeedViewController())
                    
                } else {
                    self.sendOneSideAlert(title: "계정을 확인해 주세요!", message: "아직 가입하지 않았거나 비밀번호가 맞지 않아요.")
                }
            }
            .disposed(by: disposeBag)

        
        output.signUpButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let vc = JoinViewController()
                vc.joinType = .email
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
