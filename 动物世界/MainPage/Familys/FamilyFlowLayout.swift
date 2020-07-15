//
//  FamilyFlowLayout.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/6/12.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit

class FamilyFlowLayout: UICollectionViewLayout {
    
    var columnCount: Int = 3 {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var itemHeight: CGFloat = 0.0
    var itemWidth: CGFloat = 0.0
    var margin: CGFloat = 20
    
    override func prepare() {
        super.prepare()
        
        itemWidth = ((self.collectionView?.frame.width ?? 0.0) - 120)/3
        itemHeight = ((self.collectionView?.frame.height ?? 0.0) - 80)/2
        
        collectionView?.isScrollEnabled = true
    }
    
    override var collectionViewContentSize : CGSize {
        
        var width: CGFloat = 0
        
        let pageNumber = (collectionView!.numberOfItems(inSection: 0)-1) / (columnCount*2) + 1
        width = CGFloat(collectionView!.bounds.width * CGFloat(pageNumber))
        return CGSize(width: width, height: collectionView!.bounds.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
           var attributesArray = [UICollectionViewLayoutAttributes]()
           let cellCount = self.collectionView!.numberOfItems(inSection: 0)
           for i in 0..<cellCount {
               let indexPath =  IndexPath(item:i, section:0)
               
               let attributes =  self.layoutAttributesForItem(at: indexPath)
               
               attributesArray.append(attributes!)
               
           }
           return attributesArray
       }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let page = indexPath.item / (columnCount*2)
        let row = indexPath.item % (columnCount*2) / columnCount

        let column = indexPath.item % (columnCount*2) % columnCount + page * 3

        let gap = (collectionView!.bounds.width - itemWidth*3)/4.0

        let positionX =  CGFloat(column) * (itemWidth + gap) + margin*(CGFloat(page + 1))
       
        let positionY = CGFloat(row) * (itemHeight + gap) + 20
        
        attribute.frame = CGRect(x: positionX, y: positionY, width: itemWidth, height: itemHeight)
        
        return attribute
    }

}
