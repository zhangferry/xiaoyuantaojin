

#import "UIUtils.h"
#import "Header.h"
@implementation UIUtils

+(CGFloat ) getTextHeight:(NSString *) text font:(UIFont *)font forWidth:(CGFloat) width  {
    if ( text == nil || font == nil || width <= 0) {
        return 0 ;
    }
    
    CGSize size;
    
    if ( IsIOS7) {
        NSDictionary *attribute = @{NSFontAttributeName: font};
        size = [text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil ].size ;
    }else{
        size = [text sizeWithFont: font forWidth:width lineBreakMode:NSLineBreakByClipping ] ;
        
    }
    
    return size.height ;
    
}

+(CGFloat ) getWindowWidth{
    UIWindow *keyWindow = [UIApplication sharedApplication].windows[0];
    return  keyWindow.bounds.size.width;
}
@end
