//
//  StepPageControl.swift
//  StepPageControl
//
//  Created by Ryuji Muraoka on 2019/03/01.
//  Copyright © 2019年 rm studio. All rights reserved.
//

import UIKit

public class StepPageControl: UIControl {
    
    public var numberOfStep: Int = 0
    
    public var currentStep: Int = 0
    
    public var hasDoneStep: Int = 0
    
    public var intervalLength: CGFloat = 20.0
    
    public var circleWidth: CGFloat = 10.0
    
    public var currentFillColor: UIColor = UIColor(red: 255/255, green: 230/255, blue: 0, alpha: 1.0)
    
    public var currentStrokeColor: UIColor = UIColor(red: 255/255, green: 230/255, blue: 0, alpha: 1.0)
    
    public var waitingFillColor: UIColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
    
    public var waitingStrokeColor: UIColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
    
    public var doneFillColor: UIColor = UIColor.white
    
    public var doneStrokeColor: UIColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    private func setUp() {
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.sublayers = nil
        
        var leftCircleCenterX: CGFloat = 0.0
        let stepCount: CGFloat = CGFloat(self.numberOfStep)
        
        // 左端の円の中心座標の算出
        if self.numberOfStep % 2 != 0 {
            leftCircleCenterX = self.frame.width/2 - (stepCount-1)/2 * self.intervalLength
        } else {
            leftCircleCenterX = self.frame.width/2  - (stepCount/2 - 1) * self.intervalLength - self.intervalLength/2
        }
        
        // 円の配置
        for i in 0..<self.numberOfStep {
            let circleLayer = CAShapeLayer.init()
            let circleFrame = CGRect.init(x: leftCircleCenterX + CGFloat(i) * self.intervalLength,
                                          y: self.frame.height/2,
                                          width: self.circleWidth,
                                          height: self.circleWidth)
            circleLayer.frame = circleFrame
            circleLayer.lineWidth = 1.0
            
            // 色を塗る
            if i == self.currentStep {
                circleLayer.fillColor = self.currentFillColor.cgColor
                circleLayer.strokeColor = self.currentStrokeColor.cgColor
            } else {
                if i <= self.hasDoneStep {
                    circleLayer.fillColor = self.doneFillColor.cgColor
                    circleLayer.strokeColor = self.doneStrokeColor.cgColor
                } else {
                    circleLayer.fillColor = self.waitingFillColor.cgColor
                    circleLayer.strokeColor = self.waitingStrokeColor.cgColor
                }
            }
            
            circleLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: 0,
                                                                     y: 0,
                                                                     width: circleFrame.size.width,
                                                                     height: circleFrame.size.height)).cgPath
            self.layer.addSublayer(circleLayer)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if location.x < self.bounds.width / 2 {
            if self.currentStep > 0 {
                self.currentStep = self.currentStep - 1
            }
        } else {
            if self.currentStep < self.numberOfStep - 1 {
                self.currentStep = self.currentStep + 1
            }
        }
        
        if self.hasDoneStep <= self.currentStep {
            self.hasDoneStep = self.currentStep
        }
        self.layoutSubviews()
        self.sendActions(for: UIControlEvents.allTouchEvents)
    }
}

