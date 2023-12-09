//
//  AddPostViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/05.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

class AddPostViewController: BaseViewController, TransitionProtocol {
    
    let scrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let placeholderView = UIView()
    
    let placeholderLabel = {
        let label = UILabel()
        label.text = "무슨 일이 일어나고 있나요?"
        label.textColor = .gray.withAlphaComponent(0.6)
        label.font = Design.Font.preRegular.largeFont
        return label
    }()
    
    let textView = {
        let view = UITextView()
        view.backgroundColor = .clear
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
    
    let emptyView = UIView()
    
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
    
    let pictureButton = {
        let button = UIButton()
        let imgConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        let photo = UIImage(systemName: "photo", withConfiguration: imgConfig)
        button.setImage(photo, for: .normal)
        button.tintColor = UIColor.highlightMint
        button.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        return button
    }()
    
    let gifButton = {
        let button = UIButton()
        let imgConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        let photo = Design.Pic.gif.toImg.withRenderingMode(.alwaysTemplate)
        button.setImage(photo, for: .normal)
        button.setPreferredSymbolConfiguration(imgConfig, forImageIn: .normal)
        button.tintColor = UIColor.highlightMint
        button.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        return button
    }()
    
    let limitLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.midFont
        label.textColor = UIColor.highlightMint
        label.text = "12/200"
        return label
    }()
    
    
    let viewModel = AddPostViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.AddArrangedSubviews([placeholderView/*, emptyView*/])
        [placeholderLabel, textView].forEach { placeholderView.addSubview($0) }
        
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
        
        placeholderView.snp.makeConstraints { make in
            let height = UIScreen.main.bounds.height
            make.height.greaterThanOrEqualTo(height - 150)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        placeholderView.backgroundColor = .green
        textView.backgroundColor = .brown 
        textView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(300)
        }
        
//        emptyView.backgroundColor = .green
//        emptyView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.height.equalTo(150)
//        }
//        
        placeholderLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(textView).inset(8)
        }
    }
    
    
    
    override func configureView() {
        textView.becomeFirstResponder()
        
        let toolbar = UIToolbar()

        let pic = UIBarButtonItem(customView: pictureButton)
        let gif = UIBarButtonItem(customView: gifButton)
        let label = UIBarButtonItem(customView: limitLabel)
        label.isEnabled = true
//        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.sizeToFit()
        toolbar.setItems([pic, gif, flexibleSpaceButton, label], animated: false)
        textView.inputAccessoryView = toolbar
        
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
                    owner.view.makeToast("저장되었습니다.", position: .center)
                    owner.addButtonTapped()
                } else {
                    owner.sendOneSideAlert(title: value.1, message: "다시 시도해 주세요!")
                }
            }
            .disposed(by: disposeBag)
        
        output.text
            .bind(with: self) { owner, str in
                if str.isEmpty {
                    owner.placeholderLabel.isHidden = false
                } else {
                    owner.placeholderLabel.isHidden = true
                }
                owner.textView.textColor = .white
            }
            .disposed(by: disposeBag)
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
