#import "BCMEventWrapper.h"
#import "BCMEventResultWrapper.h"

@interface BCMEventWrapper ()

@property (nonatomic, readwrite) NSUInteger occurrenceIndexOfDay;
@property (nonatomic, readwrite) NSUInteger numberOfDaysSinceStart;
@property (nonatomic, nonnull, readwrite) NSDateComponents *date;
@property (nonatomic, nonnull, readwrite) OCKCarePlanActivity *activity;
@property (nonatomic, nonnull, readwrite) NSString *stateString;
@property (nonatomic, nullable) BCMEventResultWrapper *resultWrapper;

@end

@implementation BCMEventWrapper

# pragma mark Initializer

- (instancetype)initWithEvent:(OCKCarePlanEvent *_Nonnull)event
{
    NSAssert(nil != event, @"%@ cannot be initialized without an event", [BCMEventWrapper class]);

    NSString *objectId = [NSString stringWithFormat:@"%@-%li-%li-%@", event.activity.identifier,
                          (long)event.occurrenceIndexOfDay, (long)event.numberOfDaysSinceStart, [CMUser currentUser].objectId];
    
    self = [super initWithObjectId:objectId];
    if (nil == self) return nil;

    self.occurrenceIndexOfDay = event.occurrenceIndexOfDay;
    self.numberOfDaysSinceStart = event.numberOfDaysSinceStart;
    self.date = event.date;
    self.activity = event.activity;
    self.stateString = [BCMEventWrapper stateStringFromState:event.state];

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
    self.stateString = [aDecoder decodeObjectForKey:@"state"];
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
    [aCoder encodeObject:self.stateString forKey:@"state"];
    [aCoder encodeObject:self.resultWrapper forKey:@"resultWrapper"];
}

#pragma mark Getters-Setters

- (OCKCarePlanEventResult *)result
{
    return self.resultWrapper.result;
}

- (OCKCarePlanEventState)state
{
    return [BCMEventWrapper stateFromString:self.stateString];
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

+ (OCKCarePlanEventState)stateFromString:(NSString * _Nonnull)stateString
{
    if ([@"OCKCarePlanEventStateInitial" isEqualToString:stateString]) {
        return OCKCarePlanEventStateInitial;
    } else if ([@"OCKCarePlanEventStateNotCompleted" isEqualToString:stateString]) {
        return OCKCarePlanEventStateNotCompleted;
    } else if ([@"OCKCarePlanEventStateCompleted" isEqualToString:stateString]) {
        return OCKCarePlanEventStateCompleted;
    } else {
        return -1;
    }
}

@end
