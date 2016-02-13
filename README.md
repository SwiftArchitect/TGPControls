# TGPControls Swift & Obj-C
##TGPDiscreteSlider
![ticksdemo](https://cloud.githubusercontent.com/assets/4073988/5912371/144aaf24-a588-11e4-9a22-42832eb2c235.gif)

A slider with discrete steps, discrete range, with customizable track, thumb and ticks.
Ideal to select steps.

##TGPCamelLabels
![camellabels2](https://cloud.githubusercontent.com/assets/4073988/5912454/15774398-a589-11e4-8f08-18c9c7b59871.gif)

A set of animated labels representing a selection. Can be used alone or in conjunction with a UIControl.
Ideal to represent steps. *The discrete slider and the camel labels can work in unison.*

##Compatibility
TGPControls are **AutoLayout** ready, support **iOS 9 & iOS 8** `IB Designable` and `IB Inspectable` properties, yet runs as far back as **iOS 7**. Comes with two demo applications, one in **Swift** and one in **Objective-C**.

![imagessliderdemo](https://cloud.githubusercontent.com/assets/4073988/6628373/183c7452-c8c2-11e4-9a63-107805bc0cc4.gif)

|Copyright disclaimer|
|:---|
|The above slider is inspired by [National Parks by National Geographic](https://itunes.apple.com/us/app/national-parks-by-national/id518426085?mt=8) iPhone App.|
|National Parks iPhone App is developped by [Rally Interactive LLC](http://rallyinteractive.com).|
|The above image, styling, appearance and look & feel all [Copyright &copy; 2015 National Geographic Society](http://www.nationalgeographic.com).|
|TGPControls is *not* associated with National Geographic Society, Rally Interactive LLC or any of it's subsidiaries.|

##Fully Customizable

![alphabetslider](https://cloud.githubusercontent.com/assets/4073988/5912297/c3f21bb2-a586-11e4-8eb1-a1f930ccbdd5.gif)

Control everything about the slider or its labels, starting with colors, images and fonts, including track and ticks shape, and thumb shadows.
All computations regarding range and sizing and handled automatically.
Use the two classes in tandem to create stunning new controls, which can be resized dynamically, to intergrate beautifully into your application.

![onoff](https://cloud.githubusercontent.com/assets/4073988/5912516/36af8006-a58a-11e4-91bf-03ef24476645.gif)

Most customization can be done in **Interface Builder** and require **0 coding**.


##How to integrate
Using [CocoaPods](http://cocoapods.org/?q=TGPControls)
- **iOS 9 and later, iOS 8**: install CocoaPods 0.36.0+ [CocoaPods-Frameworks](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/), add `use_frameworks!` to your podfile.
- **iOS 7**: restrict yourself to `TGPCamelLabels7.{h,m}` and `TGPDiscreteSlider7.{h,m}`. Compatible with CocoaPods 0.35.0.
*Note: When integrating into an iOS 7 project, use the TGPCamelLabels7 and TGPDiscreteSlider7 classes in Interface Builder.*

Besides customization, which you can do entirely under Interface Builder in iOS 8 and later, both `TGPDiscreteSlider` and `TGPCamelLabels` require surprisingly little code to integrate.

###TGPDiscreteSlider

For simplicity, TGPDiscreteSlider does *not* descend from UISlider but from **UIControl**.
It uses a `minimumValue`, a `tickCount` and an `incrementValue` (instead of *minimumValue* and *maximumValue*).
All graphic aspects, such as physical spacing of the ticks or physical width of the track are controlled internally.
This makes TGPDiscreteSlider predictable. it is guaranteed to always fit snuggly inside its bounds.

**Step 1**: *register* to notifications (*just like any UIControl*)
```
[self.discreteSlider addTarget:self
                        action:@selector(discreteSliderValueChanged:)
              forControlEvents:UIControlEventValueChanged];
```
**Step 2**: *respond* to notification
```
- (IBAction)discreteSliderValueChanged:(TGPDiscreteSlider *)sender {
    [self.camelLabels setValue:sender.value];
}
```
That's all, and all you need to create this control:

![complete](https://cloud.githubusercontent.com/assets/4073988/5912616/26cf1b0a-a58b-11e4-92f7-f9dbcd53c413.gif)

**Change tickStyle, trackStyle, thumbStyle to be one of:**
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
[self.camelLabels setValue:sender.value];
```

*There is no step 2.*

For ease of use, most of the customization can be done inside Interface Builder.
You may, however, be interested in these 3 properties programatically:
- `ticksListener` allows you tie a discrete slider to its camel labels. This is your most robust method to not only ensure that the layout of both controls match exactly, but also adjust this spacing when orientation changes. A typical use may be
`self.discreteSlider.ticksListener = self.camelLabels`

- `names` allows you to supply a new set of labels. This supersedes the `tickCount` property, which will return the number of labels. A typical use may be
`self.camelLabels.names = @[@"OFF", @"ON"];`

- `ticksDistance`, a less common property, allows you to override the labels spacing entirely. Prefer the `ticksListener` mechanism if it is available to you. A typical use may be
`self.camelLabels.ticksDistance = 15`


For convenience TGPCamelLabels becomes *tap-through* (*click-through*) when `backgroundColor` is `clearColor`.
You can then use TGPCamelLabels *on top of* other UI elements:

![uiswitch](https://cloud.githubusercontent.com/assets/4073988/11609813/a3b63526-9b45-11e5-9562-34fc2c9b134d.gif)

###Code example

See **TGPControlsDemo** projects:
 1. `TGPControlsDemo` (iOS 9 & 8 + Swift + IBInspectable)
 2. `TGPControlsDemo7` (iOS 7 + ObjC) projects.

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

    self.alphabetLabels.names = @[@"A",@"B",@"C",@"D",@"E",@"F", @"G",@"H",@"I",@"J",@"K",@"L",@"M",
                                  @"N",@"O",@"P",@"Q",@"R",@"S", @"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    self.switch1Camel.names = @[@"OFF", @"ON"];

    // Automatically track tick spacing changes
    self.alphabetSlider.ticksListener = self.alphabetLabels;
    self.oneTo10Slider.ticksListener = self.oneTo10Labels;
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
###Customization example

![image](https://cloud.githubusercontent.com/assets/4073988/5909892/7fdc091e-a569-11e4-906b-da0f185a1b91.png)

![custom](https://cloud.githubusercontent.com/assets/4073988/5912951/19788d6a-a590-11e4-9e0c-57a79cb5d020.gif)
