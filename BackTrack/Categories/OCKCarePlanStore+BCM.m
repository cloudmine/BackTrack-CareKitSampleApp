#import "OCKCarePlanStore+BCM.h"
#import <CloudMine/CloudMine.h>
#import <CMHealth/CMHActivityList.h>
#import "BCMWaitUntil.h"
#import "BCMEventWrapper.h"
#import "BCMEventUpdater.h"

@implementation OCKCarePlanStore (BCM)

- (void)bcm_reloadAllRemoteEventsWithCompletion:(_Nullable BCMCarePlanReloadCompletion)block;
{

    CMStoreOptions *noLimitOption = [[CMStoreOptions alloc] initWithPagingDescriptor:[[CMPagingDescriptor alloc] initWithLimit:-1]];
    [[CMStore defaultStore] allUserObjectsOfClass:[BCMEventWrapper class] additionalOptions:noLimitOption callback:^(CMObjectFetchResponse *response) {
        // TODO: errors

        NSArray <BCMEventWrapper *> *wrappedEvents = response.objects;


        dispatch_queue_t updateQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(updateQueue, ^{
            for (BCMEventWrapper *wrappedEvent in wrappedEvents) {

                __block NSArray<OCKCarePlanEvent *> *storeEvents = nil;
                __block NSError *storeError = nil;

                bcm_wait_until(^(BCMDoneBlock  _Nonnull done) {
                     [self eventsForActivity:wrappedEvent.activity date:wrappedEvent.date completion:^(NSArray<OCKCarePlanEvent *> * _Nonnull events, NSError * _Nullable error) {
                         storeEvents = events;
                         storeError = error;
                         done();
                     }];
                });

                //TODO: errors

                for (OCKCarePlanEvent *anEvent in storeEvents) {
                    if (anEvent.occurrenceIndexOfDay != wrappedEvent.occurrenceIndexOfDay ||
                        [wrappedEvent isDataEquivalentOf:anEvent]) {
                        continue;
                    }

                    BCMEventUpdater *updater = [[BCMEventUpdater alloc] initWithCarePlanStore:self
                                                                                        event:anEvent
                                                                                       result:wrappedEvent.result
                                                                                        state:wrappedEvent.state];
                    [updater performUpdate];
                }

                if (nil == block) {
                    return;
                }
            }

            block(nil);
        });
    }];

}

@end
