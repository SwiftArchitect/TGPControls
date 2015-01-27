# TGPControls
##TGPDiscreteSlider
![image](https://cloud.githubusercontent.com/assets/4073988/5906889/fd99471e-a54f-11e4-8805-31df14795e9b.png)

A slider with discrete steps, discrete range, with customizable track, thumb and ticks.
Ideal to select steps.

##TGPCamelLabels
![image](https://cloud.githubusercontent.com/assets/4073988/5906924/35aadc26-a550-11e4-87bb-c79c717ee95d.png)

A set of animated labels representing a selection. Can be used alone or in conjunction with a UIControl.
Ideal to represent steps.

##Compatibility
TGPControls are **AutoLayout** ready, support **iOS 8** `IB Designable` and `IB Inspectable` properties, yet runs as far back as iOS 7.

##Fully Customizable
![image](https://cloud.githubusercontent.com/assets/4073988/5909892/7fdc091e-a569-11e4-906b-da0f185a1b91.png)

Control everything about the slider or its labels, starting with colors and fonts, including track and ticks shape, and thumb shadows.
All computations regarding range and sizing and handled automatically.
Use the two classes in tandem to create stunning new controls, which can be resized dynamically, to intergrate beautifully into your application.

![image](https://cloud.githubusercontent.com/assets/4073988/5910059/1806d10a-a56b-11e4-83ce-1d1909411305.png)

Most customization can be done in **Interface Builder** and require **0 coding**.

![image](https://cloud.githubusercontent.com/assets/4073988/5910084/6fff8f8c-a56b-11e4-9bb4-3cf4c7e2708b.png)


##How to integrate
Using [CocoaPods](http://cocoapods.org/?q=TGPControls)
- **iOS 8**: install Cocoapods 0.36.0+ [CocoaPods-Frameworks](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/), add `use_frameworks!` to your podfile.
- **iOS 7**: restrict yourself to `TGPCamelLabels7.{h,m}` and `TGPDiscreteSlider7.{h,m}`. Compatible with Cocoapods 0.35.0.
*Note: When integrating into an iOS 7 project, use the TGPCamelLabels7 and TGPDiscreteSlider7 classes in Interface Builder.*

Besides customization, which you can do entirely under Interface Builder in iOS 8, both `TGPDiscreteSlider` and `TGPCamelLabels` require surprisingly little code to integrate.

###TGPDiscreteSlider

For simplicity, TGPDiscreteSlider does not descend from UISlider but from **UIControl**.
It uses a `minimumValue`, a `tickCount` and an `incrementValue` (instead of *minimumValue* and *maximumValue*).
All graphic aspects, such as physical spacing of the ticks or physical width of the track are controlled internally.
This makes TGPDiscreteSlider predictable. it is guarantied to always fit snuggly inside its bounds.

**Step 1**: *register* to notifications (*just like any UIControl*)
```
[self.oneTo10Slider addTarget:self
                       action:@selector(oneTo10SliderValueChanged:)
             forControlEvents:UIControlEventValueChanged];
```
**Step 2**: *respond* to notification
```
- (IBAction)oneTo10SliderValueChanged:(TGPDiscreteSlider *)sender {
    [self.oneTo10Labels setValue:sender.value];
}
```
That's all, and all you need to create this control:

![image](https://cloud.githubusercontent.com/assets/4073988/5910644/3add72b4-a571-11e4-992c-c667d1e9682a.png)

Change tickStyle, trackStyle, thumbStyle to be one of:
- `ComponentStyleIOS` = 0
Gives to any component the iOS appearance. Ticks are invisible, track is blue and gray, thumb is round with a shadow.
- `ComponentStyleRectangular` = 1
Boxy look with hard edges.
- `ComponentStyleRounded` = 2
From rounded rectangles to perfects circles, depending on vertical to horizontal ratio. 
- `ComponentStyleInvisible` = 3
Surprisingly useful to individually hide ticks, track, or even thumb.

![image](https://cloud.githubusercontent.com/assets/4073988/5910789/e102af28-a572-11e4-9169-b18555e20eab.png)

###TGPCamelLabels

Besides font customization, `TGPCamelLabels` only requires a set of labels (supplied as *strings*), and an active index selection.

**Step 1**: *tell* the TGPCamelLabels what to select
```
[self.oneTo10Labels setValue:sender.value];
```

*There is no step 2.*

For ease of use, most of the customization can be done inside Interface Builder.
You may, however, be interested in these 2 properties programatically:
- `ticksDistance` allows you adjust the spacing between tick exactly. A typical use may be
`self.alphabetLabels.ticksDistance = self.alphabetSlider.ticksDistance;`

- `names` allows you to supply a new set of labels. This supersedes the `tickCount` property, which will return the number of labels. A typical use may be
`self.switch1Camel.names = @[@"OFF", @"ON"];`

For convenience TGPCamelLabels becomes *tap-through* (*click-through*) when `backgroundColor` is `clearColor`.
You can then use TGPCamelLabels on top of other UI elements with no ill effet.

![image](https://cloud.githubusercontent.com/assets/4073988/5910599/b775b6e8-a570-11e4-9846-d990ca0f8c9c.png)

###Complete example
```
#import "ViewController.h"
#import "TGPDiscreteSlider.h"
#import "TGPCamelLabels.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet TGPDiscreteSlider *oneTo10Slider;
@property (strong, nonatomic) IBOutlet TGPCamelLabels *oneTo10Labels;

@property (strong, nonatomic) IBOutlet TGPCamelLabels *alphabetLabels;
@property (strong, nonatomic) IBOutlet TGPDiscreteSlider *alphabetSlider;

@property (strong, nonatomic) IBOutlet TGPCamelLabels *switch1Camel;
@property (strong, nonatomic) IBOutlet TGPCamelLabels *switch2Camel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.oneTo10Slider addTarget:self
                            action:@selector(oneTo10SliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    [self.alphabetSlider addTarget:self
                              action:@selector(alphabetSliderValueChanged:)
                    forControlEvents:UIControlEventValueChanged];

    self.alphabetLabels.names = @[@"A",@"B",@"C",@"D",@"E",@"F", @"G",@"H",@"I",@"J",@"K",@"L",@"M",
                                  @"N",@"O",@"P",@"Q",@"R",@"S", @"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    self.switch1Camel.names = @[@"OFF", @"ON"];

    // Match the ticks spacing exactly
    self.alphabetLabels.ticksDistance = self.alphabetSlider.ticksDistance;
    self.oneTo10Labels.ticksDistance = self.oneTo10Slider.ticksDistance;
}

#pragma mark TGPDiscreteSlider

- (IBAction)oneTo10SliderValueChanged:(TGPDiscreteSlider *)sender {
    [self.oneTo10Labels setValue:sender.value];
}

- (IBAction)alphabetSliderValueChanged:(TGPDiscreteSlider *)sender {
    [self.alphabetLabels setValue:sender.value];
}

#pragma mark UISwitch

- (IBAction)switch1ValueChanged:(UISwitch *)sender {
    [self.switch1Camel setValue:((sender.isOn) ? 1 : 0)];
}

- (IBAction)switch2TouchUpInside:(UISwitch *)sender {
    [self.switch2Camel setValue:((sender.isOn) ? 1 : 0)];
}

@end
```
