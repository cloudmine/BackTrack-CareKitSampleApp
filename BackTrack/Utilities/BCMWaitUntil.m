#import "BCMWaitUntil.h"

void bcm_wait_until(_Nonnull BCMWaitBlock block)
{
    dispatch_group_t doneGroup = dispatch_group_create();

    BCMDoneBlock done = ^{
        dispatch_group_leave(doneGroup);
    };

    dispatch_group_enter(doneGroup);
    block(done);

    dispatch_group_wait(doneGroup, DISPATCH_TIME_FOREVER);
}
