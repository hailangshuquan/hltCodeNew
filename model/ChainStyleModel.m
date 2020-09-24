 
#import "ChainStyleModel.h"

@implementation ChainStyleModel

- (instancetype)initWithDictionary:(NSDictionary* )dic{
    
    if (self=[super init]) {
        
        self.chainid=[NSString stringWithFormat:@"%@",dic[@"chainid"]];
        self.logo=dic[@"url"];
        self.name=dic[@"name"];
    }
    return self;
}



@end
