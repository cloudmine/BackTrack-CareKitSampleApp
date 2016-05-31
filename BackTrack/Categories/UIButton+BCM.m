#import "UIButton+BCM.h"

@implementation UIButton (BCM)

- (void)setCornerRadius:(CGFloat)radius andBorderWidth:(CGFloat)width
{
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor = self.titleLabel.textColor.CGColor;
}

@end
