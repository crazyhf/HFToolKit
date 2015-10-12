//
//  HFLogStdOutWriter.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFLogTypes.h"


@interface HFLogStdOutWriter : NSObject

- (void)openLogWriter:(id)option;

- (void)closeLogWriter;


- (void)log:(HFLogContent *)logContent;

@end
