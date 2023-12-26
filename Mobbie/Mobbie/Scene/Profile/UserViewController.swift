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
    var viewModel = UserViewModel()
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
        
        bind()
        viewModel = UserViewModel()
    }
    
    func bind() {
        
        
        let input = UserViewModel.Input(
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
        
        output.cellType
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, cellType in
                print("changed \(cellType)")
                owner.cellType = cellType
                owner.collectionView.collectionViewLayout = owner.createLayout()
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.nextCursor, output.errorMessage)
            .bind(with: self) { owner, value in
                let nextCursor = value.0
                let errorMessage = value.1
                
                if errorMessage.isEmpty {
                    owner.nextCursor = nextCursor
                    owner.collectionView.reloadSections(IndexSet(arrayLiteral: 1))
                } else {
                    owner.sendOneSideAlert(title: errorMessage, message: "다시 시도해 주세요!")
                }
            }
            .disposed(by: disposeBag)
        
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
            return 10 // post 갯수로 변경
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        
        if section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NicknameCell.identifier, for: indexPath) as? NicknameCell else { return UICollectionViewCell() }
            
            return cell
        } else if cellType == .feed {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else { return UICollectionViewCell() }
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
        viewModel.cellType.accept(cellType)
    }
    
    
}