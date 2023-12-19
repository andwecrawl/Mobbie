//
//  FeedViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/10.
//

import UIKit
import RxSwift
import RxMoya
import SideMenu
import Toast

final class FeedViewController: BaseViewController, TransitionProtocol {
    
    private lazy var tableView = {
        let view = UITableView(frame: .zero)
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 150
        view.scrollsToTop = true
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
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
        
        NetworkCheck.shared.completion = { vc in
            self.present(vc, animated: true)
        }
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cursor = ""
        viewModel.posts = []
        viewModel.cursor.onNext(cursor)
    }
    
    override func setNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes =  [
            .font: Design.Font.chab.getFonts(size: 26),
            .foregroundColor: UIColor.highlightMint
        ]
        
        title = "Mobbie"
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(settingButtonTapped))
        navigationItem.rightBarButtonItem = settingButton
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func settingButtonTapped() {
        let menu = SideMenuNavigationController(rootViewController: SettingViewController())
        menu.menuWidth = self.view.frame.width * 0.8
        present(menu, animated: true)
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
        
        setRefreshControl()
        
    }
    
    func setRefreshControl() {
        let refresh = UIRefreshControl()
        tableView.refreshControl = refresh
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        
        viewModel.posts = []
        viewModel.cursor.onNext("")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    
    func bind() {
        
        let input = FeedViewModel.Input(
            addButtonTapped: writeButton.rx.tap
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
        output.addButtonTapped
            .bind(with: self) { owner, _ in
                let vc = AddPostViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.getData, output.nextCursor, output.errorMessage)
            .bind(with: self) { owner, value in
                if value.0 {
                    owner.cursor = value.1
                    owner.tableView.reloadData()
                } else {
                    if value.2 == "expiredRefreshToken" {
                        owner.sendOneSideAlert(title: "세션이 만료되었습니다!", message: "다시 로그인해 주세요.")
                        owner.transitionTo(LoginViewController())
                    } else {
                        owner.sendOneSideAlert(title: value.2, message: "다시 시도해 주세요!")
                    }
                }
            }
            .disposed(by: disposeBag)
            
    }
    
    
}


extension FeedViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier) as? FeedTableViewCell else { return UITableViewCell() }
        
        let row = indexPath.row
        let post = viewModel.posts[row]
        
        cell.type = .feed
        cell.post = post
        cell.delegate = self
        cell.tag = row
        cell.configureCell()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let isEnd = indexPaths.contains { $0.row == viewModel.posts.count - 2 }

        if isEnd && cursor != "0" {
            viewModel.cursor.onNext(cursor)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.post = viewModel.posts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedViewController: FeedDelegate {
    func like(tag: Int, result: Bool) {
        if result {
            viewModel.posts[tag].likes.append(UserDefaultsHelper.shared.userID)
            tableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
        } else {
            let index = viewModel.posts[tag].likes.firstIndex(of: UserDefaultsHelper.shared.userID)!
            viewModel.posts[tag].likes.remove(at: index)
            tableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
        }
    }
    
    func delete(tag: Int, postID: String) {
        sendInteractiveAlert(title: "삭제하시겠습니까?", choices: [
            UIAlertAction(title: "취소", style: .default, handler: { _ in return }),
            UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                MoyaAPIManager.shared.fetchInSignProgress(.deletePost(postID: postID), type: DeletePostResponse.self)
                    .subscribe(with: self) { owner, response in
                        switch response {
                        case .success(let result):
                            if self.viewModel.posts[tag]._id == result._id {
                                self.viewModel.posts.remove(at: tag)
                                self.tableView.deleteRows(at: [IndexPath(row: tag, section: 0)], with: .automatic)
                            } else {
                                self.sendOneSideAlert(title: "포스트를 찾을 수 없습니다!")
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .disposed(by: self.disposeBag)
            })
        ])
    }
    
    func moveComment(tag: Int) {
        let vc = DetailViewController()
            // 여기서 index 오류남 고쳐야댐
        vc.post = viewModel.posts[tag]
        navigationController?.pushViewController(vc, animated: true)
    }
}
