#import "NSDateComponents+BCM.h"

@implementation NSDateComponents (BCM)

+ (NSDateComponents *_Nonnull)weekAgoComponents
{
    NSDate *weekAgoIsh = [NSDate dateWithTimeIntervalSinceNow:-(7*24*60*60)];
    return [[NSDateComponents alloc] initWithDate:weekAgoIsh calendar:[NSCalendar currentCalendar]];
}

+ (NSDateComponents *_Nonnull)tomorrowComponents
{
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
    return [[NSDateComponents alloc] initWithDate:tomorrow calendar:[NSCalendar currentCalendar]];
}

+ (NSDateComponents *_Nonnull)todayComponents
{
    return [[NSDateComponents alloc] initWithDate:[NSDate new] calendar:[NSCalendar currentCalendar]];
}

@end
