//
//  RecentPhotoVidoeController.swift
//  MIXR
//
//  Created by Nilesh Patel on 17/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class RecentPhotoVidoeController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
    @IBOutlet var collectionView: UICollectionView!

    lazy var cellSizes: [CGSize] = {
        var _cellSizes = [CGSize]()
        
        for _ in 0...100 {
            let random = Int(arc4random_uniform((UInt32(100))))
            
            _cellSizes.append(CGSize(width: 140, height: 50 + random))
        }
        _cellSizes.append(CGSize(width: 100, height: 100))
        return _cellSizes
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.headerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.headerHeight = 0
        layout.footerHeight = 0
        layout.minimumColumnSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        collectionView.collectionViewLayout = layout
//        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
//        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionFooter, withReuseIdentifier: "Footer")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        if let label = cell.contentView.viewWithTag(1) as? UILabel {
            label.text = String(indexPath.row)
        }
        
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        var reusableView: UICollectionReusableView? = nil
//        
//        if kind == CollectionViewWaterfallElementKindSectionHeader {
//            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as? UICollectionReusableView
//            
//            if let view = reusableView {
//                view.backgroundColor = UIColor.redColor()
//            }
//        }
//        else if kind == CollectionViewWaterfallElementKindSectionFooter {
//            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath) as? UICollectionReusableView
//            if let view = reusableView {
//                view.backgroundColor = UIColor.blueColor()
//            }
//        }
    
//        return reusableView!
//    }
    
    // MARK: WaterfallLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
//        return cellSizes[indexPath.item]
    }

}