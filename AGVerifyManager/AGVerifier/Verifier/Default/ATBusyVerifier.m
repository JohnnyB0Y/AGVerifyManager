//
//  ATBusyVerifier.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2018/12/30.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "ATBusyVerifier.h"

@implementation ATBusyVerifier

- (AGVerifyError *)ag_verifyObj:(id)obj
{
    int sum = 0;
    int count = 18000;
    for (NSInteger i = 0; i<count; i++) {
        for (NSInteger j = 0; j<count; j++) {
            sum += j;
        }
        sum -= count;
    }
    
    if ( [obj respondsToSelector:@selector(intValue)] ) {
        
        if ( [obj intValue] % 2 == 0 ) {
            AGVerifyError *error = [AGVerifyError new];
            error.msg = [NSString stringWithFormat:@"==> %@ %@", obj, [NSThread currentThread]];
            error.code = 1024;
            return error;
        }
    }
    return nil;
}

@end
