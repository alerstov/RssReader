
#import "XmlElement.h"

@implementation XmlElement

@synthesize name, value, attrs;
@synthesize deep, parent, childs;

-(XmlElement*)firstChildByName:(NSString*)childName
{
    for (XmlElement* c in childs) {
        if ([[c name] isEqualToString:childName]) return c;
    }
    return nil;
}

-(NSArray*)allChildsByName:(NSString*)childName
{
    id arr = [NSMutableArray new];
    for (XmlElement* c in childs) 
    {
        if ([[c name] isEqualToString:childName])
        {
            [arr addObject:c];
        }
    }
    return arr;
}


@end
