//
//  SnapSlider.swift
//  MIXR
//
//  Created by Michael Ciesielka on 10/17/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

protocol SnapSliderDelegate: class {
    func snapSliderView(snapSliderView: SnapSliderView, didSnapToElement element: SnapSliderElementModel)
}

class SnapSliderView: UIView {
    
    private var elements: [SnapSliderElementModel] = []
    private var elementSubviews: [SnapSliderElementView] = []
    
    weak var delegate: SnapSliderDelegate?

    convenience init(elements: [SnapSliderElementModel]) {
        self.init(frame: CGRectZero)
        self.elements = elements
        commonInit()
    }
}

private extension SnapSliderView {
    func commonInit() {
        setupUI()
        applyConstraints()
    }
    
    func setupUI() {
        for element in elements {
            let view = SnapSliderElementView(element: element)
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            elementSubviews.append(view)
        }
    }
    
    func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalPadding: CGFloat = 20.0
        
        var prevElement: UIView = self
        for elementView in elementSubviews {
            var constraints = [NSLayoutConstraint]()
            elementView.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(elementView.leadingAnchor.constraintEqualToAnchor(prevElement.leadingAnchor, constant: horizontalPadding))
            constraints.append(elementView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 0))
            constraints.append(elementView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: 0))
            
            if prevElement is SnapSliderElementView {
                constraints.append(elementView.widthAnchor.constraintEqualToAnchor(prevElement.widthAnchor))
            }
            
            NSLayoutConstraint.activateConstraints(constraints)
            prevElement = elementView
        }
        
        prevElement.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: horizontalPadding).active = true
    }
}

