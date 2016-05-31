#import "OCKCarePlanStore+BCM.h"
#import <CloudMine/CloudMine.h>
#import "BCMActivityList.h"

@implementation OCKCarePlanStore (BCM)

- (void)bcm_saveActivtiesWithCompletion:(_Nullable BCMCarePlanSaveCompletion)block
{
    [self activitiesWithCompletion:^(BOOL success, NSArray<OCKCarePlanActivity *> * _Nonnull activities, NSError * _Nullable error) {
        if (!success) {
            if (nil != block) {
                block(error);
            }
            return;
        }

        BCMActivityList *activityList = [[BCMActivityList alloc] initWithActivities:activities];

        [activityList saveWithUser:[CMUser currentUser] callback:^(CMObjectUploadResponse *response) {
            // TODO: Error handling
            NSLog(@"Save Complete");

            if (nil != block) {
                block(nil);
            }
        }];
    }];
}

- (void)bcm_fetchActivitiesWithCompletion:(_Nullable BCMCarePlanActivityFetchCompletion)block
{
    [[CMStore defaultStore] allUserObjectsOfClass:[BCMActivityList class] additionalOptions:nil callback:^(CMObjectFetchResponse *response) {
        // TODO: Error checking/handling
        BCMActivityList *activityList = response.objects.firstObject;
        block(activityList.activities, nil);
    }];
}

@end
