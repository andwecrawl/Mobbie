//
//  LoginViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/09.
//

import UIKit
import RxSwift

final class LoginViewController: BaseViewController {
    
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
        return view
    }()
    
    private let passwordTextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "비밀번호를 입력해 주세요."
        view.textAlignment = .center
        return view
    }()
    
    private let loginButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.highlightOrange
        return button
    }()
    
    let viewModel = LoginViewModel()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [
            titleLabel,
            idTextField,
            passwordTextField,
            loginButton
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
        
    }
    
    override func configureView() {
        passwordTextField.isSecureTextEntry = true
        
        bind()
    }
    
    
    func bind() {
        
        let input = LoginViewModel.Input(
            tap: loginButton.rx.tap,
            id: idTextField.rx.text.orEmpty,
            password: passwordTextField.rx.text.orEmpty
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
        output.canLogin
            .bind(with: self) { owner, value in
                owner.loginButton.isEnabled = value
                owner.loginButton.backgroundColor = value ? .highlightOrange : .gray
            }
            .disposed(by: disposeBag)
        
        output.canLogin
            .bind(with: self) { owner, login in
                
                if login {
                    
                    
                } else {
                    self.sendOneSideAlert(title: "계정을 확인해 주세요!", message: "아직 가입하지 않았거나 비밀번호가 맞지 않아요.")
                }
                
            }
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    func sendOneSideAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "okay", style: .default, handler: nil)
        alert.addAction(okay)
        present(alert, animated: true)
    }
}


#Preview("LoginViewController") {
    LoginViewController()
}
