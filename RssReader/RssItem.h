
#import <Foundation/Foundation.h>

@interface RssItem : NSObject
{
    NSString* title;
    NSString* link;
    NSString* description; 
    NSString* pubDate; 
}

@property (nonatomic) NSString* title;
@property (nonatomic) NSString* link;
@property (nonatomic) NSString* description;
@property (nonatomic) NSString* pubDate;

@end
