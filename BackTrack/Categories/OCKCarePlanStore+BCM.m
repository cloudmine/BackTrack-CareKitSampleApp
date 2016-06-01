    #import "OCKCarePlanStore+BCM.h"
#import <CloudMine/CloudMine.h>
#import "BCMActivityList.h"
#import "BCMWaitUntil.h"

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

- (void)bcm_clearLocalStoreWithCompletion:(_Nullable BCMCarePlanClearCompletion)block;
{
    __block NSArray *allActivities = nil;
    __block NSError *fetchError = nil;
    __block BOOL fetchSuccess = NO;

    bcm_wait_until(^(BCMDoneBlock  _Nonnull done) {
        [self activitiesWithCompletion:^(BOOL success, NSArray<OCKCarePlanActivity *> * _Nonnull activities, NSError * _Nullable error) {
            fetchSuccess = success;
            allActivities = activities;
            fetchError = error;
            done();
        }];
    });


    NSMutableArray *mutableErrors = [NSMutableArray new];

    for (OCKCarePlanActivity *activity in allActivities) {
        bcm_wait_until(^(BCMDoneBlock _Nonnull done) {
            [self removeActivity:activity completion:^(BOOL success, NSError * _Nullable error) {
                if (!success) {
                    NSLog(@"Failed to remove activity with identifer: %@; %@", activity.identifier, error.localizedDescription);
                    [mutableErrors addObject:error];
                    done();
                    return;
                }

                NSLog(@"Removed activity with identifier: %@", activity.identifier);
                done();
            }];
        });
    }

    block([mutableErrors copy]);
}

@end
