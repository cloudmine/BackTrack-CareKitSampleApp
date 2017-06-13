#import "BCMStoreUtils.h"
#import "BCMWaitUntil.h"

@implementation BCMStoreUtils

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
