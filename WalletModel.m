 

#import "WalletModel.h"

@implementation WalletModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ID = -1;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
     memoryWord:(NSString *)memoryWord
     privateKey:(NSString *)privateKey
      publicKey:(NSString *)publicKey
        address:(NSString *)address
isCurrentWallet:(NSInteger)isCurrentWallet
         userId:(NSString *)userId
           cmid:(NSString *)cmid
       isBackup:(NSInteger)isBackup
        imgUrl:(NSString* )imgUrl;
{
    self = [super init];
    if (self) {
        self.name = name;
        self.memoryWord = memoryWord;
        self.privateKey = privateKey;
        self.publicKey = publicKey;
        self.address = address;
        self.isCurrentWallet = isCurrentWallet == 1? 1: 0;
        self.userId = userId;
        self.cmid = cmid;
        self.isBackup = isBackup == 1? 1: 0;
        
       
        UIImage *image2 = [UIImage imageNamed:@"wallet_default_logo.png"];
        NSString *path_document = NSHomeDirectory();
        
        
        NSString*   newPathImgStr=[NSString stringWithFormat:@"/Documents/%@.png",address];
       
        NSString *imagePath = [path_document stringByAppendingString:newPathImgStr];
         
        [UIImagePNGRepresentation(image2) writeToFile:imagePath atomically:YES];
        
        
        self.imgUrl=imagePath;
    }
    return self;
}

@end
