//
//  HFLogFileWriter.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFLogStdOutWriter.h"

@interface HFLogFileWriter : HFLogStdOutWriter

- (void)openLogWriter:(NSString *)logPath;

- (NSString *)currentLogFilePath;

@end
