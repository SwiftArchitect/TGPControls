import UIKit
import TGPControls

class ViewController: UIViewController {
    @IBOutlet weak var oneTo10Labels: TGPCamelLabels!
    @IBOutlet weak var oneTo10Slider: TGPDiscreteSlider!

    @IBOutlet weak var alphabetLabels: TGPCamelLabels!
    @IBOutlet weak var alphabetSlider: TGPDiscreteSlider!

    @IBOutlet var pictureLabels: TGPCamelLabels!
    @IBOutlet var pictureSlider: TGPDiscreteSlider!

    @IBOutlet weak var switch1Camel: TGPCamelLabels!
    @IBOutlet weak var switch2Camel: TGPCamelLabels!

    @IBOutlet weak var controlEventsLabel: UILabel!
    @IBOutlet weak var dualColorSlider: TGPDiscreteSlider!
    @IBOutlet weak var stepper: UIStepper!

    private func localizedStrings(_ key: String) -> [String] {
        return NSLocalizedString(key, comment: "")
            .split(separator: " ")
            .map({ (substring) -> String in
                return "\(substring)"
            })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        oneTo10Labels.names = localizedStrings("oneTo10Labels.numbers")

        alphabetLabels.names = localizedStrings("alphabetLabels.letters")
        alphabetSlider.tickCount = alphabetLabels.names.count // Number of letters in the given alphabet

        pictureLabels.names = [NSLocalizedString("pictureLabels.east", comment: ""),
                               NSLocalizedString("pictureLabels.west", comment: ""),
                               NSLocalizedString("pictureLabels.up", comment: ""),
                               NSLocalizedString("pictureLabels.down", comment: ""),
                               NSLocalizedString("pictureLabels.north", comment: ""),
                               NSLocalizedString("pictureLabels.south", comment: "")]

        switch1Camel.names = [NSLocalizedString("switch1Camel.off", comment: ""),
                              NSLocalizedString("switch1Camel.on", comment: "")]

        switch2Camel.names = [NSLocalizedString("switch2Camel.off", comment: ""),
                              NSLocalizedString("switch2Camel.on", comment: "")]


        // Automatically track tick spacing changes and UIControlEventValueChanged
        alphabetSlider.ticksListener = alphabetLabels
        oneTo10Slider.ticksListener = oneTo10Labels
        pictureSlider.ticksListener = pictureLabels

        // UIControlEvents
        dualColorSlider.addTarget(self, action: #selector(ViewController.touchDown(_:event:)), for: .touchDown)
        dualColorSlider.addTarget(self, action: #selector(ViewController.touchDownRepeat(_:event:)), for: .touchDownRepeat)
        dualColorSlider.addTarget(self, action: #selector(ViewController.touchDragInside(_:event:)), for: .touchDragInside)
        dualColorSlider.addTarget(self, action: #selector(ViewController.touchDragOutside(_:event:)), for: .touchDragOutside)
        dualColorSlider.addTarget(self, action: #selector(ViewController.touchDragEnter(_:event:)), for: .touchDragEnter)
        dualColorSlider.addTarget(self, action: #selector(ViewController.touchDragExit(_:event:)), for: .touchDragExit)
        dualColorSlider.addTarget(self, action: #selector(ViewController.touchUpInside(_:event:)), for: .touchUpInside)
        dualColorSlider.addTarget(self, action: #selector(ViewController.touchUpOutside(_:event:)), for: .touchUpOutside)
        dualColorSlider.addTarget(self, action: #selector(ViewController.touchCancel(_:event:)), for: .touchCancel)
        dualColorSlider.addTarget(self, action: #selector(ViewController.valueChanged(_:event:)), for: .valueChanged)
    }

    // MARK: - UISwitch

    @IBAction func switch1ValueChanged(_ sender: UISwitch) {
        switch1Camel.value = (sender.isOn) ? 1 : 0
    }

    @IBAction func switch2TouchUpInside(_ sender: UISwitch) {
        switch2Camel.value = (sender.isOn) ? 1 : 0
    }

    // MARK: - UIControlEvents

    @objc func touchDown(_ sender: UIControl, event:UIEvent) {
        controlEventsLabel.text = "touchDown"
    }
    @objc func touchDownRepeat(_ sender: UIControl, event:UIEvent) {
        controlEventsLabel.text = "touchDownRepeat"
    }
    @objc func touchDragInside(_ sender: UIControl, event:UIEvent) {
        controlEventsLabel.text = "touchDragInside"
    }
    @objc func touchDragOutside(_ sender: UIControl, event:UIEvent) {
        controlEventsLabel.text = "touchDragOutside"
    }
    @objc func touchDragEnter(_ sender: UIControl, event:UIEvent) {
        controlEventsLabel.text = "touchDragEnter"
    }
    @objc func touchDragExit(_ sender: UIControl, event:UIEvent) {
        controlEventsLabel.text = "touchDragExit"
    }
    @objc func touchUpInside(_ sender: UIControl, event:UIEvent) {
        controlEventsLabel.text = "touchUpInside"
    }
    @objc func touchUpOutside(_ sender: UIControl, event:UIEvent) {
        controlEventsLabel.text = "touchUpOutside"
    }
    @objc func touchCancel(_ sender: UIControl, event:UIEvent) {
        controlEventsLabel.text = "touchCancel"
    }
    @objc func valueChanged(_ sender: TGPDiscreteSlider, event:UIEvent) {
        controlEventsLabel.text = "valueChanged"
        stepper.value = Double(sender.value)
    }

    // MARK: - UIStepper

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        dualColorSlider.value = CGFloat(sender.value)
    }
}

