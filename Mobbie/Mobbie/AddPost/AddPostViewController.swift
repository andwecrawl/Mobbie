//
//  AddPostViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/05.
//

import UIKit
import RxSwift
import RxCocoa

class AddPostViewController: BaseViewController, TransitionProtocol {
    
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
    
    let addButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .highlightOrange
        config.title = "게시하기"
        var container = AttributeContainer()
        container.foregroundColor = UIColor.white
        container.font = Design.Font.preMedium.midFont
        config.attributedTitle = AttributedString("게시하기", attributes: container)
        view.configuration = config
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
            make.height.greaterThanOrEqualTo(height - 150)
            make.top.horizontalEdges.equalToSuperview()
        }
        
    }
    
    override func configureView() {
        textView.becomeFirstResponder()
    }
    
    
    func bind() {
        viewModel.alert = sendOneSideAlert(title:message:)
        viewModel.transition = self
        
        let input = AddPostViewModel.Input(
            addButtonTapped: addButton.rx.tap,
            text: textView.rx.text.orEmpty
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
        Observable.combineLatest(output.isSaved, output.errorMessage)
            .bind(with: self) { owner, value in
                if value.0 { // saved
                    
                } else {
                    
                }
            }
        
        
    }
    
    override func setNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: Design.Font.preMedium.getFonts(size: 17)
        ], for: .normal)
        
        let addButton = UIBarButtonItem(customView: self.addButton)
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc func addButtonTapped() {
        // post code
        navigationController?.dismiss(animated: true)
    }
}
