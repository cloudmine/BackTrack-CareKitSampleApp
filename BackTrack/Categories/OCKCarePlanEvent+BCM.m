#import "OCKCarePlanEvent+BCM.h"
#import <CloudMine/CloudMine.h>

@implementation OCKCarePlanEvent (BCM)

- (BOOL)isAvailable
{
    return self.state == OCKCarePlanEventStateInitial ||
            self.state == OCKCarePlanEventStateNotCompleted ||
            (self.state == OCKCarePlanEventStateCompleted && self.activity.resultResettable);
}

- (NSString *)bcm_objectId
{
    return [NSString stringWithFormat:@"%@-%li-%li-%@", self.activity.identifier,
            (long)self.occurrenceIndexOfDay, (long)self.numberOfDaysSinceStart, [CMUser currentUser].objectId];
}

@end
