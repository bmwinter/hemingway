//
//  SpringIndicatorAnimatable.swift
//  MIXR
//
//  Created by Michael Ciesielka on 9/22/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit
import SpringIndicator

protocol SpringIndicatorTrait: class {
    var springIndicator: SpringIndicator? { get set }
}

extension SpringIndicatorTrait {
    func addSpringIndicatorToView(superview: UIView) {
        if springIndicator == nil {
            springIndicator = SpringIndicator(frame: CGRect(x: (((superview.frame.size.width)/2)-(40/2)), y: (superview.frame.size.height)/2, width: 40, height: 40))
        }
        
        guard let spring = springIndicator else { return }
        superview.addSubview(spring)
    }
    
    func startAnimatingSpringIndicator() {
        guard let spring = springIndicator,
            let _ = spring.superview else { return }
        spring.startAnimation()
    }
    
    func stopAnimatingSpringIndicator() {
        springIndicator?.stopAnimation(false)
    }
}

extension SpringIndicatorTrait where Self: UIViewController {
    func addSpringIndicator() {
        addSpringIndicatorToView(view)
    }
}
