//
//  File.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/9/24.
//

import Foundation
import UIKit

final class CharacterCollectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CharacterCollectionHeaderView"
    
    private let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
        headerLabel.edgesToSuperview(insets: .init(top: 8, left: 8, bottom: 8, right: 8))
        backgroundColor = .systemGray4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        headerLabel.text = title
    }
}

