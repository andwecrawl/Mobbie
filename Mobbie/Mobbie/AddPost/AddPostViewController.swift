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
        return view
    }()
    
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
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
    }
    
    override func configureView() {
        
    }
    
    
}
