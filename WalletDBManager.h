 

#import <Foundation/Foundation.h>
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDBManager : NSObject

 
@property (nonatomic, strong) WalletModel *currentWallet;
 

 
+ (WalletDBManager *)defaultManager;
- (WalletModel *)findCurrentWallet;
 
- (BOOL)addWallet:(WalletModel *)model;
 
- (WalletModel *)findWalletByPrivateKey:(NSString *)privateKey;
 
- (BOOL)setCurrentWalletBackedUp;
 
- (BOOL)setCurrentWalletCMID:(NSString *)cmid;
 
- (BOOL)deleteCurrentWallet;




 
- (WalletModel *)findWallet;


//---------------------------------------------

 
- (BOOL)deleteCurrentWalletFun:(NSString*)wid;

 
- (BOOL)deleteCurrentWalletFunAdress:(NSString*)wid;








 
- (WalletModel *)findIndexWallet;

 
-(BOOL)updataCurrentWallet;
 
- (NSArray *)findAllWallets;
 
- (NSArray *)findOtherWallets;
 
- (BOOL)upIndexWallet:(NSString*)address0;


 
-(BOOL)upWalletName:(NSString* )name wheretoAdress:(NSString* )address;


@end

NS_ASSUME_NONNULL_END
