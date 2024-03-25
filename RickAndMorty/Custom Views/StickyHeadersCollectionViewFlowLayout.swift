//
//  stickyheader.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/9/24.
//

import Foundation
import UIKit

class StickyHeadersCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var sectionOffsets: [Int: CGFloat] = [:]
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        
        for attributes in layoutAttributes where attributes.representedElementCategory == .supplementaryView {
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                let section = attributes.indexPath.section
                let topOffset = sectionOffsets[section] ?? 0
                let offsetY = collectionView.contentOffset.y + collectionView.contentInset.top
                let headerY = max(topOffset, offsetY)
                attributes.frame.origin.y = headerY
            }
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        
        let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            let contentOffsetY = collectionView.contentOffset.y + collectionView.contentInset.top
            let offsetY = max(sectionOffsets[indexPath.section] ?? 0, contentOffsetY)
            attributes?.frame.origin.y = offsetY
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        for update in updateItems {
            if update.updateAction == .insert || update.updateAction == .delete {
                sectionOffsets.removeAll()
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        var yOffset: CGFloat = 0
        
        for section in 0 ..< collectionView.numberOfSections {
            let indexPath = IndexPath(item: 0, section: section)
            let headerSize = CGSize(width: collectionView.bounds.width, height: 50) // Set the constant height and width here
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            attributes.frame = CGRect(x: 0, y: yOffset, width: headerSize.width, height: headerSize.height)
            sectionOffsets[section] = yOffset
            yOffset += headerSize.height
        }
    }

}
