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
    CNPhoneNumber *phone = [CNPhoneNumber phoneNumberWithStringValue:@"(855) 662-7722"];

    return [[OCKContact alloc] initWithContactType:OCKContactTypePersonal
                                              name:@"CloudMine"
                                          relation:@"Connected Care Partner"
                                         tintColor:[UIColor bcmBlueColor]
                                       phoneNumber:phone
                                     messageNumber:phone
                                      emailAddress:@"support@cloudmineinc.com"
                                          monogram:@"CM"
                                             image:nil];

}

+ (OCKContact *_Nonnull)doctorContact
{
    CNPhoneNumber *phone = [CNPhoneNumber phoneNumberWithStringValue:@"(555) 555-5555"];

    return [[OCKContact alloc] initWithContactType:OCKContactTypeCareTeam
                                              name:@"Dr. Jane Smith"
                                          relation:@"Orthopedist"
                                         tintColor:[UIColor bcmGreenColor]
                                       phoneNumber:phone
                                     messageNumber:phone
                                      emailAddress:@"jane@fakebackdoctor.com"
                                          monogram:@"JS"
                                             image:nil];
}

+ (OCKContact *_Nonnull)physicalTherapistContact
{
    CNPhoneNumber *phone = [CNPhoneNumber phoneNumberWithStringValue:@"(555) 555-1234"];

    return [[OCKContact alloc] initWithContactType:OCKContactTypeCareTeam
                                              name:@"John Doe"
                                          relation:@"Physical Therapist"
                                         tintColor:[UIColor bcmPurpleColor]
                                       phoneNumber:phone
                                     messageNumber:phone
                                      emailAddress:@"John@notreallyapt.com"
                                          monogram:@"JD"
                                             image:nil];
}
@end
