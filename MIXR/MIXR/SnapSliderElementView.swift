//
//  SnapSliderElementView.swift
//  MIXR
//
//  Created by Michael Ciesielka on 10/17/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

protocol SnapSliderElementViewDelegate: class {
    func snapSliderElementView(snapSliderElementView: SnapSliderElementView, didReceiveTouchEventFromSender sender: AnyObject)
}

class SnapSliderElementView: UIView {
    
    private struct Styles {
        static let verticalLabelSpacing: CGFloat = 10.0
        static let fontSize: CGFloat = 10.0
    }
    
    private(set) var element: SnapSliderElementModel!
    
    weak var delegate: SnapSliderElementViewDelegate?
    
    let containerView = UIView()
    let button = UIButton()
    let label = UILabel()
    
    convenience init(element: SnapSliderElementModel) {
        self.init(frame: CGRectZero)
        self.element = element
        commonInit()
    }
}

private extension SnapSliderElementView {
    func commonInit() {
        setupUI()
        applyConstraints()
    }
    
    func setupUI() {
        label.text = element.label
        label.font = UIFont.regularFontWithSize(Styles.fontSize)
        button.setImage(UIImage(named: "snap-track-unselected"), forState: .Normal)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        button.addTarget(self, action: #selector(SnapSliderElementView.didTapButton(_:)), forControlEvents: .TouchUpInside)
        
        addSubview(label)
        addSubview(button)
    }
    
    func applyConstraints() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
       
        button.widthAnchor.constraintEqualToConstant(40).active = true
        button.heightAnchor.constraintEqualToAnchor(button.widthAnchor, multiplier: 1.0).active = true
        button.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        button.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        
        label.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        label.topAnchor.constraintEqualToAnchor(button.bottomAnchor, constant: -1*Styles.verticalLabelSpacing).active = true
    }
    
    @objc func didTapButton(sender: UIButton) {
        delegate?.snapSliderElementView(self, didReceiveTouchEventFromSender: sender)
    }
}
