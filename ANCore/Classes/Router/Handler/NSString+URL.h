//
//  NSString+URL.h
//  ZBMOM
//
//  Created by dong an on 2021/9/23.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface NSString (URL)

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters;

@end

NS_ASSUME_NONNULL_END
