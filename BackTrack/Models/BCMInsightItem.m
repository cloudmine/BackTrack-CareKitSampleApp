#import "BCMInsightItem.h"

@interface BCMInsightItem ()

@property (nonatomic, nonnull, readwrite, copy) NSNumber *value;
@property (nonatomic, nonnull, readwrite, copy) NSString *label;
@property (nonatomic, nonnull, readwrite, copy) NSString *axisLabel;
@property (nonatomic, nonnull, readwrite, copy) NSString *axisSubLabel;
@property (nonatomic, readwrite) NSUInteger numberOfDaysSinceStart;

@end

@implementation BCMInsightItem

- (nonnull instancetype)initWithEvent:(nonnull OCKCarePlanEvent *)event
{
    NSAssert(nil != event, @"Must provide event to %s", __PRETTY_FUNCTION__);
    
    self = [super init];
    if (nil == self) { return nil; }
    
    NSDateFormatter *dayFormatter = [NSDateFormatter new];
    dayFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"Md" options:0 locale:dayFormatter.locale];
    
    NSDateFormatter *nameFormatter = [NSDateFormatter new];
    nameFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E" options:0 locale:nameFormatter.locale];
    
    _axisLabel = [dayFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:event.date]];

    _axisSubLabel = [nameFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:event.date]];
    
    if (event.state != OCKCarePlanEventStateCompleted) {
        _value = @0;
        _label = @"N/A";
    } else {
        NSNumberFormatter *numForatter = [NSNumberFormatter new];
        numForatter.numberStyle = NSNumberFormatterDecimalStyle;
        _value = [numForatter numberFromString:event.result.valueString];
        
        _label = [event.result.valueString copy];
    }
    
    _numberOfDaysSinceStart = event.numberOfDaysSinceStart;
    
    return self;
}

@end
