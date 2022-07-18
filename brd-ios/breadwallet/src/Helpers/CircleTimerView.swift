// 
//  CircleTimer.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 18/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class CircleTimerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBaseLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpBaseLayer()
    }
    
    /** If true, use a mask to reveal the background of the timer, if the background is clear, the view beneath the timer will be revealed */
    open var useMask: Bool = true {
        didSet {
            update()
        }
    }
    
    /** The color of the border around the circle */
    open var timerBorderColor: UIColor = LightColors.primary {
        didSet {
            update()
        }
    }
    
    /**
     The color of the background of the timer
     */
    open var timerBackgroundColor: UIColor = UIColor.clear {
        didSet {
            update()
        }
    }
    
    /**
     The color of the timer when it's filled
     */
    open var timerFillColor: UIColor = LightColors.primary {
        didSet {
            update()
        }
    }
    
    /**
     The ratio that is used to determine the width of the border. It's the ratio of the border to the width of the view frame
     */
    open var ratioForBorderWidth: CGFloat = 2 / 20 {
        didSet {
            update()
        }
    }
    
    /**
     The ratio that is used to determine the diameter of the timer. It's the ratio of the timer's diameter to the width of the view frame
     */
    open var ratioForTimerDiameter: CGFloat = 12 / 20 {
        didSet {
            update()
        }
    }
    
    private var filledLayer: CALayer?
    private var timerLayer: CALayer?
    private var timerFillDiameter: CGFloat = 0
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpBaseLayer()
    }
    
    func setUpBaseLayer() {
        let baseLayer = layer
        baseLayer.backgroundColor = timerBackgroundColor.cgColor
        let bWidth = frame.width * ratioForBorderWidth
        baseLayer.borderWidth = bWidth
        baseLayer.cornerRadius = frame.width / 2
        baseLayer.borderColor = timerBorderColor.cgColor
        
        timerFillDiameter = frame.width * ratioForTimerDiameter
        
        contentMode = .redraw
    }
    
    func update() {
        var doFill = false
        
        if filledLayer != nil && timerLayer == nil {
            doFill = true
        }
        
        clear()
        setUpBaseLayer()
        
        if doFill {
            drawFilled()
        }
    }
    
    open func drawFilled() {
        clear()
        
        guard filledLayer == nil else { return }
        
        let parentLayer = layer
        let circleLayer = CAShapeLayer()
        circleLayer.bounds = parentLayer.bounds
        circleLayer.position = CGPoint(x: parentLayer.bounds.midX, y: parentLayer.bounds.midY)
        let circleRadius = timerFillDiameter * 0.5
        let circleBounds = CGRect(x: parentLayer.bounds.midX - circleRadius,
                                  y: parentLayer.bounds.midY - circleRadius,
                                  width: timerFillDiameter,
                                  height: timerFillDiameter)
        circleLayer.fillColor = timerFillColor.cgColor
        circleLayer.path = UIBezierPath(ovalIn: circleBounds).cgPath
        
        parentLayer.addSublayer(circleLayer)
        filledLayer = circleLayer
    }
    
    open func clear() {
        removeTimerLayer()
        removeFilledLayer()
    }
    
    open func startTimer(duration: CFTimeInterval) {
        drawFilled()
        
        if useMask {
            runMaskAnimation(duration: duration)
        } else {
            runDrawAnimation(duration: duration)
        }
    }
    
    open func runMaskAnimation(duration: CFTimeInterval) {
        if let parentLayer = filledLayer {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = parentLayer.frame
            
            let circleRadius = timerFillDiameter * 0.5
            let circleHalfRadius = circleRadius * 0.5
            let circleBounds = CGRect(x: parentLayer.bounds.midX - circleHalfRadius,
                                      y: parentLayer.bounds.midY - circleHalfRadius,
                                      width: circleRadius,
                                      height: circleRadius)
            
            maskLayer.fillColor = UIColor.clear.cgColor
            maskLayer.strokeColor = UIColor.black.cgColor
            maskLayer.lineWidth = circleRadius
            
            let path = UIBezierPath(roundedRect: circleBounds, cornerRadius: circleBounds.size.width * 0.5)
            maskLayer.path = path.reversing().cgPath
            maskLayer.strokeEnd = 0
            
            parentLayer.mask = maskLayer
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = 1.0
            animation.toValue = 0.0
            maskLayer.add(animation, forKey: "strokeEnd")
        }
    }
    
    open func runDrawAnimation(duration: CFTimeInterval) {
        if let parentLayer = filledLayer {
            let circleLayer = CAShapeLayer()
            circleLayer.bounds = parentLayer.bounds
            circleLayer.position = CGPoint(x: parentLayer.bounds.midX, y: parentLayer.bounds.midY)
            let circleRadius = timerFillDiameter * 0.5
            let circleHalfRadius = circleRadius * 0.5
            let circleBounds = CGRect(x: parentLayer.bounds.midX - circleHalfRadius,
                                      y: parentLayer.bounds.midY - circleHalfRadius,
                                      width: circleRadius,
                                      height: circleRadius)
            
            let path = UIBezierPath(roundedRect: circleBounds, cornerRadius: circleBounds.size.width * 0.5)
            
            circleLayer.strokeColor = timerBackgroundColor.cgColor
            circleLayer.fillColor = UIColor.clear.cgColor
            // add 1 pixel to the radius to make sure to cover the filled area
            circleLayer.lineWidth = circleRadius + 1
            circleLayer.path = path.cgPath
            parentLayer.addSublayer(circleLayer)
            circleLayer.strokeStart = 0
            circleLayer.strokeEnd = 1
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = 0.0
            animation.toValue = 1.0
            circleLayer.add(animation, forKey: "strokeEnd")
        }
    }
    
    private func removeTimerLayer() {
        guard let tLayer = timerLayer else { return }
        tLayer.removeFromSuperlayer()
        
        timerLayer = nil
    }
    
    private func removeFilledLayer() {
        guard let fLayer = filledLayer else { return }
        fLayer.removeFromSuperlayer()
        
        filledLayer = nil
    }
    
    open func redraw() {
        timerLayer?.setNeedsDisplay()
        filledLayer?.setNeedsDisplay()
        layer.setNeedsDisplay()
    }
}
