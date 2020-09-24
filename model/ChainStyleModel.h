 
#import <Foundation/Foundation.h>

@interface ChainStyleModel : NSObject

@property(nonatomic,copy)NSString* chainid;
@property(nonatomic,copy)NSString*  logo;
@property(nonatomic,copy)NSString* name;  
@property(nonatomic,copy)NSString* address;  
@property(nonatomic,copy)NSString* privatekey;
@property(nonatomic,copy)NSString* zt;
- (instancetype)initWithDictionary:(NSDictionary* )dic;

@end
