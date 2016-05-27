#import "BCMConnectNavController.h"
#import <CareKit/CareKit.h>

@interface BCMConnectNavController ()

@end

@implementation BCMConnectNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Hello Connect");

    OCKConnectViewController *connectViewController = [[OCKConnectViewController alloc] initWithContacts:nil];
    [self showViewController:connectViewController sender:nil];
}
@end
