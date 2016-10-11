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
/// #error      test error message0
/// #warning    test warning message0
/// #pragma message "test tip message0"
/// #pragma message("test tip message1")
/// #pragma GCC error "test error message1"
/// #pragma GCC error("test error message2")
/// #pragma GCC warning "test warning message1"
/// #pragma GCC warning("test warning message2")

#pragma mark - syntax sugar

#ifdef DEBUG
#define __compoundify__         @autoreleasepool
#else
#define __compoundify__
#endif

#ifdef DEBUG
#define __keywordify_inner__    autoreleasepool{}
#else
#define __keywordify_inner__    try{} @catch(...){}
#endif

#define __keywordify_outter__   class __strawman_class__;

#define __stringify__(_text_)   #_text_

#define TODO(_msg_) __keywordify_inner__  _Pragma(__stringify__(message #_msg_))

#define MSG(_msg_)  __keywordify_outter__ _Pragma(__stringify__(message #_msg_))

#define WARN(_msg_) __keywordify_outter__ _Pragma(__stringify__(GCC warning #_msg_))


///=================================================================

#pragma mark - string macro

#define ReverseDNSIdentify(_identify_) "com.crazylhf.hftoolkit."__stringify__(_identify_)

#define ReverseDNSOCIdentify(_identify_) @"com.crazylhf.hftoolkit."@__stringify__(_identify_)

#define ExternReverseDNSString(_string_name_) extern NSString * const _string_name_
#define DefineReverseDNSString(_string_name_) \
            NSString * const _string_name_ = ReverseDNSOCIdentify(_string_name_)


///=================================================================

#pragma mark - notification macro

/// eg. ExternNotificationName(NotifyName, brief("nofity description"))
#define ExternNotificationName(_notify_name_, .../*description*/) \
            ExternReverseDNSString(_notify_name_)
#define DefineNotificationName(_notify_name_) \
            DefineReverseDNSString(_notify_name_)

/// eg. ExternNotificationKey(NotifyKey, brief("nofity key description"))
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

@protocol HFSingleton <NSObject>

+ (instancetype)sharedInstance;

@end

#define singleton \
            __keywordify_outter__ \
            + (instancetype)sharedInstance \
            { \
                static id _instance = nil; \
                static dispatch_once_t onceToken; \
                dispatch_once(&onceToken, ^{ _instance = [[self alloc] init]; }); \
                return _instance; \
            }


///=================================================================

#pragma mark - safe invoke

#define HFInvoke4Delegate(_delegate_, _selector_) \
        if (nil != (_delegate_) && \
            YES == [(_delegate_) respondsToSelector:(_selector_)]) __compoundify__

#define HFInvoke4DelegateArg0(_delegate_, _selector_) \
        if (nil != (_delegate_) && \
            YES == [(_delegate_) respondsToSelector:(_selector_)]) { \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
            [(_delegate) performSelector:(_selector_)]; \
            _Pragma("clang diagnostic pop") \
        }

#define HFInvoke4Block(_block_) if (nil != (_block_)) __compoundify__


///=================================================================

#pragma mark - autorelease loop snippet

#define FOR(...) __keywordify_inner__ for (__VA_ARGS__) @autoreleasepool

#define WHILE(...) __keywordify_inner__ while (__VA_ARGS__) @autoreleasepool


///=================================================================

#pragma mark - weak self macro

#define weakSelf()  __keywordify_inner__ __weak typeof(self) weakSelf = self;

#endif /* HFCommon_h */
