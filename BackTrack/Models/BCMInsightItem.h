#import <CareKit/CareKit.h>

@interface BCMInsightItem : NSObject

- (nonnull instancetype)initWithEvent:(nonnull OCKCarePlanEvent *)event;

@property (nonatomic, nonnull, readonly, copy) NSNumber *value;
@property (nonatomic, nonnull, readonly, copy) NSString *label;
@property (nonatomic, nonnull, readonly, copy) NSString *axisLabel;
@property (nonatomic, nonnull, readonly, copy) NSString *axisSubLabel;
@property (nonatomic, readonly) NSUInteger numberOfDaysSinceStart;

@end
