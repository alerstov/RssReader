
#import "RssToken.h"
#import "XmlParser.h"

@interface RssToken()
+(RssToken*)parseChannel:(XmlElement*)chan;
+(RssItem*)parseItem:(XmlElement*)item;
@end


@implementation RssToken
@synthesize title, link, description, pubDate, items;

+(RssToken*)parseWithData:(NSData*)data
{
    XmlElement* root = [XmlParser parse:data];
    
    
    if (![[root name] isEqualToString:@"rss"])
    {
        NSLog(@"expected rss, got %@", [root name]);    
        return nil;
    }
    
    id ver = [[root attrs] valueForKey:@"version"];
    if (![ver isEqualToString:@"2.0"])
    {
        NSLog(@"invalid rss version %@", ver);    
        return nil;
    }
    
    id chan = [[root childs] objectAtIndex:0];
    if (![[chan name] isEqualToString:@"channel"])
    {
        NSLog(@"expected channel, got %@", [chan name]);    
        return nil;
    }
    
    return [RssToken parseChannel:chan];
}

+(RssToken*)parseChannel:(XmlElement*)chan
{
    XmlElement* chanTitle = [chan firstChildByName:@"title"];
    XmlElement* chanLink = [chan firstChildByName:@"link"];
    XmlElement* chanDescription = [chan firstChildByName:@"description"];
    XmlElement* chanPubDate = [chan firstChildByName:@"lastBuildDate"];
    
    RssToken* token = [RssToken new];
    [token setTitle:[chanTitle value]];
    [token setLink:[chanLink value]];
    [token setDescription:[chanDescription value]];
    token.pubDate = chanPubDate.value;
    [token setItems:[NSMutableArray new]];
    
    for (id item in  [chan allChildsByName:@"item"]) {
        [[token items] addObject:[RssToken parseItem:item]];
    }
    return token;
}

+(RssItem*)parseItem:(XmlElement*)item
{
    XmlElement* itemTitle = [item firstChildByName:@"title"];
    XmlElement* itemLink = [item firstChildByName:@"link"];
    XmlElement* itemPubDate = [item firstChildByName:@"pubDate"];
        
    id rssItem = [RssItem new];
    [rssItem setTitle:[itemTitle value]];
    [rssItem setLink:[itemLink value]];
    [rssItem setPubDate:[itemPubDate value]];
    return rssItem;
}

@end
