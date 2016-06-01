#import "BCMFirstStartTracker.h"

static NSString *const HasStartedKey = @"BCMHasStarted";

@implementation BCMFirstStartTracker

+ (BOOL)isFirstStart
{
    return ![[NSUserDefaults standardUserDefaults] boolForKey:HasStartedKey];
}

+ (void)recordFirstStart
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HasStartedKey];
}

+ (void)forgetFirstStart
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HasStartedKey];
}

@end
