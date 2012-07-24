
#import <Foundation/Foundation.h>
#import "RssItem.h"

@interface RssToken : NSObject
{
    NSString* title;
    NSString* link;
    NSString* description;
    NSString* pubDate;
    NSMutableArray* items;
}

@property (nonatomic) NSString* title;
@property (nonatomic) NSString* link;
@property (nonatomic) NSString* description;
@property (nonatomic) NSString* pubDate;
@property (nonatomic) NSMutableArray* items;

+(RssToken*)parseWithData:(NSData*)data;

@end
