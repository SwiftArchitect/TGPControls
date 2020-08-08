import UIKit

public enum ComponentStyle:Int {
    case iOS = 0
    case rectangular
    case rounded
    case invisible
    case image
}

//  Interface builder hides the IBInspectable for UIControl
#if TARGET_INTERFACE_BUILDER
public class TGPSlider_INTERFACE_BUILDER:UIView {
}
#else // !TARGET_INTERFACE_BUILDER
public class TGPSlider_INTERFACE_BUILDER:UIControl {
}
#endif // TARGET_INTERFACE_BUILDER

@IBDesignable
public class TGPDiscreteSlider:TGPSlider_INTERFACE_BUILDER {

    @IBInspectable public var tickStyle:Int = ComponentStyle.rectangular.rawValue {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var tickSize:CGSize = CGSize(width:1, height:4) {
        didSet {
            tickSize.width = max(0, tickSize.width)
            tickSize.height = max(0, tickSize.height)
            layoutTrack()
        }
    }

    @IBInspectable public var tickCount:Int = 11 {
        didSet {
            tickCount = max(2, tickCount)
            layoutTrack()
        }
    }

    @IBInspectable public var minimumTickTintColor:UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var maximumTickTintColor:UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var tickImage:UIImage? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var trackStyle:Int = ComponentStyle.iOS.rawValue {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var trackThickness:CGFloat = 2 {
        didSet {
            trackThickness = max(0, trackThickness)
            layoutTrack()
        }
    }

    @IBInspectable public var trackImage:UIImage? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var minimumTrackTintColor:UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var maximumTrackTintColor = UIColor(white: 0.71, alpha: 1) {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var thumbStyle:Int = ComponentStyle.iOS.rawValue {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var thumbSize:CGSize = CGSize(width:10, height:10) {
        didSet {
            thumbSize.width = max(1, thumbSize.width)
            thumbSize.height = max(1, thumbSize.height)
            layoutTrack()
        }
    }

    @IBInspectable public var thumbTintColor:UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var thumbImage:UIImage? = nil {
        didSet {
            if let thumbImage = thumbImage {
                thumbLayer.contents = thumbImage.cgImage
            } else {
                thumbLayer.contents = nil
            }
            layoutTrack()
        }
    }

    @IBInspectable public var thumbShadowRadius:CGFloat = 0 {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var thumbShadowOffset:CGSize = CGSize.zero {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var incrementValue:Int = 1 {
        didSet {
            if(0 == incrementValue) {
                incrementValue = 1;  // nonZeroIncrement
            }
            layoutTrack()
        }
    }

    // MARK: UISlider substitution
    // AKA: UISlider value (as CGFloat for compatibility with UISlider API, but expected to contain integers)

    @IBInspectable public var minimumValue:CGFloat {
        get {
            return CGFloat(intMinimumValue)
        }
        set {
            intMinimumValue = Int(newValue)
            layoutTrack()
        }
    }

    @IBInspectable public var value:CGFloat {
        get {
            return CGFloat(intValue)
        }
        set {
            intValue = Int(newValue)
            layoutTrack()
        }
    }

    // MARK: @IBInspectable adapters

    public var tickComponentStyle:ComponentStyle {
        get {
            return ComponentStyle(rawValue: tickStyle) ?? .rectangular
        }
        set {
            tickStyle = newValue.rawValue
        }
    }

    public var trackComponentStyle:ComponentStyle {
        get {
            return ComponentStyle(rawValue: trackStyle) ?? .iOS
        }
        set {
            trackStyle = newValue.rawValue
        }
    }

    public var thumbComponentStyle:ComponentStyle {
        get {
            return ComponentStyle(rawValue: thumbStyle) ?? .iOS
        }
        set {
            thumbStyle = newValue.rawValue
        }
    }

    // MARK: Properties

    public override var tintColor: UIColor! {
        didSet {
            layoutTrack()
        }
    }

    public override var bounds: CGRect {
        didSet {
            layoutTrack()
        }
    }

    public var ticksDistance:CGFloat {
        get {
            assert(tickCount > 1, "2 ticks minimum \(tickCount)")
            let segments = CGFloat(max(1, tickCount - 1))
            return trackRectangle.width / segments
        }
    }

    @objc public var ticksListener:TGPControlsTicksProtocol? = nil {
        didSet {
            ticksListener?.tgpTicksDistanceChanged(ticksDistance: ticksDistance,
                                                   sender: self)
        }
    }

    var intValue:Int = 0
    var intMinimumValue = -5

    var ticksAbscissae:[CGPoint] = []
    var thumbAbscissa:CGFloat = 0
    var thumbLayer = CALayer()

    var trackLayer = CALayer()
    var leftTrackLayer = CALayer()
    var rightTrackLayer = CALayer()
    var leadingTrackLayer: CALayer!
    var trailingTrackLayer: CALayer!

    var ticksLayer = CALayer()
    var leftTicksLayer = CALayer()
    var rightTicksLayer = CALayer()
    var leadingTicksLayer: CALayer!
    var trailingTicksLayer: CALayer!

    var trackRectangle = CGRect.zero
    var touchedInside = false
    var localeCharacterDirection = CFLocaleLanguageDirection.leftToRight

    let iOSThumbShadowRadius:CGFloat = 4
    let iOSThumbShadowOffset = CGSize(width:0, height:3)

    // MARK: UIControl

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initProperties()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }

    public override func draw(_ rect: CGRect) {
        drawTrack()
        drawTicks()
        drawThumb()
    }

    func sendActionsForControlEvents() {
        // Automatic UIControlEventValueChanged notification
        if let ticksListener = ticksListener {
            ticksListener.tgpValueChanged(value: UInt(value-minimumValue))
        }
    }

    // MARK: TGPDiscreteSlider

    func initProperties() {
        if let systemLocale = CFLocaleCopyCurrent(),
            let localeIdentifier = CFLocaleGetIdentifier(systemLocale) {
            localeCharacterDirection = CFLocaleGetLanguageCharacterDirection(localeIdentifier.rawValue)
        }

        leadingTrackLayer = (.rightToLeft == localeCharacterDirection)
            ? rightTrackLayer
            : leftTrackLayer
        trailingTrackLayer = (.rightToLeft == localeCharacterDirection)
            ? leftTrackLayer
            : rightTrackLayer
        leadingTicksLayer = (.rightToLeft == localeCharacterDirection)
            ? rightTicksLayer
            : leftTicksLayer
        trailingTicksLayer = (.rightToLeft == localeCharacterDirection)
            ? leftTicksLayer
            : rightTicksLayer

        // Track and ticks are in a clear clipping layer, and left + right sublayers,
        // which brings in free animation
        trackLayer.masksToBounds = true
        trackLayer.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
        trackLayer.addSublayer(leftTrackLayer)
        trackLayer.addSublayer(rightTrackLayer)

        // Ticks in between track and thumb
        ticksLayer.masksToBounds = true
        ticksLayer.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(ticksLayer)
        ticksLayer.addSublayer(rightTicksLayer) // reverse order, left covers right
        ticksLayer.addSublayer(leftTicksLayer)

        // The thumb is its own CALayer, which brings in free animation
        layer.addSublayer(thumbLayer)

        isMultipleTouchEnabled = false
        layoutTrack()
    }

    func drawTicks() {
        ticksLayer.frame = bounds
        let path = UIBezierPath()

        switch tickComponentStyle {
        case .rounded:
            fallthrough

        case .rectangular:
            fallthrough

        case .image:
            for originPoint in ticksAbscissae {
                let rectangle = CGRect(x: originPoint.x-(tickSize.width/2),
                                       y: originPoint.y-(tickSize.height/2),
                                       width: tickSize.width,
                                       height: tickSize.height)
                switch tickComponentStyle {
                case .rounded:
                    path.append(UIBezierPath(roundedRect: rectangle,
                                             cornerRadius: rectangle.height/2))

                case .rectangular:
                    path.append(UIBezierPath(rect: rectangle))

                case .image:
                    // Draw image if exists
                    if let image = tickImage,
                        let cgImage = image.cgImage,
                        let ctx = UIGraphicsGetCurrentContext() {
                        let centered = CGRect(x: rectangle.origin.x + (rectangle.width/2) - (image.size.width/2),
                                              y: rectangle.origin.y + (rectangle.height/2) - (image.size.height/2),
                                              width: image.size.width,
                                              height: image.size.height)
                        ctx.draw(cgImage, in: centered)
                    }

                case .invisible:
                    fallthrough

                case .iOS:
                    fallthrough

                default:
                    assert(false)
                    break
                }
            }

        case .invisible:
            fallthrough

        case .iOS:
            fallthrough

        default:
            // Nothing to draw
            break
        }

        leftTicksLayer.frame = {
            var frame = ticksLayer.bounds
            let tickWidth = (.rightToLeft == localeCharacterDirection)
                ? -tickSize.width/2
                : tickSize.width/2
            frame.size.width = tickWidth + thumbAbscissa

            return frame
        }()

        leftTicksLayer.mask = {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = ticksLayer.bounds
            maskLayer.path = path.cgPath
            return maskLayer
        }()

        rightTicksLayer.frame = ticksLayer.bounds

        rightTicksLayer.mask = {
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            return maskLayer
        }()

        if let backgroundColor = minimumTickTintColor ?? (minimumTrackTintColor ?? tintColor) {
            leadingTicksLayer.backgroundColor = backgroundColor.cgColor
        }
        trailingTicksLayer.backgroundColor = maximumTickTintColor?.cgColor ?? maximumTrackTintColor.cgColor
    }

    func drawTrack() {
        switch(trackComponentStyle) {
        case .rectangular:
            trackLayer.frame = trackRectangle
            trackLayer.cornerRadius = 0.0

        case .invisible:
            trackLayer.frame = CGRect.zero

        case .image:
            trackLayer.frame = CGRect.zero

            // Draw image if exists
            if let image = trackImage,
                let cgImage = image.cgImage,
                let ctx = UIGraphicsGetCurrentContext() {
                let centered = CGRect(x: (frame.width/2) - (image.size.width/2),
                                      y: (frame.height/2) - (image.size.height/2),
                                      width: image.size.width,
                                      height: image.size.height)
                ctx.draw(cgImage, in: centered)
            }

        case .rounded:
            fallthrough

        case .iOS:
            fallthrough

        default:
            trackLayer.frame = trackRectangle
            trackLayer.cornerRadius = trackRectangle.height/2
            break
        }

        leftTrackLayer.frame = {
            var frame = trackLayer.bounds
            frame.size.width = thumbAbscissa - trackRectangle.minX
            return frame
        }()

        rightTrackLayer.frame = {
            var frame = trackLayer.bounds
            frame.size.width = trackRectangle.width - leftTrackLayer.frame.width
            frame.origin.x = leftTrackLayer.frame.maxX
            return frame
        }()

        if let backgroundColor = minimumTrackTintColor ?? tintColor {
            leadingTrackLayer.backgroundColor = backgroundColor.cgColor
        }
        trailingTrackLayer.backgroundColor = maximumTrackTintColor.cgColor
    }

    func drawThumb() {
        if( value >= minimumValue) {  // Feature: hide the thumb when below range

            let thumbSizeForStyle = thumbSizeIncludingShadow()
            let thumbWidth = thumbSizeForStyle.width
            let thumbHeight = thumbSizeForStyle.height
            let rectangle = CGRect(x:thumbAbscissa - (thumbWidth / 2),
                                   y: (frame.height - thumbHeight)/2,
                                   width: thumbWidth,
                                   height: thumbHeight)

            let shadowRadius = (thumbComponentStyle == .iOS) ? iOSThumbShadowRadius : thumbShadowRadius
            let shadowOffset = (thumbComponentStyle == .iOS) ? iOSThumbShadowOffset : thumbShadowOffset

            thumbLayer.frame = ((shadowRadius != 0.0)  // Ignore offset if there is no shadow
                ? rectangle.insetBy(dx: shadowRadius + shadowOffset.width,
                                    dy: shadowRadius + shadowOffset.height)
                : rectangle.insetBy(dx: shadowRadius,
                                    dy: shadowRadius))

            switch thumbComponentStyle {
            case .rounded: // A rounded thumb is circular
                thumbLayer.backgroundColor = (thumbTintColor ?? UIColor.lightGray).cgColor
                thumbLayer.borderColor = UIColor.clear.cgColor
                thumbLayer.borderWidth = 0.0
                thumbLayer.cornerRadius = thumbLayer.frame.width/2
                thumbLayer.allowsEdgeAntialiasing = true

            case .image:
                // image is set using layer.contents
                thumbLayer.backgroundColor = UIColor.clear.cgColor
                thumbLayer.borderColor = UIColor.clear.cgColor
                thumbLayer.borderWidth = 0.0
                thumbLayer.cornerRadius = 0.0
                thumbLayer.allowsEdgeAntialiasing = false

            case .rectangular:
                thumbLayer.backgroundColor = (thumbTintColor ?? UIColor.lightGray).cgColor
                thumbLayer.borderColor = UIColor.clear.cgColor
                thumbLayer.borderWidth = 0.0
                thumbLayer.cornerRadius = 0.0
                thumbLayer.allowsEdgeAntialiasing = false

            case .invisible:
                thumbLayer.backgroundColor = UIColor.clear.cgColor
                thumbLayer.cornerRadius = 0.0

            case .iOS:
                fallthrough

            default:
                thumbLayer.backgroundColor = (thumbTintColor ?? UIColor.white).cgColor

                // Only default iOS thumb has a border
                if nil == thumbTintColor {
                    let borderColor = UIColor(white:0.5, alpha: 1)
                    thumbLayer.borderColor = borderColor.cgColor
                    thumbLayer.borderWidth = 0.25
                } else {
                    thumbLayer.borderWidth = 0
                }
                thumbLayer.cornerRadius = thumbLayer.frame.width/2
                thumbLayer.allowsEdgeAntialiasing = true
                break
            }

            // Shadow
            if(shadowRadius != 0.0) {
                #if TARGET_INTERFACE_BUILDER
                thumbLayer.shadowOffset = CGSize(width: shadowOffset.width,
                                                 height: -shadowOffset.height)
                #else // !TARGET_INTERFACE_BUILDER
                thumbLayer.shadowOffset = shadowOffset
                #endif // TARGET_INTERFACE_BUILDER

                thumbLayer.shadowRadius = shadowRadius
                thumbLayer.shadowColor = UIColor.black.cgColor
                thumbLayer.shadowOpacity = 0.15
            } else {
                thumbLayer.shadowRadius = 0.0
                thumbLayer.shadowOffset = CGSize.zero
                thumbLayer.shadowColor = UIColor.clear.cgColor
                thumbLayer.shadowOpacity = 0.0
            }
        }
    }

    func layoutTrack() {
        assert(tickCount > 1, "2 ticks minimum \(tickCount)")
        let segments = max(1, tickCount - 1)
        let thumbWidth = thumbSizeIncludingShadow().width

        // Calculate the track ticks positions
        let trackHeight = (.iOS == trackComponentStyle) ? 2 : trackThickness
        var trackSize = CGSize(width: frame.width - thumbWidth,
                               height: trackHeight)
        if(.image == trackComponentStyle) {
            if let image = trackImage {
                trackSize.width = image.size.width - thumbWidth
            }
        }

        trackRectangle = CGRect(x: (frame.width - trackSize.width)/2,
                                y: (frame.height - trackSize.height)/2,
                                width: trackSize.width,
                                height: trackSize.height)
        let trackY = frame.height / 2
        ticksAbscissae = []
        for iterate in 0 ... segments {
            let ratio = Double(iterate) / Double(segments)
            let originX = trackRectangle.origin.x + (CGFloat)(trackSize.width * CGFloat(ratio))
            ticksAbscissae.append(CGPoint(x: originX, y: trackY))
        }
        layoutThumb()

        // If we have a TGPDiscreteSliderTicksListener (such as TGPCamelLabels), broadcast new spacing
        ticksListener?.tgpTicksDistanceChanged(ticksDistance:ticksDistance, sender:self)
        setNeedsDisplay()
    }

    func layoutThumb() {
        assert(tickCount > 1, "2 ticks minimum \(tickCount)")
        let segments = max(1, tickCount - 1)

        // Calculate the thumb position
        let nonZeroIncrement = ((0 == incrementValue) ? 1 : incrementValue)
        var thumbRatio = Double(value - minimumValue) / Double(segments * nonZeroIncrement)
        thumbRatio = max(0.0, min(thumbRatio, 1.0)) // Normalized
        thumbRatio = (.rightToLeft == localeCharacterDirection)
            ? 1.0 - thumbRatio
            : thumbRatio
        thumbAbscissa = trackRectangle.origin.x + (CGFloat)(trackRectangle.width * CGFloat(thumbRatio))
    }

    func thumbSizeIncludingShadow() -> CGSize {
        switch thumbComponentStyle {
        case .invisible:
            fallthrough

        case .rectangular:
            fallthrough

        case .rounded:
            return ((thumbShadowRadius != 0.0)
                ? CGSize(width:thumbSize.width
                    + (thumbShadowRadius * 2)
                    + (thumbShadowOffset.width * 2),
                         height: thumbSize.height
                            + (thumbShadowRadius * 2)
                            + (thumbShadowOffset.height * 2))
                : thumbSize)

        case .iOS:
            return CGSize(width: 28.0
                + (iOSThumbShadowRadius * 2)
                + (iOSThumbShadowOffset.width * 2),
                          height: 28.0
                            + (iOSThumbShadowRadius * 2)
                            + (iOSThumbShadowOffset.height * 2))

        case .image:
            if let thumbImage = thumbImage {
                return thumbImage.size
            }
            fallthrough

        default:
            return CGSize(width: 33, height: 33)
        }
    }

    // MARK: UIResponder
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchedInside = true

        touchDown(touches, animationDuration: 0.1)
        sendActionForControlEvent(controlEvent: .valueChanged, with: event)
        sendActionForControlEvent(controlEvent: .touchDown, with:event)

        if let touch = touches.first {
            if touch.tapCount > 1 {
                sendActionForControlEvent(controlEvent: .touchDownRepeat, with: event)
            }
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDown(touches, animationDuration:0)

        let inside = touchesAreInside(touches)
        sendActionForControlEvent(controlEvent: .valueChanged, with: event)

        if inside != touchedInside { // Crossing boundary
            sendActionForControlEvent(controlEvent: (inside) ? .touchDragEnter : .touchDragExit,
                                      with: event)
            touchedInside = inside
        }
        // Drag
        sendActionForControlEvent(controlEvent: (inside) ? .touchDragInside : .touchDragOutside,
                                  with: event)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches)

        sendActionForControlEvent(controlEvent: .valueChanged, with: event)
        sendActionForControlEvent(controlEvent: (touchesAreInside(touches)) ? .touchUpInside : .touchUpOutside,
                                  with: event)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches)

        sendActionForControlEvent(controlEvent: .valueChanged, with:event)
        sendActionForControlEvent(controlEvent: .touchCancel, with:event)
    }


    // MARK: Touches

    func touchDown(_ touches: Set<UITouch>, animationDuration duration:TimeInterval) {
        if let touch = touches.first {
            let location = touch.location(in: touch.view)
            moveThumbTo(abscissa: location.x, animationDuration: duration)
        }
    }

    func touchUp(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            let location = touch.location(in: touch.view)
            let tick = pickTickFromSliderPosition(abscissa: location.x)
            moveThumbToTick(tick: tick)
        }
    }

    func touchesAreInside(_ touches: Set<UITouch>) -> Bool {
        var inside = false
        if let touch = touches.first {
            let location = touch.location(in: touch.view)
            if let bounds = touch.view?.bounds {
                inside = bounds.contains(location)
            }
        }
        return inside
    }

    // MARK: Notifications

    func moveThumbToTick(tick: UInt) {
        let nonZeroIncrement = ((0 == incrementValue) ? 1 : incrementValue)
        let intValue = Int(minimumValue) + (Int(tick) * nonZeroIncrement)
        if intValue != self.intValue {
            self.intValue = intValue
            sendActionsForControlEvents()
        }

        layoutThumb()
        setNeedsDisplay()
    }

    func moveThumbTo(abscissa:CGFloat, animationDuration duration:TimeInterval) {
        let leftMost = trackRectangle.minX
        let rightMost = trackRectangle.maxX

        thumbAbscissa = max(leftMost, min(abscissa, rightMost))
        CATransaction.setAnimationDuration(duration)

        let tick = pickTickFromSliderPosition(abscissa: thumbAbscissa)
        let nonZeroIncrement = ((0 == incrementValue) ? 1 : incrementValue)
        let intValue = Int(minimumValue) + (Int(tick) * nonZeroIncrement)
        if intValue != self.intValue {
            self.intValue = intValue
            sendActionsForControlEvents()
        }

        setNeedsDisplay()
    }

    func pickTickFromSliderPosition(abscissa: CGFloat) -> UInt {
        let leftMost = trackRectangle.minX
        let rightMost = trackRectangle.maxX
        let clampedAbscissa = max(leftMost, min(abscissa, rightMost))
        var ratio = Double(clampedAbscissa - leftMost) / Double(rightMost - leftMost)
        ratio = (.rightToLeft == localeCharacterDirection)
            ? 1.0 - ratio
            : ratio
        let segments = max(1, tickCount - 1)
        return UInt(round( Double(segments) * ratio))
    }

    func sendActionForControlEvent(controlEvent:UIControl.Event, with event:UIEvent?) {
        for target in allTargets {
            if let caActions = actions(forTarget: target, forControlEvent: controlEvent) {
                for actionName in caActions {
                    sendAction(NSSelectorFromString(actionName), to: target, for: event)
                }
            }
        }
    }

    #if TARGET_INTERFACE_BUILDER
    // MARK: TARGET_INTERFACE_BUILDER stub
    //       Interface builder hides the IBInspectable for UIControl

    let allTargets: Set<AnyHashable> = Set()
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {}
    func actions(forTarget target: Any?, forControlEvent controlEvent: UIControlEvents) -> [String]? { return nil }
    func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {}
    #endif // TARGET_INTERFACE_BUILDER    
}
