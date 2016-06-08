#import "CareKit+BCM.h"
#import "BCMObjectCompare.h"

@implementation OCKCarePlanActivity (BCM)

- (BOOL)isDataEquivalentOf:(OCKCarePlanActivity *_Nullable)other
{
    return bcmAreEqual(self.title, other.title) &&
            bcmAreEqual(self.text, other.text) &&
            bcmAreEqual(self.instructions, other.instructions) &&
            bcmAreEqual(self.schedule, other.schedule) &&
            (self.type == other.type) &&
            bcmAreEqual(self.identifier, other.identifier) &&
            bcmAreEqual(self.groupIdentifier, other.groupIdentifier) &&
            (self.resultResettable == other.resultResettable) &&
            bcmAreEqual(self.userInfo, other.userInfo);

}

@end

@implementation OCKCareSchedule (BCM)

@end
