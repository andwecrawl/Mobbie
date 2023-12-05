//
//  FeedViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/10.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes =  [.font: Design.Font.chab.exlargeFont]
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
