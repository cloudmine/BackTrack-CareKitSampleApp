#import "BCMMainTabController.h"
#import <CMHealth/CMHealth.h>
#import "BCMFirstStartTracker.h"
#import "BCMActivities.h"
#import "UIColor+BCM.h"
#import "BCMWaitUntil.h"

NSString * const _Nonnull BCMStoreDidUpdateNotification = @"BCMStoreDidUpdate";
NSString * const _Nonnull BCMStoreDidReloadEventData    = @"BCMStoreDidReloadEventData";

@interface BCMMainTabController ()<OCKCarePlanStoreDelegate>

@property (nonatomic, readwrite, nonnull) OCKCarePlanStore *carePlanStore;

@end

@implementation BCMMainTabController

#pragma mark Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil ==  self) return nil;

    self.carePlanStore = [[OCKCarePlanStore alloc] initWithPersistenceDirectoryURL:BCMMainTabController.persistenceDirectory];
    self.carePlanStore.delegate = self;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor bcmBlueColor];

    if (BCMFirstStartTracker.isFirstStart) {
        [self syncRemoteActivitiesAndEvents];
        [BCMFirstStartTracker recordFirstStart];
        return;
    }

    [self syncRemoteEvents];
}

#pragma mark OCKCarePlanStoreDelegate

- (void)carePlanStore:(OCKCarePlanStore *)store didReceiveUpdateOfEvent:(OCKCarePlanEvent *)event
{
    NSLog(@"Received Event Update Notification");

    [self postStoreUpdateNotification];

    [event cmh_saveWithCompletion:^(NSString * _Nullable uploadStatus, NSError * _Nullable error) {
        if (nil != error) {
            NSLog(@"Error uploading event: %@", error.localizedDescription);
            return;
        }

        NSLog(@"Uploaded response with status: %@", uploadStatus);
    }];
}

- (void)carePlanStoreActivityListDidChange:(OCKCarePlanStore *)store
{
    [self postStoreUpdateNotification];
}

#pragma mark Private

- (void)syncRemoteActivitiesAndEvents
{
    // Defensively clear the store, in case bad state was somehow left
    [self.carePlanStore cmh_clearLocalStoreSynchronously]; //TODO: how to handle errors returned?

    [self.carePlanStore cmh_fetchActivitiesWithCompletion:^(NSArray<OCKCarePlanActivity *> * _Nonnull activities, NSError * _Nullable error) {
        // TODO: Error checking

        if (activities.count < 1) {
            [self addInitialActivities];
        } else {
            [BCMMainTabController addActivities:activities toStore:self.carePlanStore];
        }

        [self syncRemoteEvents];
    }];
}

- (void)syncRemoteEvents
{
    [self.carePlanStore cmh_fetchAndLoadAllEventsWithCompletion:^(BOOL success, NSArray<NSError *> * _Nonnull errors) {
        if (!success) {
            NSLog(@"Errors loading remote events: %@", errors.firstObject.localizedDescription);
            return;
        }

        [self postDataDidReloadNotification];
    }];
}

- (void)postStoreUpdateNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BCMStoreDidUpdateNotification object:self];
}

- (void)postDataDidReloadNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BCMStoreDidReloadEventData object:self];
}

+ (NSURL *)persistenceDirectory
{
    NSURL *appDirURL = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].firstObject;

    NSAssert(nil != appDirURL, @"Failed to create store director URL");

    if (![[NSFileManager defaultManager] fileExistsAtPath:[appDirURL path] isDirectory:nil]) {
        NSError *dirError = nil;
        [[NSFileManager defaultManager] createDirectoryAtURL:appDirURL withIntermediateDirectories:YES attributes:nil error:&dirError];
        NSAssert(nil == dirError, @"Error creating store directory: %@", dirError.localizedDescription);
    }

    return appDirURL;
}

- (void)addInitialActivities
{
    NSLog(@"Adding Hardcoded Activities");
    [BCMMainTabController addActivities:BCMActivities.activities toStore:self.carePlanStore];

    [self.carePlanStore cmh_saveActivtiesWithCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            NSLog(@"Error saving activities: %@", error.localizedDescription); // TODO: Really error handling
            return;
        }

        NSLog(@"Saved Activities");
    }];
}

+ (void)addActivities:(NSArray<OCKCarePlanActivity *> *_Nonnull)activities toStore:(OCKCarePlanStore *_Nonnull)store
{
    for (OCKCarePlanActivity *activity in activities) {
        bcm_wait_until(^(BCMDoneBlock _Nonnull done) {
            [store addActivity:activity completion:^(BOOL success, NSError * _Nullable error) {
                done();

                if (!success) {
                    NSLog(@"Failed to add activity to store: %@", error.localizedDescription);
                    return;
                }

                NSLog(@"Activity added to store");
            }];
        });
    }
}

@end
