//    @file:    TGPCamelLabels7.h
//    @project: TGPControls
//
//    @history: Created July 4th, 2014 (Independence Day)
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

#import <UIKit/UIKit.h>
#import "TGPControlsTicksProtocol.h"

@interface TGPCamelLabels7 : UIControl <TGPControlsTicksProtocol>

@property (nonatomic, assign) NSUInteger tickCount; // Only used if [labels count] < 1
@property (nonatomic, assign) CGFloat ticksDistance;
@property (nonatomic, assign) NSUInteger value;

@property (nonatomic, strong) NSString * upFontName;
@property (nonatomic, assign) CGFloat upFontSize;
@property (nonatomic, strong) UIColor * upFontColor;

@property (nonatomic, strong) NSString * downFontName;
@property (nonatomic, assign) CGFloat downFontSize;
@property (nonatomic, strong) UIColor * downFontColor;

@property (nonatomic, strong) NSArray * names; // Will dictate the number of ticks
@property (nonatomic, assign) NSTimeInterval animationDuration;

// Label off-center to the left and right of the slider, expressed in label width. 0: none, -1/2 half out, 1/2 half in
@property (nonatomic, assign) CGFloat offCenter;

// Label margins to the left and right of the slider
@property (nonatomic, assign) NSInteger insets;

// Where should emphasized labels be drawn (10: centerY, 3: top, 4: bottom)
// By default, emphasized labels are animated towards the top of the frame.
// This creates the dock effect (camel). They can also be centered vertically, or move down (reverse effect).
@property (nonatomic) IBInspectable NSInteger emphasisLayout;

// Where should regular labels be drawn (10: centerY, 3: top, 4: bottom)
// By default, emphasized labels are animated towards the bottom of the frame.
// This creates the dock effect (camel). They can also be centered vertically, or move up (reverse effect).
@property (nonatomic) IBInspectable NSInteger regularLayout;

#pragma mark IBInspectable adapters

@property (nonatomic) NSLayoutAttribute emphasisLayoutAttribute;
@property (nonatomic) NSLayoutAttribute regularLayoutAttribute;

@end
