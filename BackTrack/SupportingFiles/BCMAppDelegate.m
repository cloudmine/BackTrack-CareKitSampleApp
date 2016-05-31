#import "BCMAppDelegate.h"
#import "BCMSecrets.h"
#import <CMHealth/CMHealth.h>
#import "BCMMainThread.h"

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
    on_main_thread(^{
        UIViewController *authVC = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil].instantiateInitialViewController;
        self.window.rootViewController = authVC;
        [self.window makeKeyAndVisible];
    });
}

- (void)loadMainPanel
{
    on_main_thread(^{
        UIViewController *mainPanelVC = [UIStoryboard storyboardWithName:@"MainPanel" bundle:nil].instantiateInitialViewController;
        self.window.rootViewController = mainPanelVC;
        [self.window makeKeyAndVisible];
    });
}

@end
