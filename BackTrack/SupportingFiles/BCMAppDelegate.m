#import "BCMAppDelegate.h"
#import "BCMSecrets.h"
#import <CMHealth/CMHealth.h>

@interface BCMAppDelegate ()

@end

@implementation BCMAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CMHealth setAppIdentifier:BCMAppIdentifier appSecret:BCMAppSecret];

    if ([CMHUser currentUser].isLoggedIn) {
        [self loadMainPanel];
    } else {
        [self loadAuthentication];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)loadAuthentication
{
    UIViewController *onboardingVC = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil].instantiateInitialViewController;
    self.window.rootViewController = onboardingVC;
    [self.window makeKeyAndVisible];
}

- (void)loadMainPanel
{
    UIViewController *mainPanelVC = [UIStoryboard storyboardWithName:@"MainPanel" bundle:nil].instantiateInitialViewController;
    self.window.rootViewController = mainPanelVC;
    [self.window makeKeyAndVisible];
}

@end
