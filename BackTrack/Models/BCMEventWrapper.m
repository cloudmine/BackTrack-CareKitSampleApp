#import "BCMEventWrapper.h"
#import "BCMEventResultWrapper.h"

@interface BCMEventWrapper ()

@property (nonatomic) NSUInteger occurrenceIndexOfDay;
@property (nonatomic) NSUInteger numberOfDaysSinceStart;
@property (nonatomic, nonnull) NSDateComponents *date;
@property (nonatomic, nonnull) OCKCarePlanActivity *activity;
@property (nonatomic, nonnull) NSString *state;
@property (nonatomic, nullable) BCMEventResultWrapper *resultWrapper;

@end

@implementation BCMEventWrapper

- (instancetype)initWithEvent:(OCKCarePlanEvent *_Nonnull)event
{
    self = [super init];
    if (nil == self || nil == event) return nil;

    self.occurrenceIndexOfDay = event.occurrenceIndexOfDay;
    self.numberOfDaysSinceStart = event.numberOfDaysSinceStart;
    self.date = event.date;
    self.activity = event.activity;
    self.state = [BCMEventWrapper stateStringFromState:event.state];

    if (nil != event.result) {
        self.resultWrapper = [[BCMEventResultWrapper alloc] initWithEventResult:event.result];
    }

    return self;
}

#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil == self) return nil;

    self.occurrenceIndexOfDay = [aDecoder decodeIntegerForKey:@"occurrenceIndexOfDay"];
    self.numberOfDaysSinceStart = [aDecoder decodeIntegerForKey:@"numberOfDaysSinceStart"];
    self.date = [aDecoder decodeObjectForKey:@"date"];
    self.activity = [aDecoder decodeObjectForKey:@"activity"];
    self.state = [aDecoder decodeObjectForKey:@"state"];
    self.resultWrapper = [aDecoder decodeObjectForKey:@"resultWrapper"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeInteger:self.occurrenceIndexOfDay forKey:@"occurrenceIndexOfDay"];
    [aCoder encodeInteger:self.numberOfDaysSinceStart forKey:@"numberOfDaysSinceStart"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.activity forKey:@"activity"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.resultWrapper forKey:@"resultWrapper"];
}

#pragma mark Private

+ (NSString *_Nonnull)stateStringFromState:(OCKCarePlanEventState)state
{
    switch (state) {
        case OCKCarePlanEventStateInitial:
            return @"OCKCarePlanEventStateInitial";
        case OCKCarePlanEventStateNotCompleted:
            return @"OCKCarePlanEventStateNotCompleted";
        case OCKCarePlanEventStateCompleted:
            return @"OCKCarePlanEventStateCompleted";
        default:
            return @"";
    }
}

@end
