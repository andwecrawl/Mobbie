//
//  SettingViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/05.
//

import UIKit
import RxSwift

final class SettingViewController: BaseViewController, TransitionProtocol {
    
    let nicknameLabel = {
        let label = UILabel()
        label.text = "새콤달콤한 주전자"
        label.font = Design.Font.preSemiBold.exlargeFont
        return label
    }()
    
    let refreshButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        return button
    }()
    
    private lazy var tableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        [
            nicknameLabel,
            refreshButton,
            tableView
        ]
            .forEach { view.addSubview($0) }
        
    }
    
    override func setConstraints() {
        
        nicknameLabel.sizeToFit()
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.size.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        nicknameLabel.text = UserDefaultsHelper.shared.nickname
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    @objc func refreshButtonTapped() {
        print("refresh")
        UserDefaultsHelper.shared.nickname = Nickname.shared.makeNewNickname()
        nicknameLabel.text = UserDefaultsHelper.shared.nickname
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingList.shared.settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = SettingList.shared.settingList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        switch row {
        case 0:
            sendOneSideAlert(title: "아직 준비되지 않았어요!", message: "ㅠㅠ 열심히 만들어 볼게요")
        case 1:
            sendOneSideAlert(title: "아직 준비되지 않았어요!", message: "ㅠㅠ 열심히 만들어 볼게요")
        case 2:
            sendInteractiveAlert(title: UserDefaultsHelper.shared.nickname, message: "Mobbie에서 로그아웃하시겠어요?", choices:
            [
                UIAlertAction(title: "취소", style: .default),
                UIAlertAction(title: "로그아웃", style: .destructive, handler: { _ in
                    self.transitionTo(LoginViewController())
                })
            ])
        case 3:
            sendInteractiveAlert(title: "정말 탈퇴하시겠어요?", message: "영영 돌이킬 수 없어요... 🥺", choices:
            [
                UIAlertAction(title: "취소", style: .default),
                UIAlertAction(title: "탈퇴하기", style: .destructive, handler: { _ in
                    MoyaAPIManager.shared.fetchInSignProgress(.withdraw, type: withdrawResponse.self)
                        .subscribe(with: self) { owner, response in
                            switch response {
                            case .success(_):
                                owner.sendInteractiveAlert(title: "Mobbie", message: "다음에 또 만나요!", choices: [
                                    UIAlertAction(title: "확인", style: .default, handler: { _ in
                                        owner.transitionTo(LoginViewController())
                                    })
                                ])
                            case .failure(let error):
                                owner.sendOneSideAlert(title: "오류가 발생했어요!", message: "다시 시도해 주세용...")
                                print(error)
                            }
                        }
                        .disposed(by: self.disposeBag)
                })
            ])
        default:
            break
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    
    
}
