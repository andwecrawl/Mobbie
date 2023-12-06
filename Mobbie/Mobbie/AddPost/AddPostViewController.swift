//
//  AddPostViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/05.
//

import UIKit

class AddPostViewController: BaseViewController {
    
    let scrollView = {
        let view = UIScrollView()
        view.indicatorStyle = .white
        return view
    }()
    
    let textView = {
        let view = UITextView()
        view.returnKeyType = .default
        view.keyboardAppearance = .dark
        view.keyboardDismissMode = .onDrag
        view.borderStyle = .none
        view.textColor = .white
        view.font = Design.Font.preRegular.largeFont
        view.becomeFirstResponder()
        view.sizeToFit()
        return view
    }()
    
    let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.backgroundColor = .clear
        return view
    }()
    
    let viewModel = AddPostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(textView)
        
    }
    
    override func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.distribution = .fill
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        textView.sizeToFit()
        textView.snp.makeConstraints { make in
            let height = UIScreen.main.bounds.height
            make.height.greaterThanOrEqualTo(height - 300)
            make.top.horizontalEdges.equalToSuperview()
        }
        
    }
    
    override func configureView() {
        textView.becomeFirstResponder()
    }
    
    func bind() {
        let input = AddPostViewModel.Input(
            
        )
        
        let output = viewModel.transform(input: input)
        
    }
    
    override func setNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addButtonTapped() {
        // post code
        navigationController?.popViewController(animated: true)
    }
    
}
