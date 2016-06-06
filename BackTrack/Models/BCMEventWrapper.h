#import <CloudMine/CloudMine.h>
#import <CareKit/CareKit.h>

@interface BCMEventWrapper : CMObject

- (_Nonnull instancetype)initWithEvent:(OCKCarePlanEvent *_Nonnull)event;

@property (nonatomic, readonly) NSUInteger occurrenceIndexOfDay;
@property (nonatomic, readonly) NSUInteger numberOfDaysSinceStart;
@property (nonatomic, nonnull, readonly) NSDateComponents *date;
@property (nonatomic, nonnull, readonly) OCKCarePlanActivity *activity;
@property (nonatomic, readonly) OCKCarePlanEventState state;
@property (nonatomic, nullable, readonly) OCKCarePlanEventResult *result;

@end
