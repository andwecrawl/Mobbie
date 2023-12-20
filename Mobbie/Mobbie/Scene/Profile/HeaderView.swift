//
//  HeaderView.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit
import SnapKit

class HeaderView: UICollectionReusableView {
    
    let settings = ["내가 쓴 글", "미디어", "좋아요한 글"]
    
    var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setLayout())
        view.register(SegmentedCollectionCell.self, forCellWithReuseIdentifier: SegmentedCollectionCell.identifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    static func setLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 2
        let width: CGFloat = (UIScreen.main.bounds.width - (space * 5)) / 5
        
        layout.itemSize = CGSize(width: width, height: 50)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        
        return layout
    }
}

extension HeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentedCollectionCell.identifier, for: indexPath) as? SegmentedCollectionCell else { return UICollectionViewCell() }
        
        let item = indexPath.item
        cell.namelabel.text = settings[item]
        
        return cell
    }
    
    
}
