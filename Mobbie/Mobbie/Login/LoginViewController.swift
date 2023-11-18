//
//  LoginViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/09.
//

import UIKit

class LoginViewController: BaseViewController {

    let idTextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "아이디를 입력해 주세요."
        view.textAlignment = .center
        return view
    }()
    
    let passwordTextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "비밀번호를 입력해 주세요."
        view.textAlignment = .center
        return view
    }()
    
    let loginButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGreen
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.checkEmailValidation(email: "asd@gmail.com")
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [
            idTextField,
            passwordTextField,
            loginButton
        ]
            .forEach {
                view.addSubview($0)
            }
        
    }
    
    override func setConstraints() {
        
        idTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(passwordTextField.snp.top).inset(8)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(idTextField)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(idTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.height.equalTo(50)
        }
        
    }
    
    override func configureView() {
        
    }
    

}

