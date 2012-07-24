
#import <Foundation/Foundation.h>


@protocol HttpRequestDelgate

-(void)requestComplete:(NSData*)data;

@end


@interface HttpRequest : NSObject<NSURLConnectionDelegate>

+(void)request:(NSString*)adr :(id<HttpRequestDelgate>)delegate;

@end
