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
        view.scrollsToTop = true
        view.keyboardDismissMode = .onDrag
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
        container.font = Design.Font.preMedium.smallFont
        config.attributedTitle = AttributedString("게시하기", attributes: container)
        view.configuration = config
        return view
    }()
    
    private let limitLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.smallFont
        label.textColor = UIColor.highlightMint
        label.text = "0/200"
        label.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        label.textAlignment = .center
        return label
    }()
    
    private let spacer = {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(6)
        }
        return view
    }()
    
    
    let userInputView = CommentInputView()
    var post: Post? {
        didSet {
            comments = post?.comments.reversed() ?? []
        }
    }
    var comments: [Comment] = []
    var commentUsers: [String] = []
    
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkCheck.shared.completion = { vc in
            self.present(vc, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationController?.navigationItem.backBarButtonItem?.title = ""
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
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(userInputView)
            make.bottom.equalTo(userInputView.snp.top).offset(4)
        }
        
        userInputView.sizeToFit()
        userInputView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    
    override func configureView() {
        
        guard let post else { return }
        commentUsers = post.commentUser?.components(separatedBy: ", ") ?? []
        
        setToolBar()
        setRefreshControl()
        userInputView.textView.delegate = self
        
    }
    
    
    func setRefreshControl() {
        let refresh = UIRefreshControl()
        tableView.refreshControl = refresh
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    
    @objc func handleRefreshControl() {
        
        guard let post else { return }
        
        MoyaAPIManager.shared.fetchInSignProgress(.fetchSpecificPost(postID: post._id), type: Post.self)
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    DispatchQueue.main.async {
                        owner.post = result
                        owner.tableView.reloadData()
                    }
                case .failure(let error):
                    self.sendOneSideAlert(title: "새로고침에 실패했습니다.", message: "다시 시도해 주세요!")
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    
    func setToolBar() {
        
        let toolbar = UIToolbar()

        let postButton = UIBarButtonItem(customView: addButton)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let label = UIBarButtonItem(customView: limitLabel)
        let spacer = UIBarButtonItem(customView: spacer)
        label.isEnabled = true
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpaceButton, label, spacer, postButton], animated: false)
        toolbar.sizeToFit()
        
        userInputView.textView.inputAccessoryView = toolbar
    }
    
    @objc func addButtonTapped() {
        
        guard let post else { return }
        guard let text = userInputView.textView.text else { return }
        
        MoyaAPIManager.shared.fetchInSignProgress(.writeComment(postID: post._id, content: text), type: Comment.self)
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    
                    print(UserDefaultsHelper.shared.nickname)
                    owner.commentUsers.append(UserDefaultsHelper.shared.nickname)
                    MoyaAPIManager.shared.fetchInSignProgress(.modifiyPost(postID: post._id, commentUsers: owner.commentUsers.joined(separator: ", ")), type: Post.self)
                        .subscribe(with: self) { owner, response in
                            switch response {
                            case .success(let result):
                                owner.post = result
                                owner.commentUsers = result.commentNicknames
                                
                                DispatchQueue.main.async {
                                    
                                    self.tableView.reloadData()
                                    self.userInputView.textView.text = ""
                                    self.userInputView.textView.resignFirstResponder()
                                    
                                }
                            case .failure(let error):
                                print(error)
                                _ = owner.commentUsers.popLast()
                            }
                        }
                        .disposed(by: owner.disposeBag)
                    
                case .failure(let error):
                    print(error)
                    _ = owner.commentUsers.popLast()
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
                    self.userInputView.userLabel.snp.updateConstraints { make in
                        make.height.equalTo(30)
                    }
                    self.userInputView.snp.updateConstraints { make in
                        make.height.equalTo(100)
                    }
                    self.tableView.updateConstraints()
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.userInputView.transform = .identity
        if userInputView.textView.text.isEmpty {
            self.userInputView.userLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self.userInputView.snp.updateConstraints { make in
                make.height.equalTo(50)
            }
            self.tableView.updateConstraints()
        }
    }
    
}


extension DetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            
            if estimatedSize.height <= 150 {
            }
            else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
        
        userInputView.placeholderLabel.isHidden = textView.text.isEmpty ? false : true
        
        let count = userInputView.textView.text.count
        limitLabel.text = "\(count) / 150"
        limitLabel.textColor = count > 150 ? .systemRed : .highlightMint
        limitLabel.textAlignment = .right
        addButton.isEnabled = count > 150 || count == 0 ? false : true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        userInputView.placeholderLabel.isHidden = textView.text.isEmpty ? false : true
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
            
            cell.tag = index
            cell.delegate = self
            cell.postID = post._id
            cell.commentUser = commentUsers[index]
            cell.comment = self.comments[index]
            cell.configureCell()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}


extension DetailViewController: FeedDelegate {
    
    func like(tag: Int, result: Bool) {
        if result {
            post?.likes.append(UserDefaultsHelper.shared.userID)
        } else {
            guard let index = post?.likes.firstIndex(of: UserDefaultsHelper.shared.userID) else { return }
            post?.likes.remove(at: index)
        }
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func delete(tag: Int, postID: String) {
        
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
                            DispatchQueue.main.async {
                                owner.sendOneSideAlert(title: "오류가 발생했어요.", message: "다시 시도해 주세요!")
                            }
                        }
                    }
                    .disposed(by: self.disposeBag)
            })
        ])
        
    }
    
    func moveComment(tag: Int) {
        sendOneSideAlert(title: "현재 댓글창에 있어요!")
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
