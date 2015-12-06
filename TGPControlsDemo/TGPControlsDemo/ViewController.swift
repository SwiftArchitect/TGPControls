//    @file:    ViewController.swift
//    @project: TGPControlsDemo (TGPControls)
//
//    @history: Created November 27, 2014 (Thanksgiving Day)
//    @author:  Xavier Schott
//              mailto://xschott@gmail.com
//              http://thegothicparty.com
//              tel://+18089383634
//
//    @license: http://opensource.org/licenses/MIT
//    Copyright (c) 2014, Xavier Schott
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alphabetLabels.names = ["A","B","C","D","E","F", "G","H","I","J","K","L","M",
        "N","O","P","Q","R","S", "T","U","V","W","X","Y","Z"]
        self.pictureLabels.names = ["orient", "occident", "zénith", "nadir", "septentrion", "midi"]
        self.switch1Camel.names = ["OFF", "ON"]
        self.switch2Camel.names = ["O", "l"]
        
        // Automatically track tick spacing changes and UIControlEventValueChanged
        self.alphabetSlider.ticksListener = self.alphabetLabels
        self.oneTo10Slider.ticksListener = self.oneTo10Labels
        self.pictureSlider.ticksListener = self.pictureLabels

        // UIControlEvents
        self.dualColorSlider.addTarget(self, action: "touchDown:event:", forControlEvents: .TouchDown)
        self.dualColorSlider.addTarget(self, action: "touchDownRepeat:event:", forControlEvents: .TouchDownRepeat)
        self.dualColorSlider.addTarget(self, action: "touchDragInside:event:", forControlEvents: .TouchDragInside)
        self.dualColorSlider.addTarget(self, action: "touchDragOutside:event:", forControlEvents: .TouchDragOutside)
        self.dualColorSlider.addTarget(self, action: "touchDragEnter:event:", forControlEvents: .TouchDragEnter)
        self.dualColorSlider.addTarget(self, action: "touchDragExit:event:", forControlEvents: .TouchDragExit)
        self.dualColorSlider.addTarget(self, action: "touchUpInside:event:", forControlEvents: .TouchUpInside)
        self.dualColorSlider.addTarget(self, action: "touchUpOutside:event:", forControlEvents: .TouchUpOutside)
        self.dualColorSlider.addTarget(self, action: "touchCancel:event:", forControlEvents: .TouchCancel)
        self.dualColorSlider.addTarget(self, action: "valueChanged:event:", forControlEvents: .ValueChanged)
    }

    // MARK: - UISwitch
    
    @IBAction func switch1ValueChanged(sender: UISwitch) {
        self.switch1Camel.value = (sender.on) ? 1 : 0
    }
    
    @IBAction func switch2TouchUpInside(sender: UISwitch) {
        self.switch2Camel.value = (sender.on) ? 1 : 0
    }

    // MARK: - UIControlEvents

    func touchDown(sender: UIControl, event:UIEvent) {
        self.controlEventsLabel.text = "touchDown"
    }
    func touchDownRepeat(sender: UIControl, event:UIEvent) {
        self.controlEventsLabel.text = "touchDownRepeat"
    }
    func touchDragInside(sender: UIControl, event:UIEvent) {
        self.controlEventsLabel.text = "touchDragInside"
    }
    func touchDragOutside(sender: UIControl, event:UIEvent) {
        self.controlEventsLabel.text = "touchDragOutside"
    }
    func touchDragEnter(sender: UIControl, event:UIEvent) {
        self.controlEventsLabel.text = "touchDragEnter"
    }
    func touchDragExit(sender: UIControl, event:UIEvent) {
        self.controlEventsLabel.text = "touchDragExit"
    }
    func touchUpInside(sender: UIControl, event:UIEvent) {
        self.controlEventsLabel.text = "touchUpInside"
    }
    func touchUpOutside(sender: UIControl, event:UIEvent) {
        self.controlEventsLabel.text = "touchUpOutside"
    }
    func touchCancel(sender: UIControl, event:UIEvent) {
        self.controlEventsLabel.text = "touchCancel"
    }
    func valueChanged(sender: TGPDiscreteSlider, event:UIEvent) {
        self.controlEventsLabel.text = "valueChanged"
        self.stepper.value = Double(sender.value)
    }

    // MARK: - UIStepper

    @IBAction func stepperValueChanged(sender: UIStepper) {
        self.dualColorSlider.value = CGFloat(sender.value)
    }
}

