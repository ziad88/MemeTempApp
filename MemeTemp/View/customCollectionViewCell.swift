//
//  customCollectionViewCell.swift
//  MemeTemp
//
//  Created by Ziad Alfakharany on 12/03/2023.
//

import UIKit

class customCollectionViewCell: UICollectionViewCell {
    
    private var vw: CellView?
    
    var item : memeData? {
        didSet {
            
            guard let img = item?.url,
                  let title = item?.name else {
                return
            }
            vw?.configure(img: img, cellTitle: title)
        }
    }
    
    static let identifier = "customCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

private extension customCollectionViewCell {
    
    func setUp() {
        
        guard vw == nil else {return}
        
        vw = CellView()
        
        self.contentView.addSubview(vw!)
        
        NSLayoutConstraint.activate([
            vw!.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            vw!.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            vw!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            vw!.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
        ])
    }
}
