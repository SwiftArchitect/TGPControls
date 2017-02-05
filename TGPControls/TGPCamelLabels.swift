//    @file:    TGPCamelLabels.swift
//    @project: TGPControls
//
//    @author:  Xavier Schott
//              mailto://xschott@gmail.com
//              http://thegothicparty.com
//              tel://+18089383634
//
//    @license: http://opensource.org/licenses/MIT
//    Copyright (c) 2017, Xavier Schott
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

import UIKit

@IBDesignable
public class TGPCamelLabels: UIControl {

    // Only used if labels.count < 1
    @IBInspectable public var tickCount:Int {
        get {
            return names.count
        }
        set {
            // Put some order to tickCount: 1 >= count >=  128
            let count = max(1, min(newValue, 128))
            debugNames(count: count)
            layoutTrack()
        }
    }

    @IBInspectable public var ticksDistance:CGFloat = 44.0 {
        didSet {
            ticksDistance = max(0, ticksDistance)
            layoutTrack()
        }
    }

    @IBInspectable public var value:UInt = 0 {
        didSet {
            dockEffect(duration: animationDuration)
        }
    }

    @IBInspectable public var upFontName:String? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var upFontSize:CGFloat = 12 {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var upFontColor:UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var downFontName:String? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var downFontSize:CGFloat = 12 {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var downFontColor:UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    // Label off-center to the left and right of the slider
    // expressed in label width. 0: none, -1/2: half outside, 1/2; half inside
    @IBInspectable public var offCenter:CGFloat = 0 {
        didSet {
            layoutTrack()
        }
    }

    // Label margins to the left and right of the slider
    @IBInspectable public var insets:NSInteger = 0 {
        didSet {
            layoutTrack()
        }
    }

    public var names:[String] = [] { // Will dictate the number of ticks
        didSet {
            assert(names.count > 0)
            layoutTrack()
        }
    }

    // When bounds change, recalculate layout
    override public var bounds: CGRect {
        didSet {
            layoutTrack()
            setNeedsDisplay()
        }
    }

    public var animationDuration:TimeInterval = 0.15

    // Fishy
    var animate = true

    // Private
    var lastValue = NSNotFound
    var upLabels:[UILabel] = []
    var dnLabels:[UILabel] = []

    // MARK: UIView

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initProperties()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }

    // clickthrough
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in subviews {
            if !view.isHidden &&
                view.alpha > 0.0 &&
                view.isUserInteractionEnabled &&
                view.point(inside: convert(point, to: view), with: event) {
                return true
            }
        }
        return false
    }

    // MARK: TGPCamelLabels

    func initProperties() {
        debugNames(count: 10)
        layoutTrack()
    }

    func debugNames(count:Int) {
        // Dynamic property, will create an array with labels, generally for debugging purposes
        var array:[String] = []
        for iterate in 1...count {
            array.append("\(iterate)")
        }
        names = array
    }

    func layoutTrack() {

        func insetLabel(_ label:UILabel?, withInset inset:NSInteger, andMultiplier multiplier:CGFloat) {
            assert(label != nil)
            if let label = label {
                label.frame = {
                    var frame = label.frame
                    frame.origin.x += frame.size.width * multiplier
                    frame.origin.x += CGFloat(inset)
                    return frame
                }()
            }
        }

        for label in upLabels {
            label.removeFromSuperview()
        }
        upLabels = []
        for label in dnLabels {
            label.removeFromSuperview()
        }
        dnLabels = []

        let count = names.count
        if count > 0 {
            var centerX = (bounds.width - (CGFloat(count - 1) * ticksDistance))/2.0
            let centerY = bounds.height / 2.0
            for name in names {
                let upLabel = UILabel.init()
                upLabels.append(upLabel)
                upLabel.text = name
                if let upFontName = upFontName {
                    upLabel.font = UIFont.init(name: upFontName, size: upFontSize)
                } else {
                    upLabel.font = UIFont.boldSystemFont(ofSize: upFontSize)
                }
                if let textColor = upFontColor ?? tintColor {
                    upLabel.textColor = textColor
                }
                upLabel.sizeToFit()
                upLabel.center = CGPoint(x: centerX, y: centerY)

                upLabel.frame = {
                    var frame = upLabel.frame
                    frame.origin.y = bounds.height - frame.height
                    return frame
                }()

                upLabel.alpha = 0.0
                addSubview(upLabel)

                let dnLabel = UILabel.init()
                dnLabels.append(dnLabel)
                dnLabel.text = name
                if let downFontName = downFontName {
                    dnLabel.font = UIFont.init(name:downFontName, size:downFontSize)
                } else {
                    dnLabel.font = UIFont.boldSystemFont(ofSize: downFontSize)
                }
                dnLabel.textColor = downFontColor ?? UIColor.gray
                dnLabel.sizeToFit()
                dnLabel.center = CGPoint(x:centerX, y:centerY)
                dnLabel.frame = {
                    var frame = dnLabel.frame
                    frame.origin.y = bounds.height - frame.height
                    return frame
                }()
                addSubview(dnLabel)

                centerX += ticksDistance
            }

            // Fix left and right label, if there are at least 2 labels
            if names.count > 1 {
                insetLabel(upLabels.first, withInset: insets, andMultiplier: offCenter)
                insetLabel(upLabels.last, withInset: -insets, andMultiplier: -offCenter)
                insetLabel(dnLabels.first, withInset: insets, andMultiplier: offCenter)
                insetLabel(dnLabels.last, withInset: -insets, andMultiplier: -offCenter)
            }

            dockEffect(duration:0.0)
        }
    }


    func dockEffect(duration:TimeInterval)
    {
        let up = Int(value)

        // Unlike the National Parks from which it is inspired, this Dock Effect
        // does not abruptly change from BOLD to plain. Instead, we have 2 sets of
        // labels, which are faded back and forth, in unisson.
        // - BOLD to plain
        // - Black to gray
        // - high to low
        // Each animation picks up where the previous left off
        let moveBlock:() -> Void = {
            let x = self.upLabels
            // Bring almost all down
            for (idx, label) in self.upLabels.enumerated() {
                if up != idx {
                    self.moveDown(aView: label, withAlpha: 0)
                }
            }
            for (idx, label) in self.dnLabels.enumerated() {
                if up != idx {
                    self.moveDown(aView: label, withAlpha: 1)
                }
            }

            // Bring the selection up
            if up < self.upLabels.count {
                self.moveUp(aView: self.upLabels[up], withAlpha:1)
            }
            if up < self.dnLabels.count {
                self.moveUp(aView: self.dnLabels[up], withAlpha:0)
            }
        }

        if duration > 0 {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: [.beginFromCurrentState, .curveLinear],
                           animations: moveBlock,
                           completion: nil)
        } else {
            moveBlock()
        }
    }
    
    func moveDown(aView:UIView, withAlpha alpha:CGFloat)
    {
        if animate {
            aView.frame = {
                var frame = aView.frame
                frame.origin.y = bounds.height - frame.height
                return frame
            }()
        }
        aView.alpha = alpha
    }
    
    func moveUp(aView:UIView, withAlpha alpha:CGFloat)
    {
        if animate {
            aView.frame = {
                var frame = aView.frame
                frame.origin.y = 0
                return frame
            }()
        }
        aView.alpha = alpha
    }
    
}

extension TGPCamelLabels : TGPControlsTicksProtocol {
    public func tgpTicksDistanceChanged(ticksDistance: CGFloat, sender: AnyObject) {
        self.ticksDistance = ticksDistance
    }
    
    public func tgpValueChanged(value: UInt) {
        self.value = value
    }
}
