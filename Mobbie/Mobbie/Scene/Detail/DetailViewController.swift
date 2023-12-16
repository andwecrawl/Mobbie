//
//  DetailViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/08.
//

import UIKit
import RxSwift

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
    
    private let addButton = {
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
    
    private let limitLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.midFont
        label.textColor = UIColor.highlightMint
        label.text = "23123123/200"
        label.snp.makeConstraints { make in
            make.width.equalTo(66)
        }
        label.textAlignment = .center
        return label
    }()
    
    
    let userInputView = CommentInputView()
    let disposeBag = DisposeBag()
    var post: Posts?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
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
        
        userInputView.sizeToFit()
        userInputView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.lessThanOrEqualTo(150)
            make.height.greaterThanOrEqualTo(50)
        }
        userInputView.backgroundColor = .green
    }
    
    
    override func configureView() {
        let toolbar = UIToolbar()

        let post = UIBarButtonItem(customView: addButton)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let label = UIBarButtonItem(customView: limitLabel)
        label.isEnabled = true
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpaceButton, label, fixedSpace, post], animated: false)
        toolbar.sizeToFit()
        userInputView.textView.inputAccessoryView = toolbar
    }
    
    @objc func addButtonTapped() {
        
        guard let post else { return }
        guard let text = userInputView.textView.text else { return }
        
        MoyaAPIManager.shared.fetchInSignProgress(.writeComment(postID: post._id, content: text), type: Comment.self)
            .bind(with: self) { owner, result in
                switch result {
                case .success(let comment):
                    print(comment)
                    owner.post?.comments.append(comment)
                    let index = post.comments.count
                    DispatchQueue.main.async {
                        owner.tableView.reloadData()
                        owner.tableView.moveRow(at: IndexPath(row: NSNotFound, section: 0), to: IndexPath(row: index, section: 0))
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.userInputView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + self.view.safeAreaInsets.bottom)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.userInputView.transform = .identity
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
            
            cell.tag = 0
            cell.type = .detail
            cell.post = post
            cell.delegate = self
            cell.configureCell()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell else { return UITableViewCell() }
            guard let post else { return UITableViewCell() }
            let index = indexPath.row - 1
            let comment = post.comments
            
            cell.tag = indexPath.row - 1
            cell.delegate = self
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
        
        guard let post else { return }
        
        sendInteractiveAlert(title: "삭제하시겠습니까?", choices: [
            UIAlertAction(title: "취소", style: .default, handler: { _ in return }),
            UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                MoyaAPIManager.shared.fetchInSignProgress(.deletePost(postID: postID), type: DeletePostResponse.self)
                    .subscribe(with: self) { owner, response in
                        switch response {
                        case .success(_):
                            DispatchQueue.main.async {
                                owner.navigationController?.popViewController(animated: true)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .disposed(by: self.disposeBag)
            })
        ])
        
    }
    
    func modifiy() {
        
    }
    
    func moveComment(tag: Int) {
        sendOneSideAlert(title: "현재 댓글창에 있어요!", message: "")
    }
}


extension DetailViewController: CommentDelegate {
    func delete(tag: Int, postID: String, commentID: String) {
        guard let post else { return }
        
        // comment로 고쳐야 함
        sendInteractiveAlert(title: "삭제하시겠습니까?", choices: [
            UIAlertAction(title: "취소", style: .default, handler: { _ in return }),
            UIAlertAction(title: "삭제", style: .cancel, handler: { _ in
                MoyaAPIManager.shared.fetchInSignProgress(.deletePost(postID: postID), type: DeletePostResponse.self)
                    .subscribe(with: self) { owner, response in
                        switch response {
                        case .success(let result):
                            if post.comments[tag]._id == result._id {
                                self.post?.comments.remove(at: tag)
                                self.tableView.deleteRows(at: [IndexPath(row: tag, section: 0)], with: .automatic)
                            } else {
                                self.sendOneSideAlert(title: "댓글을 찾을 수 없습니다!")
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .disposed(by: self.disposeBag)
            })
        ])
    }
    
}
