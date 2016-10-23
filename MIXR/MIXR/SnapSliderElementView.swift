//
//  SnapSliderElementView.swift
//  MIXR
//
//  Created by Michael Ciesielka on 10/17/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

class SnapSliderElementView: UIView {
    
    static var count = 0
    
    private(set) var element: SnapSliderElementModel!
    
    let containerView = UIView()
    let button = UIButton()
    let label = UILabel()
    
    convenience init(element: SnapSliderElementModel) {
        self.init(frame: CGRectZero)
        self.element = element
        commonInit()
        SnapSliderElementView.count += 1
    }
}

private extension SnapSliderElementView {
    func commonInit() {
        setupUI()
        applyConstraints()
    }
    
    func setupUI() {
        backgroundColor = [UIColor.greenColor(), UIColor.purpleColor()][SnapSliderElementView.count]
        
        label.text = element.label
        button.setImage(UIImage(named: "snap-track-unselected"), forState: .Normal)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        addSubview(label)
        addSubview(button)
    }
    
    func applyConstraints() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [
            "button": button,
            "label": label
        ]
        
        let metrics = [
            "horizontalPadding": 5,
            "verticalPadding": 5
        ]
        
       
        button.widthAnchor.constraintEqualToConstant(40).active = true
        button.heightAnchor.constraintEqualToAnchor(button.widthAnchor, multiplier: 1.0).active = true
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[button]-[label]-verticalPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        let horizontalButtonConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-horizontalPadding-[button]-horizontalPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        let horizontalLabelConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-horizontalPadding-[label]-horizontalPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        
        NSLayoutConstraint.activateConstraints(verticalConstraints)
        NSLayoutConstraint.activateConstraints(horizontalButtonConstraints)
        NSLayoutConstraint.activateConstraints(horizontalLabelConstraints)
    }
}
