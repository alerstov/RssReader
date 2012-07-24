
#import <Foundation/Foundation.h>

@interface XmlElement : NSObject
{
    NSString* name;
    NSString* value;
    NSDictionary* attrs;
    
    NSInteger deep;
    XmlElement* parent;
    NSMutableArray* childs;
}

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* value;
@property (nonatomic) NSDictionary* attrs;
@property (nonatomic) NSInteger deep;
@property (nonatomic) XmlElement* parent;
@property (nonatomic) NSMutableArray* childs;

-(XmlElement*)firstChildByName:(NSString*)name;
-(NSArray*)allChildsByName:(NSString*)childName;

@end
