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
    
    @IBOutlet weak var switch1Camel: TGPCamelLabels!
    @IBOutlet weak var switch2Camel: TGPCamelLabels!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.oneTo10Slider.addTarget(self, action: "oneTo10SliderValueChanged:", forControlEvents: .ValueChanged)
        self.alphabetSlider.addTarget(self, action: "alphabetSliderValueChanged:", forControlEvents: .ValueChanged)
        self.alphabetLabels.names = ["A","B","C","D","E","F", "G","H","I","J","K","L","M",
        "N","O","P","Q","R","S", "T","U","V","W","X","Y","Z"]
        self.switch1Camel.names = ["OFF", "ON"]
        self.switch2Camel.names = ["O", "l"]
        
        // Match the ticks spacing exactly
        self.alphabetSlider.ticksListener = self.alphabetLabels
        self.oneTo10Slider.ticksListener = self.oneTo10Labels
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TGPDiscreteSlider
    
    @IBAction func oneTo10SliderValueChanged(sender: TGPDiscreteSlider) {
        self.oneTo10Labels.value = UInt(sender.value);
    }

    @IBAction func alphabetSliderValueChanged(sender: TGPDiscreteSlider) {
        self.alphabetLabels.value = UInt(sender.value)
    }
    
    // MARK: - UISwitch
    
    @IBAction func switch1ValueChanged(sender: UISwitch) {
        self.switch1Camel.value = (sender.on) ? 1 : 0
    }
    
    @IBAction func switch2TouchUpInside(sender: UISwitch) {
        self.switch2Camel.value = (sender.on) ? 1 : 0
    }
}

