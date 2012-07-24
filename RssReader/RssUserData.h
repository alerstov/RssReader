
#import <Foundation/Foundation.h>
#import "RssToken.h"

@interface RssUserData : NSObject
{
    NSString* name;
    NSString* url;  
    NSString* status;
    RssToken* rssToken;
}
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* url;
@property (nonatomic) NSString* status;
@property (nonatomic) RssToken* rssToken;
@end