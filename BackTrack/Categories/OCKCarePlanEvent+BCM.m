#import "OCKCarePlanEvent+BCM.h"
#import <CloudMine/CloudMine.h>

@implementation OCKCarePlanEvent (BCM)

- (BOOL)isAvailable
{
    return self.state == OCKCarePlanEventStateInitial ||
            self.state == OCKCarePlanEventStateNotCompleted ||
            (self.state == OCKCarePlanEventStateCompleted && self.activity.resultResettable);
}

@end
