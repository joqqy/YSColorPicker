//
//  ColorViewController.swift
//  YSColorPicker
//
//  Created by Yosuke Seki on 2018/02/01.
//  Copyright © 2018年 Yosuke Seki. All rights reserved.
//

// Most likely the Text with the "hue:<value>" info etc over the color bars
// and the -|+ stepper controls (just below the gradient box, just above the spectrum view)
// But also adds the spectrum color bar

import UIKit

class YSColorUnitViewController: YSUnitViewController {
    
    var stepperChangedFunc: ((Double) -> ())?
    var name: String = "" // R,G,B,Brightness.. etc

    var margin: CGFloat = 10
    var label: UILabel! = UILabel()
    var stepper: UIStepper! = UIStepper()

    
    init(name: String, maxValue: Double, currentValue: Double, step: Double, colorFunc: @escaping (() -> ([CGColor]))) {
        
        super.init(nibName: nil, bundle: nil)
        self.name = name
        super.maxValue = maxValue
        self.stepper.stepValue = step
        super.colorFunc = colorFunc
        super._currentValue = currentValue
    }

    @available (*, unavailable, message: "Please use the initializer as init (name:, maxValue:, currentValue:, step:, colorFunc:")
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    @available (*, unavailable, message: "Please use the initializer as init (name:, maxValue:, currentValue:, step:, colorFunc:")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    @available (*, unavailable, message: "Please use the initializer as init (name:, maxValue:, currentValue:, step:, colorFunc:")
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.addSubview(label)
        self.view.addSubview(stepper)
        
        self.view.addSubview(bg) // p the background for the color bar rectangle
        self.view.addSubview(colorBar) // p the spectrum color bar rectangle
        
        self.view.addSubview(knob) // p the knob handle for either the gradient or the color bar
        
        stepper.maximumValue = super.maxValue
        stepper.minimumValue = super.minValue
        stepper.addTarget(self,
                          action: #selector(YSColorUnitViewController.onStepperChange(stepper:)),
                          for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let w = self.view.frame.size.width
        let h = self.view.frame.size.height
        let stepperSize = stepper.frame.size
        label.frame = CGRect(x: 0, y: 0, width: w, height: stepperSize.height)
        stepper.frame.origin = CGPoint(x: w-stepperSize.width, y: 0)
        bg.frame = CGRect(x: 0, y: stepperSize.height + margin,
                              width: w, height: h-(stepperSize.height+margin))
        bg.backgroundColor = .clear
        bg.setNeedsDisplay()
            
        colorBar.frame = bg.frame
        knob.frame = CGRect(x: 0, y:
                            stepperSize.height + margin, width: 2, height: h - (stepperSize.height + margin))
        knob.make()
            
        super.currentValue = super._currentValue //入れ直して位置を再計算
        update()
    }
    
    override func update() {
        
        knob.frame.origin.x = max(0, colorBar.frame.width * CGFloat(_currentValue/maxValue))
        stepper.value = _currentValue
        label.text = name + Int(_currentValue).description
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            colorBar.make(colors: super.colorFunc())
        CATransaction.commit()
    }
    
    @objc func onStepperChange(stepper:UIStepper) {
        
        currentValue = stepper.value
        stepperChangedFunc?(stepper.value)
    }
    
    override func finishing() {
        
        label.removeFromSuperview()
        stepper.removeFromSuperview()
        colorBar.removeFromSuperview()
        knob.removeFromSuperview()
        bg.removeFromSuperview()
        
        colorFunc = nil
        stepperChangedFunc = nil
        label = nil
        stepper = nil
        colorBar = nil
        knob = nil
        bg = nil
    }

}
