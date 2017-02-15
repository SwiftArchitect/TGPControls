# Slider with _ticks_ & animated Label (Swift)
TGPControls are drop-in replacement of `UISlider` & `UILabel`, with visual preview in **Interface Builder**, single liner instrumentation, smooth animations, simple API,  powerful customization.  

## What's DiscreteSlider?
![ticksdemo](https://cloud.githubusercontent.com/assets/4073988/5912371/144aaf24-a588-11e4-9a22-42832eb2c235.gif)

`TGPDiscreteSlider`: A slider with discrete steps (i.e. ticks), discrete range, with customizable track, thumb and ticks.
Ideal to select individual steps, star rating, integers, rainbow colors, slices and in general any value that is not a continuum. Just set the number of stops, TGPDiscreteSlider handles the selection and the animations for you.

## What's CamelLabels?
![camellabels2](https://cloud.githubusercontent.com/assets/4073988/5912454/15774398-a589-11e4-8f08-18c9c7b59871.gif)

`TGPCamelLabels`: A set of animated labels (dock effect) representing a selection. Can be used alone or in conjunction with a UIControl.
Ideal to represent steps. *The discrete slider and the camel labels can work in unison.*

## Compatibility
1. Written in **Swift 3**, can be integrated with **Swift** or **Obj-C**
2. `TGPControls` are **AutoLayout**, `IB Designable` and `IB Inspectable` ready (†)
3. Version 3.0.0 comes with a **Swift 3** demo application, for **iOS 10** down to **8**. 
(†) Earlier 2.x versions provide **iOS 7** support

![imagessliderdemo](https://cloud.githubusercontent.com/assets/4073988/6628373/183c7452-c8c2-11e4-9a63-107805bc0cc4.gif)

| Copyright disclaimer |
| :--- |
|The above slider is inspired by [National Parks by National Geographic](https://itunes.apple.com/us/app/national-parks-by-national/id518426085?mt=8) iPhone App.|
|National Parks iPhone App is developed by [Rally Interactive LLC](http://rallyinteractive.com).|
|The above image, styling, appearance and look & feel all [Copyright &copy; 2015 National Geographic Society](http://www.nationalgeographic.com).|
|TGPControls is *not* associated with National Geographic Society, Rally Interactive LLC or any of it's subsidiaries.|

## Fully Customizable

![alphabetslider](https://cloud.githubusercontent.com/assets/4073988/5912297/c3f21bb2-a586-11e4-8eb1-a1f930ccbdd5.gif)

Control everything about the slider or its labels, starting with colors, images and fonts, including track and ticks shape, and thumb shadows.
All computations regarding range and sizing and handled automatically.
Use the two classes in tandem to create stunning new controls, which can be resized dynamically, to intergrate beautifully into your application.

![onoff](https://cloud.githubusercontent.com/assets/4073988/5912516/36af8006-a58a-11e4-91bf-03ef24476645.gif)

Most customization can be done in **Interface Builder** and require **zero coding**.


## How to integrate
Using [CocoaPods](http://cocoapods.org/?q=TGPControls)
- **iOS 10 and later down to iOS 8**: install CocoaPods 1.2.0+ [CocoaPods-Frameworks](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/), add `use_frameworks!` to your podfile.
- **iOS 7**: Use TGPControls version 2.1.0

Besides customization, which you can do entirely under Interface Builder in iOS 8 and later, both `TGPDiscreteSlider` and `TGPCamelLabels` require surprisingly little code to integrate.

### DiscreteSlider

For simplicity, TGPDiscreteSlider does *not* descend from UISlider but from **UIControl**.
It uses a `minimumValue`, a `tickCount` and an `incrementValue` (instead of *minimumValue* and *maximumValue*).
All graphic aspects, such as physical spacing of the ticks or physical width of the track are controlled internally. This makes TGPDiscreteSlider predictable. it is guaranteed to always fit snuggly inside its bounds.

**Single step**: To use DiscreteSlider + CamelLabels in tandem, you need exactly **1 line of code**:
```
discreteSlider.ticksListener = camelLabels
```
![complete](https://cloud.githubusercontent.com/assets/4073988/5912616/26cf1b0a-a58b-11e4-92f7-f9dbcd53c413.gif)
That's all!  
Through the `TGPControlsTicksProtocol`, the camelLabels listen to _value_ and _size_ changes. You may want to adopt this protocol to handle changes, or use the traditional `UIControl` notifications:

**Advanced Steps (1a)**: *register* to notifications (*just like any UIControl*)
```
discreteSlider.addTarget(self,
action: #selector(valueChanged(_:event:)),
for: .valueChanged)
```
**Advanced Steps (1b)**: *respond* to notification
```
func valueChanged(_ sender: TGPDiscreteSlider, event:UIEvent) {
self.stepper.value = Double(sender.value)
}
```


**tickStyle, trackStyle, thumbStyle Properties:**

| Constant      | Value        |       |
|:--------------|:------------:| ----- |
| `.iOS` | 0 | Gives to any component the iOS appearance: Ticks are invisible, track is blue and gray, thumb is round with a shadow |
| `.rectangular` | 1 | Boxy look with hard edges |
| `.rounded` | 2      | From rounded rectangles to perfects circles, depending on vertical to horizontal ratio |
| `.invisible` | 3 | Surprisingly useful to individually hide ticks, track, or even thumb |

**Other Properties:**

| Listener |       |
|:-----| ----- |
| `ticksListener` | a `TGPControlsTicksProtocol` listener, such as `TGPCamelLabels`, which receives spacing changes notifications. |
| `allTargets` | Inherited from `UIControl`, receives actions for control event |

| Tick |       |
|:-----| ----- |
| `tickSize` | absolute dimension |
| `tickImage` | Resource name as string, fits in `tickSize` |
| `tickCount` | discrete steps, must be 2 or greater |
| `ticksDistance` | horizontal spacing _(calculated)_ |

| Track |       |
|:------| ----- |
| `trackThickness` | height |
| `trackImage` | resource name as string, ignores `trackThickness` |
| `minimumTrackTintColor` | track lower side |
| `maximumTrackTintColor` | track higher side |

| Thumb |       |
|:------| ----- |
| `thumbSize` | absolute size |
| `thumbImage` | dictates `thumbSize` |
| `thumbTintColor` | background |
| `thumbShadowRadius` | breaking the _flat design concept_ |
| `thumbShadowOffset` | applied to `thumbShadowRadius`, may affect control bounds |



![image](https://cloud.githubusercontent.com/assets/4073988/5910789/e102af28-a572-11e4-9169-b18555e20eab.png)

### CamelLabels

Besides font customization, `TGPCamelLabels` only requires a set of labels (supplied as *strings*), and an active index selection.

**Step 1**: *tell* the TGPCamelLabels what to select
_(Refer to **Single step** section above to use DiscreteSlider + CamelLabels in tandem)_
```
camelLabels.value = sender.value
```

*There is no step 2.*
Most of the customization can be done inside **Interface Builder**.

**Properties:**

| Property |       |
|:---------| ----- |
| `ticksListener` | ties a discrete slider to its camel labels. This is your most robust method to not only ensure that the layout of both controls match exactly, but also adjust this spacing when orientation changes. A typical use may be `discreteSlider.ticksListener = camelLabels` |
| `names` | supplies a new set of labels ; supersedes the `tickCount` property, which will return the number of labels. A typical use may be `camelLabels.names = ["OFF", "ON"]` |
| `ticksDistance` | _override_ the labels spacing entirely ; **prefer** the `ticksListener` mechanism if it is available to you. A typical use may be `camelLabels.ticksDistance = 15` |
| `value` | which label is emphasized (_selected_) |
| `backgroundColor` | labels become  *tap-through* (**click-through**) when set to `UIColor.clear` ; use TGPCamelLabels *on top of* other UI elements, **even native iOS objects**!:![uiswitch](https://cloud.githubusercontent.com/assets/4073988/11609813/a3b63526-9b45-11e5-9562-34fc2c9b134d.gif) |

| Edges & Animation |       |
|:------------------| ----- |
| `offCenter` | **leftmost and righmost labels only**: relative inset expressed as a proportion of individual label width: 0: none, +0.5: nudge in by a half width (fully fit) or -0.5: draw completely outside |
| `insets` | **leftmost and righmost labels only**: absolute inset expressed in pixels |
| `emphasisLayout` | emphasized (_selected_) labels vertical alignment ; `.top`, `.centerY` or `.bottom`. Default is `.top` (†) |
| `regularLayout` | regular labels vertical alignment ; `.top`, `.centerY` or `.bottom`. Default is `.bottom` (†) | 

(†) No camel animation will occur when `emphasisLayout` = `regularLayout`, i.e. `.centerY`.

| Emphasized labels |       |
|:------------------| ----- |
| `upFontName` | font |
| `upFontSize` | size |
| `upFontColor` | color |

| Regular labels |       |
|:---------------| ----- |
| `dnFontName` | font |
| `dnFontSize` | size |
| `dnFontColor` | color |

### Code example

See **TGPControlsDemo** project: `TGPControlsDemo` (Modern Swift syntax + IBInspectable)

```
import UIKit
import TGPControls

class ViewController: UIViewController {
@IBOutlet weak var oneTo10Labels: TGPCamelLabels!
@IBOutlet weak var oneTo10Slider: TGPDiscreteSlider!
@IBOutlet weak var alphabetLabels: TGPCamelLabels!
@IBOutlet weak var alphabetSlider: TGPDiscreteSlider!
@IBOutlet weak var switch1Camel: TGPCamelLabels!

override func viewDidLoad() {
super.viewDidLoad()

alphabetLabels.names = ["A","B","C","D","E","F",
"G","H","I","J","K","L","M",
"N","O","P","Q","R","S",
"T","U","V","W","X","Y","Z"]
switch1Camel.names = ["OFF", "ON"]

// Automatically track tick spacing and value changes
alphabetSlider.ticksListener = alphabetLabels
oneTo10Slider.ticksListener = oneTo10Labels
}

// MARK: - UISwitch

@IBAction func switch1ValueChanged(_ sender: UISwitch) {
switch1Camel.value = (sender.isOn) ? 1 : 0
}
}
```
### Customization examples

![image](https://cloud.githubusercontent.com/assets/4073988/5909892/7fdc091e-a569-11e4-906b-da0f185a1b91.png)

![custom](https://cloud.githubusercontent.com/assets/4073988/5912951/19788d6a-a590-11e4-9e0c-57a79cb5d020.gif)
