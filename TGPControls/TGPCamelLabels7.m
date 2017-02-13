//    @file:    TGPCamelLabels7.m
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

#import "TGPCamelLabels7.h"

@interface TGPCamelLabels7()
@property (nonatomic, assign) NSUInteger lastValue;
@property (nonatomic, retain) NSMutableArray * emphasizedLabels;
@property (nonatomic, retain) NSMutableArray * regularLabels;
@end

@implementation TGPCamelLabels7

#pragma mark properties

- (void)setTickCount:(NSUInteger)tickCount {
    // calculated property
    // Put some order to tickCount: 1 >= count >=  128
    const unsigned int count = (unsigned int) MAX(1, MIN(tickCount, 128));
    [self debugNames:count];
    [self layoutTrack];
}

- (NSUInteger)tickCount {
    // Dynamic property
    return [_names count];
}

- (void)setTicksDistance:(CGFloat)ticksDistance {
    _ticksDistance = MAX(0, ticksDistance);
    [self layoutTrack];
}

- (void)setValue:(NSUInteger)value {
    _value = value;
    [self dockEffect:self.animationDuration];
}

- (void)setUpFontName:(NSString *)upFontName {
    _upFontName = upFontName;
    [self layoutTrack];
}

- (void)setUpFontSize:(CGFloat)upFontSize {
    _upFontSize = upFontSize;
    [self layoutTrack];
}

- (void)setUpFontColor:(UIColor *)upFontColor {
    _upFontColor = upFontColor;
    [self layoutTrack];
}

- (void)setDownFontName:(NSString *)downFontName {
    _downFontName = downFontName;
    [self layoutTrack];
}

- (void)setDownFontSize:(CGFloat)downFontSize {
    _downFontSize = downFontSize;
    [self layoutTrack];
}

- (void)setDownFontColor:(UIColor *)downFontColor {
    _downFontColor = downFontColor;
    [self layoutTrack];
}

- (void)setOffCenter:(CGFloat)offCenter {
    _offCenter = offCenter;
    [self layoutTrack];
}

- (void)setInsets:(NSInteger)insets {
    _insets = insets;
    [self layoutTrack];
}

- (void)setEmphasisLayout:(NSInteger)emphasisLayout {
    _emphasisLayout = ([self validAttribute:emphasisLayout]
                       ? emphasisLayout
                       : NSLayoutAttributeTop);
    [self layoutTrack];
}

- (void)setRegularLayout:(NSInteger)regularLayout {
    _regularLayout = ([self validAttribute:regularLayout]
                      ? regularLayout
                      : NSLayoutAttributeBottom);
    [self layoutTrack];
}

// NSArray<NSString*>
- (void)setNames:(NSArray *)names {
    NSAssert(names.count > 0, @"names.count");
    _names = names;
    [self layoutTrack];
}

#pragma mark IBInspectable adapters

- (NSLayoutAttribute)emphasisLayoutAttribute {
    return ([self validAttribute:_emphasisLayout]
            ? _emphasisLayout
            : NSLayoutAttributeTop);
}

- (void)setEmphasisLayoutAttribute:(NSLayoutAttribute)emphasisLayoutAttribute {
    self.emphasisLayout = emphasisLayoutAttribute;
}

- (NSLayoutAttribute)regularLayoutAttribute {
    return ([self validAttribute:_regularLayout]
            ? _regularLayout
            : NSLayoutAttributeBottom);
}

- (void)setRegularLayoutAttribute:(NSLayoutAttribute)regularLayoutAttribute {
    self.regularLayout = regularLayoutAttribute;
}

#pragma mark UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        [self initProperties];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self initProperties];
    }
    return self;
}

// When bounds change, recalculate layout
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self layoutTrack];
    [self setNeedsDisplay];
}

// clickthrough
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

#pragma mark TGPCamelLabels

- (void)initProperties {
    _ticksDistance = 44.0;
    _value = 0;
    [self debugNames:10];

    _upFontName = nil;
    _upFontSize = 12;
    _upFontColor = nil;

    _downFontName = nil;
    _downFontSize = 12;
    _downFontColor = nil;

    _emphasizedLabels = [NSMutableArray array];
    _regularLabels = [NSMutableArray array];

    _lastValue = NSNotFound;    // Never tapped
    _animationDuration = 0.15;
    
    _offCenter = 0.0;
    _insets = 0;

    _emphasisLayout = NSLayoutAttributeTop;
    _regularLayout = NSLayoutAttributeBottom;

    [self layoutTrack];
}

- (void)debugNames:(unsigned int)count {
    // Dynamic property, will create an array with labels, generally for debugging purposes
    const NSMutableArray * array = [NSMutableArray array];
    for(int iterate = 1; iterate <= count; iterate++) {
        [array addObject:[NSString stringWithFormat:@"%d", iterate ]];
    }
    [self setNames:(NSArray *) array];
}

- (void)layoutTrack {
    for( UIView * view in self.emphasizedLabels) {
        [view removeFromSuperview];
    }
    [self.emphasizedLabels removeAllObjects];
    for( UIView * view in self.regularLabels) {
        [view removeFromSuperview];
    }
    [self.regularLabels removeAllObjects];

    const NSUInteger count = self.names.count;
    if( count > 0) {
        CGFloat centerX = (self.bounds.size.width - ((count - 1) * self.ticksDistance))/2.0;
        const CGFloat centerY = self.bounds.size.height / 2.0;
        for(NSString * name in self.names) {
            UILabel * upLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.emphasizedLabels addObject:upLabel];
            upLabel.text = name;
            upLabel.font = ((self.upFontName != nil)
                            ? [UIFont fontWithName:self.upFontName size:self.upFontSize]
                            : [UIFont boldSystemFontOfSize:self.upFontSize]);
            upLabel.textColor = ((self.upFontColor != nil)
                                 ? self.upFontColor
                                 : self.tintColor);
            [upLabel sizeToFit];
            upLabel.center = CGPointMake(centerX, centerY);
            upLabel.frame = ({
                CGRect frame = upLabel.frame;
                frame.origin.y = self.bounds.size.height - frame.size.height;
                frame;
            });
            upLabel.alpha = 0.0;
            [self addSubview:upLabel];

            UILabel * dnLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.regularLabels addObject:dnLabel];
            dnLabel.text = name;
            dnLabel.font = ((self.downFontName != nil)
                            ? [UIFont fontWithName:self.downFontName size:self.downFontSize]
                            : [UIFont boldSystemFontOfSize:self.downFontSize]);
            dnLabel.textColor = ((self.downFontColor != nil)
                                 ? self.downFontColor
                                 : [UIColor grayColor]);
            [dnLabel sizeToFit];
            dnLabel.center = CGPointMake(centerX, centerY);
            dnLabel.frame = ({
                CGRect frame = dnLabel.frame;
                frame.origin.y = self.bounds.size.height - frame.size.height;
                frame;
            });
            [self addSubview:dnLabel];

            centerX += self.ticksDistance;
        }

        // Fix left and right label, if there are at least 2 labels
        if( [self.names count] > 1) {
            [self insetView:[self.emphasizedLabels firstObject] withInset:self.insets withMultiplier:self.offCenter];
            [self insetView:[self.emphasizedLabels lastObject] withInset:-self.insets withMultiplier:-self.offCenter];
            [self insetView:[self.regularLabels firstObject] withInset:self.insets withMultiplier:self.offCenter];
            [self insetView:[self.regularLabels lastObject] withInset:-self.insets withMultiplier:-self.offCenter];
        }

        [self dockEffect:0.0];
    }
}

- (void) insetView:(UIView*)view withInset:(NSInteger)inset withMultiplier:(CGFloat)multiplier {
    view.frame = ({
        CGRect frame = view.frame;
        frame.origin.x += frame.size.width * multiplier;
        frame.origin.x += inset;
        frame;
    });
}

- (void)dockEffect:(NSTimeInterval)duration
{
    const NSUInteger emphasized = self.value;

    // Unlike the National Parks from which it is inspired, this Dock Effect
    // does not abruptly change from BOLD to plain. Instead, we have 2 sets of
    // labels, which are faded back and forth, in unisson.
    // - BOLD to plain
    // - Black to gray
    // - high to low
    // Each animation picks up where the previous left off
    void (^moveBlock)() = ^void() {
        // De-emphasize almost all
        [self.emphasizedLabels enumerateObjectsUsingBlock:^(UILabel * label, NSUInteger idx, BOOL *stop) {
            if( emphasized != idx) {
                [self verticalAlign:label
                              alpha:0
                          attribute:self.regularLayoutAttribute];
            }
        }];
        [self.regularLabels enumerateObjectsUsingBlock:^(UILabel * label, NSUInteger idx, BOOL *stop) {
            if( emphasized != idx) {
                [self verticalAlign:label
                              alpha:1
                          attribute:self.regularLayoutAttribute];
            }
        }];

        // Emphasize the selection
        if(emphasized < [self.emphasizedLabels count]) {
            [self verticalAlign:[self.emphasizedLabels objectAtIndex:emphasized]
                          alpha:1
                      attribute:self.emphasisLayoutAttribute];
        }
        if(emphasized < [self.regularLabels count]) {
            [self verticalAlign:[self.regularLabels objectAtIndex:emphasized]
                          alpha:0
                      attribute:self.emphasisLayoutAttribute];
        }
    };

    if(duration > 0) {
        [UIView animateWithDuration:duration
                              delay:0
                            options:(UIViewAnimationOptionBeginFromCurrentState +
                                     UIViewAnimationOptionCurveLinear)
                         animations:moveBlock
                         completion:nil];
    } else {
        moveBlock();
    }
}

- (BOOL)validAttribute:(NSLayoutAttribute)attribute {
    NSArray * validAttributes = @[
                                  @(NSLayoutAttributeTop),      // 3
                                  @(NSLayoutAttributeCenterY),  // 10
                                  @(NSLayoutAttributeBottom)    // 4
                                  ];
    BOOL valid = [validAttributes containsObject:@(attribute)];
    return valid;
}

- (void)verticalAlign:(UIView *)aView alpha:(CGFloat) alpha attribute:(NSLayoutAttribute) layout {
    switch(layout) {
        case NSLayoutAttributeTop:
            aView.frame = ({
                CGRect frame = aView.frame;
                frame.origin.y = 0;
                frame;
            });
            break;

        case NSLayoutAttributeBottom:
            aView.frame = ({
                CGRect frame = aView.frame;
                frame.origin.y = self.bounds.size.height - frame.size.height;
                frame;
            });
            break;

        default: // NSLayoutAttributeCenterY
            aView.frame = ({
                CGRect frame = aView.frame;
                frame.origin.y = (self.bounds.size.height - frame.size.height) / 2;
                frame;
            });
    }
    aView.alpha = alpha;
}

#pragma mark - TGPControlsTicksProtocol

- (void)tgpTicksDistanceChanged:(CGFloat)ticksDistance sender:(id)sender
{
    self.ticksDistance = ticksDistance;
}

- (void)tgpValueChanged:(unsigned int)value
{
    self.value = value;
}
@end
