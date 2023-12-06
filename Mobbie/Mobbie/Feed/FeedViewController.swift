//
//  FeedViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/10.
//

import UIKit
import RxSwift
import RxMoya

final class FeedViewController: BaseViewController {
    
    private lazy var tableView = {
        let view = UITableView(frame: .zero)
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 100
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private let writeButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.highlightOrange
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 30
        button.makeShadow()
        return button
    }()
    
    var cursor: String = ""
    
    let viewModel = FeedViewModel()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func setNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes =  [
            .font: Design.Font.chab.getFonts(size: 26),
            .foregroundColor: UIColor.highlightMint
        ]
        title = "Mobbie"
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [
            tableView,
            writeButton
        ]
            .forEach { view.addSubview($0) }
        
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        writeButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(writeButton.snp.width)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        
    }
    
    func bind() {
        
        let input = FeedViewModel.Input(
            addButtonTapped: writeButton.rx.tap
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
        
        viewModel.cursor.onNext(cursor)
        
        output.addButtonTapped
            .bind(with: self) { owner, _ in
                let vc = AddPostViewController()
                vc.modalPresentationStyle = .overFullScreen
                let nav = UINavigationController(rootViewController: vc)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.getData, output.nextCursor, output.errorMessage)
            .bind(with: self) { owner, value in
                if value.0 {
                    owner.cursor = value.1
                } else {
                    owner.sendOneSideAlert(title: value.2, message: "다시 시도해 주세요!")
                }
            }
            .disposed(by: disposeBag)
            
    }
    
    /// Show the loading empty state
    private func showLoading() {
        
        var config = UIContentUnavailableConfiguration.loading()
        config.text = "Fetching content. Please wait..."
        config.textProperties.font = Design.Font.preSemiBold.largeFont
        
        self.contentUnavailableConfiguration = config
    }
    
    
}


extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier) as? FeedTableViewCell else { return UITableViewCell() }
        cell.userLabel.text = "안녕하세요?"
        return cell
    }
}
