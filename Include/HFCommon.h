//
//  HFCommon.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#ifndef HFCommon_h
#define HFCommon_h

///=================================================================

#pragma mark - string macro

#define ReverseDNSIdentify(_identify_) "com.crazylhf.hftoolkit."#_identify_


///=================================================================

#pragma mark - enum macro

#define HF_ENUM_HEAD(_enum_type_, _enum_name_) \
            typedef NS_ENUM(_enum_type_, _enum_name_) { \
                _enum_name_##_LOWERBOUND, /*enum下界值*/

#define HF_ENUM_TAIL(_enum_name_) \
                _enum_name_##_UPPERBOUND, /*enum上界值*/ \
            }; \
            static inline BOOL is_##_enum_name_##_valid(_enum_name_ _value_) {\
                return ((_value_ > _enum_name_##_LOWERBOUND) \
                        && (_value_ < _enum_name_##_UPPERBOUND)); \
            }


///=================================================================

#pragma mark - singleton macro

#define HF_DECLARE_SINGLETON() \
            + (instancetype)sharedInstance;

#define HF_IMPLEMENTATION_SINGLETON() \
            + (instancetype)sharedInstance \
            { \
                static id _instance = nil; \
                static dispatch_once_t onceToken; \
                dispatch_once(&onceToken, ^{ _instance = [[self alloc] init]; }); \
                return _instance; \
            }


///=================================================================

#pragma mark - weak self macro

#define HFWeakSelf()      __weak typeof(self) hfWeakSelf = self

#endif /* HFCommon_h */
