//
//  GradientKnobView.swift
//  YSColorPicker
//
//  Created by Yosuke Seki on 2018/02/01.
//  Copyright © 2018年 Yosuke Seki. All rights reserved.
//

// This is the knob/handle in the big hsv gradient box(but also handles for the spectrum(and other bars)).
// However, this also creates the handle in the spectrum/gradient bars. We must find a way to decouple this, because we want to control their appearance independently
// TODO: p, make this a line circle

import UIKit

class YSGradientKnobView: UIView {
    
    // p the color of the handle
    var color: UIColor = .white
    // The calayer for the bar
    let barLayer = CALayer()
    
    init(color: UIColor) {
        
        super.init(frame: .zero)
        
        self.color = color
        makeBar()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeBar() {
        
        barLayer.shadowColor = UIColor.black.cgColor
        barLayer.shadowOffset = CGSize(width: 1, height: 1)
        barLayer.shadowOpacity = 0.4 // :0.4
        barLayer.shadowRadius = 2 // :2
        barLayer.backgroundColor = color.cgColor
        layer.addSublayer(barLayer)
    }
    
    // If moveY is true, then the knob is for the hsv gradient box, that is it is movied in both x and y, and is created as a small square, rather than
    // the thin vertical handle of the spectrum rectangle.
    func make(_ moveY: Bool = false){
        
        isUserInteractionEnabled = false
        let w = frame.size.width
        let h = frame.size.height

        if(moveY){
            barLayer.frame = CGRect(x: -w * 0.5, y: -h * 0.5,
                                    width: w, height: h)
            
        } else {
            barLayer.frame = CGRect(x: -w * 0.5, y: 0,
                                    width: w, height: h)
        }
        clipsToBounds = false
    }
}
