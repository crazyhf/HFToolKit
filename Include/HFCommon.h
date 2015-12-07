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

#define ReverseDNSOCIdentify(_identify_) @"com.crazylhf.hftoolkit."@#_identify_

#define ExternReverseDNSString(_string_name_) extern NSString * const _string_name_
#define DefineReverseDNSString(_string_name_) \
            NSString * const _string_name_ = ReverseDNSOCIdentify(_string_name_)


///=================================================================

#pragma mark - notification macro

#define ExternNotificationName(_notify_name_, .../*description*/) \
            ExternReverseDNSString(_notify_name_)
#define DefineNotificationName(_notify_name_) \
            DefineReverseDNSString(_notify_name_)

#define ExternNotificationKey(_notify_key_, .../*description*/) \
            ExternReverseDNSString(_notify_key_)
#define DefineNotificationKey(_notify_key_) \
            DefineReverseDNSString(_notify_key_)

#define HF_NotifyCenter   [NSNotificationCenter defaultCenter]


///=================================================================

#pragma mark - enum macro

#define HF_ENUM_HEAD(_enum_type_, _enum_name_) \
            typedef NS_ENUM(_enum_type_, _enum_name_) { \
                _enum_name_##_LOWERBOUND, /*enum下界值*/

#define HF_ENUM_TAIL(_enum_name_) \
                _enum_name_##_UPPERBOUND, /*enum上界值*/ \
            }; \
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Wunused-function\"")\
            static inline BOOL is_##_enum_name_##_valid(_enum_name_ _value_) {\
                return ((_value_ > _enum_name_##_LOWERBOUND) \
                        && (_value_ < _enum_name_##_UPPERBOUND)); \
            } \
            _Pragma("clang diagnostic pop")


///=================================================================

#pragma mark - asset macro

#if DEBUG
#define HFAssetW(_expr_, _w_format_, ...) NSAssert((_expr_), (_w_format_), ##__VA_ARGS__)

#define HFAssetE(_expr_, _e_format_, ...) NSAssert((_expr_), (_e_format_), ##__VA_ARGS__)
#else
#define HFAssetW(_expr_, _w_format_, ...) \
            do {\
                if (!(_expr_)) { \
                    HFLogw(@"HFAssetW", (_w_format_), ##__VA_ARGS__); \
                } \
            } while(false)

#define HFAssetE(_expr_, _e_format_, ...) \
            do {\
                if (!(_expr_)) { \
                    HFLoge(@"HFAssetE", (_e_format_), ##__VA_ARGS__); \
                } \
            } while(false)
#endif


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
