//
//  ATBusyVerifier.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2018/12/30.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "ATBusyVerifier.h"

@implementation ATBusyVerifier

- (AGVerifyError *)ag_verifyData:(id)data
{
    int sum = 0;
    int count = 18000;
    for (NSInteger i = 0; i<count; i++) {
        for (NSInteger j = 0; j<count; j++) {
            sum += j;
        }
        sum -= count;
    }
    
    if ( [data respondsToSelector:@selector(intValue)] ) {
        
        if ( [data intValue] % 2 == 0 ) {
            AGVerifyError *error = [AGVerifyError new];
            error.msg = [NSString stringWithFormat:@"==> %@ %@", data, [NSThread currentThread]];
            error.code = 1024;
            return error;
        }
    }
    return nil;
}

@end
