//
//  DetailViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/08.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    private lazy var tableView = {
        let view = UITableView(frame: .zero)
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        view.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 100
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    let userInputView = CommentInputView()
    
    var post: Posts?
    
    
    override func configureHierarchy() {
        
        [
            tableView,
            userInputView
        ]
            .forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        userInputView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    override func configureView() {
        
    }
    
    
    
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let post else { return 0 }
        return 1 + post.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier) as? FeedTableViewCell else { return UITableViewCell() }
            
            cell.post = post
            cell.configureCell()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell else { return UITableViewCell() }
            guard let post else { return UITableViewCell() }
            let index = indexPath.row - 1
            let comment = post.comments
            
            cell.postID = post._id
            cell.comment = comment[index]
            
            return cell
        }
    }
    
}


extension DetailViewController: FeedDelegate {
    func like(tag: Int, result: Bool) {
        
        
    }
    
    func delete(tag: Int, postID: String) {
        
        
    }
    
    func modifiy() {
        
    }
    
    func moveComment(tag: Int) {
        sendOneSideAlert(title: "현재 댓글창에 있어요!", message: "")
    }
}

