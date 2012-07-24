
#import <Foundation/Foundation.h>
#import "XmlElement.h"


@interface XmlParser : NSObject<NSXMLParserDelegate>

+(XmlElement*)parse:(NSData*)data;

@end
