

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIUtils : NSObject
+(CGFloat ) getTextHeight:(NSString *) text font:(UIFont *)font forWidth:(CGFloat) width;

+(CGFloat ) getWindowWidth;
@end
