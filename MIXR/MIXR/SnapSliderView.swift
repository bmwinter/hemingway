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
    
    private struct Styles {
        static let BackgroundViewHeight: CGFloat = 3.0
        static let HorizontalPadding: CGFloat = 20.0
        static let AnimationSpeed: NSTimeInterval = 0.25
    }
    
    private var elements: [SnapSliderElementModel] = []
    private var elementSubviews: [SnapSliderElementView] = []
    
    private var sliderModel: SnapSliderModel!
    
    weak var delegate: SnapSliderDelegate?
    
    private var buttonImageView: UIImageView!
    private var buttonImageViewLeadingConstraint: NSLayoutConstraint!
    private var backgroundView = UIView()

    convenience init(elements: [SnapSliderElementModel]) {
        self.init(frame: CGRectZero)
        self.elements = elements.sort { $0.value < $1.value }
        sliderModel = SnapSliderModel(intervals: elements.count)
        commonInit()
    }
}

// MARK: - UI Setup
private extension SnapSliderView {
    func commonInit() {
        setupUI()
        applyConstraints()
    }
    
    func setupUI() {
        // setup background view
        backgroundView.backgroundColor = UIColor.snapSliderBackgroundViewColor()
        addSubview(backgroundView)
        
        // setup elements
        for element in elements {
            let view = SnapSliderElementView(element: element)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.delegate = self
            addSubview(view)
            elementSubviews.append(view)
        }
        
        // setup slider button
        buttonImageView = UIImageView(image: UIImage(named: "snap-track-selected"))
        buttonImageView.userInteractionEnabled = true
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        buttonImageView.addGestureRecognizer(gestureRecognizer)
        addSubview(buttonImageView)
    }
    
    func applyConstraints() {
        // prepare subviews for autolayout
        translatesAutoresizingMaskIntoConstraints = false
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // autolayout background view
        backgroundView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        backgroundView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        backgroundView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
        backgroundView.heightAnchor.constraintEqualToConstant(Styles.BackgroundViewHeight).active = true
        
        // autolayout button image view
        buttonImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        buttonImageViewLeadingConstraint = buttonImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: UIScreen.mainScreen().bounds.width/2 - buttonImageView.bounds.width/2)
        buttonImageViewLeadingConstraint.active = true
        
        // autolayout element subviews
        var prevElement: UIView = self
        for elementView in elementSubviews {
            var constraints = [NSLayoutConstraint]()
            elementView.translatesAutoresizingMaskIntoConstraints = false
            
            if prevElement is SnapSliderView {
                constraints.append(elementView.leadingAnchor.constraintEqualToAnchor(prevElement.leadingAnchor, constant: Styles.HorizontalPadding))
            } else {
                constraints.append(elementView.leadingAnchor.constraintEqualToAnchor(prevElement.trailingAnchor, constant: Styles.HorizontalPadding))
                constraints.append(elementView.widthAnchor.constraintEqualToAnchor(prevElement.widthAnchor))
            }
            
            constraints.append(elementView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 0))
            constraints.append(elementView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: 0))
            
            NSLayoutConstraint.activateConstraints(constraints)
            prevElement = elementView
        }
        
        prevElement.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -1*Styles.HorizontalPadding).active = true
    }
}

// MARK: - Handle Pan
private extension SnapSliderView {
    
    var uiWidth: CGFloat {
        return bounds.size.width - buttonImageView.bounds.size.width
    }
    
    func getUpdateValueForPoint(point: CGPoint) -> CGFloat {
        let newConstant = point.x - buttonImageView.bounds.size.width/2
        return max(min(newConstant, uiWidth), 0)
    }
    
    func getUpdateValueForIndex(index: Int) -> CGFloat {
        let subviewButtonImageFrame = elementSubviews[index].button.imageView!.frame
        let convertedRect = elementSubviews[index].convertRect(subviewButtonImageFrame, toView: self)
        return convertedRect.origin.x + subviewButtonImageFrame.size.width / 4
    }
    
    func animateToButtonIndex(index: Int) {
        let updateValue = getUpdateValueForIndex(index)
        
        UIView.animateWithDuration(Styles.AnimationSpeed,
                                   delay: 0.25,
                                   options: .CurveEaseOut,
                                   animations: {
                                    self.buttonImageViewLeadingConstraint.constant = updateValue
                                    self.layoutIfNeeded()
            }, completion: { success in
                if success {
                    self.updateSliderModel(updateValue)
                    self.delegate?.snapSliderView(self, didSnapToElement: self.elements[index])
                }
        })
    }
    
    @objc func handlePan(sender: UIGestureRecognizer) {
        switch sender.state {
        case .Changed:
            let updateValue = getUpdateValueForPoint(sender.locationInView(self))
            buttonImageViewLeadingConstraint.constant = updateValue
            self.updateSliderModel(updateValue)
        case .Cancelled, .Ended:
            let index = sliderModel.nearestIntervalIndex()
            animateToButtonIndex(index)
        default:
            break
        }
    }
    
    func updateSliderModel(value: CGFloat) {
        var newValue = value
        let delta = getUpdateValueForIndex(0)
        let upperBound = uiWidth - delta
        
        if newValue <= delta { newValue = delta }
        if newValue >= upperBound { newValue = upperBound }
        
        self.sliderModel.value = Double((newValue - delta) / (uiWidth - 2 * delta))
    }
}

// MARK: - SnapSliderElementViewDelegate
extension SnapSliderView: SnapSliderElementViewDelegate {
    func snapSliderElementView(snapSliderElementView: SnapSliderElementView, didReceiveTouchEventFromSender sender: AnyObject) {
        for (index, sliderElementView) in elementSubviews.enumerate() {
            if snapSliderElementView == sliderElementView {
                animateToButtonIndex(index)
                break
            }
        }
    }
}

