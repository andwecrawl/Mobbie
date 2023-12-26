//
//  UserViewController.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit
import RxSwift
import RxCocoa

enum ProfileCellType {
    case feed
    case media
    case liked
}

class UserViewController: BaseViewController {
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.register(NicknameCell.self, forCellWithReuseIdentifier: NicknameCell.identifier)
        view.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        view.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        view.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    var nextCursor = ""
    var ratios: [CGFloat] = []
    var cellType: ProfileCellType?
    var cellData: [Post] = []
    
    let disposeBag = DisposeBag()
    
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
        sendCellType(cellType ?? .feed)
    }
    
    
}


extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return cellData.count // post 갯수로 변경
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let item = indexPath.item
        
        if section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NicknameCell.identifier, for: indexPath) as? NicknameCell else { return UICollectionViewCell() }
            
            return cell
        } else if cellType == .feed {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }
            
            let post = cellData[item]
            cell.delegate = self
            cell.post = post
            cell.configureCell()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else { return UICollectionViewCell() }
            
            print("==================================")
            print("cellData: \(cellData.count), cell: \(item)")
            let post = cellData[item]
            cell.configureCell(post: post)
            cell.backgroundColor = .yellow
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
                return UICollectionReusableView()
            }
            header.delegate = self
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let cellType = cellType ?? .feed
        print("layout ...")
        return UICollectionViewCompositionalLayout { (sectionNumber, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(112)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                return section
                
            } else if sectionNumber == 1 && cellType == .media {
                
                if self.ratios.isEmpty {
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(100))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
                    // 수직 스크롤에 대한 대응까지는 온 상태!!
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
                    group.interItemSpacing = .fixed(10)
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                    section.interGroupSpacing = 10
                    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                  heightDimension: .estimated(44))
                    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerFooterSize,
                        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                    sectionHeader.pinToVisibleBounds = true
                    section.boundarySupplementaryItems = [sectionHeader]
                    section.orthogonalScrollingBehavior = .none
                    
                    return section
                } else {
                    let ratios = self.ratios.map { Ratio(ratio: $0) }
                    return MediaLayout(columnsCount: 2, itemRatios: ratios, spacing: 10, contentWidth: self.view.frame.width).section
                }
                
            } else { // feed
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                             heightDimension: .estimated(44))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                sectionHeader.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [sectionHeader]
                section.orthogonalScrollingBehavior = .none
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                return section
            }
        }
    }
}

extension UserViewController: HeaderViewDelegate {
    func sendCellType(_ cellType: ProfileCellType) {
        self.cellType = cellType
        collectionView.collectionViewLayout = createLayout()
        fetchData(cellType)
//        viewModel.cellType.accept(cellType)
    }
    
    
    func fetchData(_ cellType: ProfileCellType) {
        switch cellType {
        case .feed:
            MoyaAPIManager.shared.fetchInSignProgress(.fetchMyPosts(userID: UserDefaultsHelper.shared.userID, cursor: nextCursor), type: PostResponse.self)
                .subscribe(with: self) { owner, response in
                    switch response {
                        
                    case .success(let result):
                        print(result)
                        owner.cellData = result.data
                        owner.nextCursor = result.nextCursor
                        owner.collectionView.reloadData()
                    case .failure(let error):
                        owner.sendOneSideAlert(title: error.localizedDescription, message: "다시 시도해 주세요!")
                    }
                }
                .disposed(by: disposeBag)
            
        case .media:
            
            let group = DispatchGroup()
            
            group.enter()
            MoyaAPIManager.shared.fetchInSignProgress(.fetchMyPosts(userID: UserDefaultsHelper.shared.userID, cursor: nextCursor), type: PostResponse.self)
                    .subscribe(with: self) { owner, response in
                        switch response {
                            
                        case .success(let result):
                            let data = result.data.filter { $0.image.count > 0 }
                            let ratios = data.map {
                                CGFloat((($0.ratio ?? "") as NSString).floatValue) }
                            owner.ratios = ratios
                            owner.nextCursor = result.nextCursor
                            owner.cellData = data
                            owner.collectionView.reloadData()
                        case .failure(let error):
                            owner.sendOneSideAlert(title: error.localizedDescription, message: "다시 시도해 주세요!")
                        }
                    }
                    .disposed(by: disposeBag)
            
        case .liked:
            MoyaAPIManager.shared.fetchInSignProgress(.fetchPostUserLiked, type: PostResponse.self)
                .subscribe(with: self) { owner, response in
                    switch response {
                        
                    case .success(let result):
                        owner.cellData = result.data
                        owner.nextCursor = result.nextCursor
                        owner.collectionView.reloadData()
                    case .failure(let error):
                        owner.sendOneSideAlert(title: error.localizedDescription, message: "다시 시도해 주세요!")
                    }
                }
                .disposed(by: disposeBag)
        }
    }
}


extension UserViewController: FeedDelegate {
    func like(tag: Int, result: Bool) {
        
    }
    }
    
    
}
