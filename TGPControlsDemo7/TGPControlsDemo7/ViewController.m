//    @file:    ViewController.m
//    @project: TGPControlsDemo7 (TGPControls)
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

#import "ViewController.h"
#import "TGPDiscreteSlider7.h"
#import "TGPCamelLabels7.h"

@interface ViewController ()

// iOS 7 does not support IBInspectable, so use the .7 class for both controls.
// If your project targets iOS 8+, you should use TGPDiscreteSlider & TGPCamelLabels instead

@property (weak, nonatomic) IBOutlet TGPCamelLabels7 *oneTo10Labels;
@property (weak, nonatomic) IBOutlet TGPDiscreteSlider7 *oneTo10Slider;

@property (weak, nonatomic) IBOutlet TGPCamelLabels7 *alphabetLabels;
@property (weak, nonatomic) IBOutlet TGPDiscreteSlider7 *alphabetSlider;

@property (weak, nonatomic) IBOutlet TGPCamelLabels7 * pictureLabels;
@property (weak, nonatomic) IBOutlet TGPDiscreteSlider7 * pictureSlider;

@property (weak, nonatomic) IBOutlet TGPCamelLabels7 *switch1Camel;
@property (weak, nonatomic) IBOutlet TGPCamelLabels7 *switch2Camel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alphabetLabels.names = @[@"A",@"B",@"C",@"D",@"E",@"F", @"G",@"H",@"I",@"J",@"K",@"L",@"M",
                                  @"N",@"O",@"P",@"Q",@"R",@"S", @"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    self.pictureLabels.names = @[@"orient", @"occident", @"zénith", @"nadir", @"septentrion", @"midi"];
    self.switch1Camel.names = @[@"OFF", @"ON"];
    self.switch2Camel.names = @[@"O", @"l"];

    // Automatically track tick spacing changes
    self.alphabetSlider.ticksListener = self.alphabetLabels;
    self.oneTo10Slider.ticksListener = self.oneTo10Labels;
    self.pictureSlider.ticksListener = self.pictureLabels;
}

#pragma mark - UISwitch

- (IBAction)switch1ValueChanged:(UISwitch *)sender {
    [self.switch1Camel setValue:((sender.isOn) ? 1 : 0)];
}

- (IBAction)switch2TouchUpInside:(UISwitch *)sender {
    [self.switch2Camel setValue:((sender.isOn) ? 1 : 0)];
}

@end