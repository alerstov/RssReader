
#import "HttpRequest.h"


@interface HttpRequest ()
{
    NSMutableData* asyncData;
    id<HttpRequestDelgate> delegate;
}
@property (nonatomic) NSMutableData* asyncData;
@property (nonatomic) id<HttpRequestDelgate> delegate;
@end



@implementation HttpRequest
@synthesize asyncData, delegate;


+(void)request:(NSString*)adr :(id<HttpRequestDelgate>)delegate;
{
    HttpRequest* inst = [HttpRequest new];
    [inst setAsyncData:[NSMutableData new]];
    [inst setDelegate:delegate];
            
    // start async request
    id url = [[NSURL alloc]initWithString: adr];
    id req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:inst];
    NSLog(@"start request: %@", adr);
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[asyncData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    NSLog(@"request fail: %@", error);
    [[self delegate] requestComplete:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"request finish");
	[[self delegate] requestComplete:asyncData];
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil; // Don't cache
}

@end
