#import "BCMConnectNavController.h"
#import "UIColor+BCM.h"
#import <CareKit/CareKit.h>

@interface BCMConnectNavController ()

@end

@implementation BCMConnectNavController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.tintColor = [UIColor bcmBlueColor];

    OCKConnectViewController *connectViewController = [[OCKConnectViewController alloc] initWithContacts:BCMConnectNavController.contacts];
    connectViewController.navigationItem.title = NSLocalizedString(@"Connect", nil);
    [self showViewController:connectViewController sender:nil];
}

# pragma mark Generators

+ (NSArray <OCKContact *> *_Nonnull)contacts
{
    return @[self.cloudMineContact, self.doctorContact, self.physicalTherapistContact];
}

+ (OCKContact *_Nonnull)cloudMineContact
{
    NSString *cloudMinePhone = @"(855) 662-7722";
    NSString *cloudMineEmail = @"support@cloudmineinc.com";
    
    OCKContactInfo *phoneInfo = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypePhone displayString:cloudMinePhone actionURL:nil label:cloudMinePhone];
    OCKContactInfo *emailInfo = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeEmail displayString:cloudMineEmail actionURL:nil label:cloudMineEmail];
    
    return [[OCKContact alloc] initWithContactType:OCKContactTypePersonal
                                              name:@"CloudMine"
                                          relation:NSLocalizedString(@"Connected Care Partner", nil)
                                  contactInfoItems:@[phoneInfo, emailInfo]
                                         tintColor:[UIColor bcmBlueColor]
                                          monogram:@"CM"
                                             image:nil];

}

+ (OCKContact *_Nonnull)doctorContact
{
    NSString *doctorPhone = @"(555) 555-5555";
    NSString *doctorEmail = @"jane@fakebackdoctor.com";
    
    OCKContactInfo *phoneInfo   = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypePhone displayString:doctorPhone actionURL:nil label:doctorPhone];
    OCKContactInfo *messageInfo = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeMessage displayString:doctorPhone actionURL:nil label:doctorPhone];
    OCKContactInfo *emailInfo   = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeEmail displayString:doctorEmail actionURL:nil label:doctorEmail];
    
    return [[OCKContact alloc] initWithContactType:OCKContactTypeCareTeam
                                              name:@"Dr. Jane Smith"
                                          relation:@"Orthopedist"
                                  contactInfoItems:@[phoneInfo, messageInfo, emailInfo]
                                         tintColor:[UIColor bcmGreenColor]
                                          monogram:@"JS"
                                             image:nil];
}

+ (OCKContact *_Nonnull)physicalTherapistContact
{
    NSString *therapistPhone = @"(555) 555-1234";
    NSString *therapistEmail = @"John@notreallyapt.com";
    
    OCKContactInfo *phoneInfo   = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypePhone displayString:therapistPhone actionURL:nil label:therapistPhone];
    OCKContactInfo *messageInfo = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeMessage displayString:therapistPhone actionURL:nil label:therapistPhone];
    OCKContactInfo *emailInfo   = [[OCKContactInfo alloc] initWithType:OCKContactInfoTypeEmail displayString:therapistEmail actionURL:nil label:therapistEmail];
    
    return [[OCKContact alloc] initWithContactType:OCKContactTypeCareTeam
                                              name:@"John Doe"
                                          relation:@"Physical Therapist"
                                  contactInfoItems:@[phoneInfo, messageInfo, emailInfo]
                                         tintColor:[UIColor bcmPurpleColor]
                                          monogram:@"JD"
                                             image:nil];
}
@end
