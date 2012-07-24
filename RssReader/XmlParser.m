
#import "XmlParser.h"

@interface XmlParser()
{
    XmlElement* root;
    XmlElement* current;
    NSInteger deep;
}
@property(nonatomic) XmlElement* root;
@property(nonatomic) XmlElement* current;

-(BOOL)parseWithData:(NSData*)data;
@end



@implementation XmlParser
@synthesize root, current;

+(XmlElement*)parse:(NSData*)data
{
    XmlParser* xp = [XmlParser new];
    return [xp parseWithData:data] ? [xp root] : nil;
}

-(BOOL)parseWithData:(NSData*)data
{
    //NSLog(@"start parse");
    id p = [[NSXMLParser alloc]initWithData:data];
    [p setDelegate:self];
    deep = 0;
    return [p parse];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict 
{
    //NSLog(@"start element %@", elementName);   
        
    XmlElement* el = [XmlElement new];
    [el setName:elementName];
    [el setValue:@""];
    [el setAttrs:attributeDict];
    [el setChilds:[NSMutableArray new]];
    if ([self current])
    {
        [el setDeep:deep];
        [el setParent:[self current]];
        [[[self current] childs] addObject:el];
    }
    [self setCurrent:el];
    if (deep == 0) [self setRoot:[self current]];
    deep++;
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
{
    [self setCurrent:[current parent]];
    deep--;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
    id val = [[[self current]value] stringByAppendingString:string];
	[[self current] setValue:val];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"parseError %@", parseError);   
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError 
{
    NSLog(@"validError %@", validError);   	
}

@end
