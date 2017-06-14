#import "BCMInsightCollection.h"
#import "BCMInsightItem.h"

@interface BCMInsightCollection ()

@property (nonatomic, nonnull, readwrite) OCKBarSeries *series;
@property (nonatomic, nonnull, readwrite) NSArray<NSString *> *axisLabels;
@property (nonatomic, nonnull, readwrite) NSArray<NSString *> *axisSubLabels;

@end

@implementation BCMInsightCollection

-(instancetype)initWithItems:(NSArray<BCMInsightItem *> *)items title:(NSString *)title tintColor:(UIColor *)color
{
    NSAssert(nil != items, @"Must provide items parameter to %s", __PRETTY_FUNCTION__);
    NSAssert(nil != title, @"Must provide title parameter to %s", __PRETTY_FUNCTION__);
    
    self = [super init];
    if (nil == self) { return nil; }
    
    NSArray *sortedItems =
    [items sortedArrayUsingComparator:^NSComparisonResult(BCMInsightItem *item1, BCMInsightItem * item2) {
        if (item1.numberOfDaysSinceStart > item2.numberOfDaysSinceStart) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    
    NSMutableArray<NSNumber *> *sortedValues = [NSMutableArray new];
    NSMutableArray<NSString *> *sortedLabels = [NSMutableArray new];
    NSMutableArray<NSString *> *sortedAxisLabels = [NSMutableArray new];
    NSMutableArray<NSString *> *sortedAxisSubLabels = [NSMutableArray new];
    
    for (BCMInsightItem *item in sortedItems) {
        [sortedValues addObject:[item.value copy]];
        [sortedLabels addObject:[item.label copy]];
        [sortedAxisLabels addObject:[item.axisLabel copy]];
        [sortedAxisSubLabels addObject:[item.axisSubLabel copy]];
    }
    
    _series = [[OCKBarSeries alloc] initWithTitle:title values:[sortedValues copy] valueLabels:[sortedLabels copy] tintColor:color];
    _axisLabels = [sortedAxisLabels copy];
    _axisSubLabels = [sortedAxisSubLabels copy];
    
    return self;
}

@end
