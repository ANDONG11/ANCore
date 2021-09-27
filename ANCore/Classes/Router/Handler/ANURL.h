//
//  ANURL.h
//  ZBMOM
//
//  Created by dong an on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANURL : NSURL

@property (nonatomic, copy, readonly) NSString *urlString;   /**< URL字符串 */
@property (nonatomic, copy) NSString *aScheme;                /**< 协议 */
@property (nonatomic, copy) NSString *aHost;                  /**< 域 */
@property (nonatomic, copy) NSString *aPath;                  /**< 地址 */
@property (nonatomic, copy) NSDictionary *aQuery;             /**< 参数列表 */

/// 初始化url 
- (instancetype)initWithString:(NSString *)string;

- (NSArray *)queryparams;

@end

NS_ASSUME_NONNULL_END
