//
//  HeaderView.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit
import SnapKit

protocol HeaderViewDelegate {
    func sendCellType(_ cellType: ProfileCellType)
}

class HeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setLayout())
        view.register(SegmentedCollectionCell.self, forCellWithReuseIdentifier: SegmentedCollectionCell.identifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    let lineView = UIView()
    
    var delegate: HeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        
        self.addSubview(collectionView)
        self.addSubview(lineView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lineView.backgroundColor = .gray.withAlphaComponent(0.4)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(1)
        }
        
        delegate?.sendCellType(.feed)
    }
    
    func setLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = (UIScreen.main.bounds.width) / 3.5
        
        layout.itemSize = CGSize(width: width, height: 50)
        layout.scrollDirection = .horizontal
        
        return layout
    }
}

extension HeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileSegmentDataList.shared.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentedCollectionCell.identifier, for: indexPath) as? SegmentedCollectionCell else { return UICollectionViewCell() }
        
        let item = indexPath.item
        let data = ProfileSegmentDataList.shared.list
//        cell.namelabel.text = settings[item]
        
        cell.configureCell(item: data[item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        
        ProfileSegmentDataList.shared.segmentedDataTapped(index: item)
        switch item {
        case 1:
            delegate?.sendCellType(.media)
        default:
            delegate?.sendCellType(.feed)
        }
        collectionView.reloadData()
    }
    
}
