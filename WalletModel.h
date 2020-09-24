
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface WalletModel : NSObject

@property (nonatomic, assign) NSInteger ID; //
@property (nonatomic, copy) NSString *name; //
@property (nonatomic, copy) NSString *memoryWord; //
@property (nonatomic, copy) NSString *privateKey; //
@property (nonatomic, copy) NSString *publicKey; //
@property (nonatomic, copy) NSString *address; //
@property (nonatomic, assign) NSInteger isCurrentWallet;
@property (nonatomic, copy) NSString *userId; //
@property (nonatomic, copy) NSString *cmid; // CMID
//@property (nonatomic, assign) NSInteger isRegisterCMID; //
@property (nonatomic, assign) NSInteger isBackup; //
@property (nonatomic,copy) NSString* imgUrl;


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

@end

NS_ASSUME_NONNULL_END
