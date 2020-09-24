 

#import "WalletDBManager.h"

 

static NSString *const dbName = @"walletDB.sqlite";

@interface WalletDBManager ()
{
    NSString *_dbPath;
}
@end

@implementation WalletDBManager

+ (WalletDBManager *)defaultManager
{
    static WalletDBManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[WalletDBManager alloc] init];
        }
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:dbName];
        NSLog(@"dbPath: %@", _dbPath);
        _currentWallet = [WalletModel new];
    }
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
      if ([db open]) {
         
         [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Wallet (id integer primary key autoincrement, name text, memoryWord text, privateKey text, publicKey text, address text, isCurrentWallet integer, userId text, cmid text, isBackup integer,imgUrl text,by text)"];
          
          [db close];
          
      }
    
    return self;
}

 
- (WalletModel *)findCurrentWallet
{
    WalletModel *model = [WalletModel new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
         
        BOOL res = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Wallet (id integer primary key autoincrement, name text, memoryWord text, privateKey text, publicKey text, address text, isCurrentWallet integer, userId text, cmid text, isBackup integer,imgUrl text,by text)"];
        if (res) {
            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Wallet WHERE isCurrentWallet = 1"];
            while (resultSet.next) {
                model.ID = [resultSet intForColumn:@"id"];
                model.name = [resultSet stringForColumn:@"name"];
                model.memoryWord = [resultSet stringForColumn:@"memoryWord"];
                model.privateKey = [resultSet stringForColumn:@"privateKey"];
                model.publicKey = [resultSet stringForColumn:@"publicKey"];
                model.address = [resultSet stringForColumn:@"address"];
                model.isCurrentWallet = [resultSet intForColumn:@"isCurrentWallet"];
                model.userId = [resultSet stringForColumn:@"userId"];
                model.cmid = [resultSet stringForColumn:@"cmid"];
                model.isBackup = [resultSet intForColumn:@"isBackup"];
                model.imgUrl = [resultSet stringForColumn:@"imgUrl"];
                
                break;
            }
            [resultSet close];
            [db close];
        }
    }
    self.currentWallet = model;
    return model;
}

 
- (BOOL)addWallet:(WalletModel *)model
{
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
       
        
        BOOL res = [db executeUpdate:@"INSERT INTO Wallet (name, memoryWord, privateKey, publicKey, address, isCurrentWallet, userId, cmid, isBackup ,imgUrl) VALUES (?,?,?,?,?,?,?,?,?,?)", model.name, model.memoryWord, model.privateKey, model.publicKey, model.address, @(model.isCurrentWallet), model.userId, model.cmid, @(model.isBackup),model.imgUrl];
        [db close];
        if (res) {
         
            self.currentWallet = model;
            return YES;
        }
        else {
            
        }
    }
    return NO;
}

 
- (WalletModel *)findWalletByPrivateKey:(NSString *)privateKey
{
    WalletModel *model = [WalletModel new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Wallet WHERE privateKey = ?", privateKey];
        while (resultSet.next) {
            model.ID = [resultSet intForColumn:@"id"];
            model.name = [resultSet stringForColumn:@"name"];
            model.memoryWord = [resultSet stringForColumn:@"memoryWord"];
            model.privateKey = [resultSet stringForColumn:@"privateKey"];
            model.publicKey = [resultSet stringForColumn:@"publicKey"];
            model.address = [resultSet stringForColumn:@"address"];
            model.isCurrentWallet = [resultSet intForColumn:@"isCurrentWallet"];
            model.userId = [resultSet stringForColumn:@"userId"];
            model.cmid = [resultSet stringForColumn:@"cmid"];
            model.isBackup = [resultSet intForColumn:@"isBackup"];
            model.imgUrl = [resultSet stringForColumn:@"imgUrl"];
        }
        [resultSet close];
        [db close];
    }
    return model;
}

 
- (BOOL)setCurrentWalletBackedUp
{
    if (!self.currentWallet || !self.currentWallet.privateKey || [self.currentWallet.privateKey isEqualToString:@""]) {
        return NO;
    }
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"UPDATE Wallet SET isBackup = 1 WHERE privateKey = ?", self.currentWallet.privateKey];
        [db close];
        if (res) {
           
            self.currentWallet.isBackup = 1;
            return YES;
        }
        else {
           
        }
    }
    return NO;
}
 
- (BOOL)setCurrentWalletCMID:(NSString *)cmid
{
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"UPDATE Wallet SET cmid = ? WHERE privateKey = ?", cmid, self.currentWallet.privateKey];
        [db close];
        if (res) {
          
            self.currentWallet.cmid = cmid;
            return YES;
        }
        else {
             
        }
    }
    return NO;
}
 
- (NSArray *)findAllWallets
{
    NSMutableArray *arr = [NSMutableArray array];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Wallet"];
        while (resultSet.next) {
            WalletModel *model = [WalletModel new];
            model.ID = [resultSet intForColumn:@"id"];
            model.name = [resultSet stringForColumn:@"name"];
            model.memoryWord = [resultSet stringForColumn:@"memoryWord"];
            model.privateKey = [resultSet stringForColumn:@"privateKey"];
            model.publicKey = [resultSet stringForColumn:@"publicKey"];
            model.address = [resultSet stringForColumn:@"address"];
            model.isCurrentWallet = [resultSet intForColumn:@"isCurrentWallet"];
            model.userId = [resultSet stringForColumn:@"userId"];
            model.cmid = [resultSet stringForColumn:@"cmid"];
            model.isBackup = [resultSet intForColumn:@"isBackup"];
            model.imgUrl = [resultSet stringForColumn:@"imgUrl"];
            [arr addObject:model];
        }
        [resultSet close];
        [db close];
    }
    return arr;
}

 
- (NSArray *)findOtherWallets
{
    NSMutableArray *arr = [NSMutableArray array];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Wallet WHERE privateKey != ?", self.currentWallet.privateKey];
        while (resultSet.next) {
            WalletModel *model = [WalletModel new];
            model.ID = [resultSet intForColumn:@"id"];
            model.name = [resultSet stringForColumn:@"name"];
            model.memoryWord = [resultSet stringForColumn:@"memoryWord"];
            model.privateKey = [resultSet stringForColumn:@"privateKey"];
            model.publicKey = [resultSet stringForColumn:@"publicKey"];
            model.address = [resultSet stringForColumn:@"address"];
            model.isCurrentWallet = [resultSet intForColumn:@"isCurrentWallet"];
            model.userId = [resultSet stringForColumn:@"userId"];
            model.cmid = [resultSet stringForColumn:@"cmid"];
            model.isBackup = [resultSet intForColumn:@"isBackup"];
            model.imgUrl = [resultSet stringForColumn:@"imgUrl"];
            [arr addObject:model];
        }
        [resultSet close];
        [db close];
    }
    return arr;
}

 
- (BOOL)deleteCurrentWallet
{
    if (!self.currentWallet || !self.currentWallet.privateKey || [self.currentWallet.privateKey isEqualToString:@""]) {
        return NO;
    }
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"DELETE FROM Wallet WHERE privateKey = ?", self.currentWallet.privateKey];
        [db close];
        if (res) {
            NSLog(@"删除成功");
            self.currentWallet = [WalletModel new];
            return YES;
        }
        else {
            NSLog(@"删除失败");
        }
    }
    return NO;
}
 
- (WalletModel *)findWallet
{
    WalletModel *model = [WalletModel new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Wallet"];
        while (resultSet.next) {
            model.ID = [resultSet intForColumn:@"id"];
            model.name = [resultSet stringForColumn:@"name"];
            model.memoryWord = [resultSet stringForColumn:@"memoryWord"];
            model.privateKey = [resultSet stringForColumn:@"privateKey"];
            model.publicKey = [resultSet stringForColumn:@"publicKey"];
            model.address = [resultSet stringForColumn:@"address"];
            model.isCurrentWallet = 1; //
            model.userId = [resultSet stringForColumn:@"userId"];
            model.cmid = [resultSet stringForColumn:@"cmid"];
            model.isBackup = [resultSet intForColumn:@"isBackup"];
            model.imgUrl = [resultSet stringForColumn:@"imgUrl"];
            break;
        }
        [resultSet close];
        [db close];
    }
    self.currentWallet = model;
    return model;
}


 
-(BOOL)updataCurrentWallet{
    
     FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
        if ([db open]) {
            BOOL res = [db executeUpdate:@"UPDATE Wallet SET isCurrentWallet = 0"];
            [db close];
            if (res) {
               
                
            }
            else {
                
            }
        }
        return NO;
}


 
- (WalletModel *)findIndexWallet
{
    WalletModel *model = [WalletModel new];
      NSInteger count = 0;
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Wallet where isCurrentWallet = 1"];
       
      
        while (resultSet.next) {count++;
            model.ID = [resultSet intForColumn:@"id"];
            model.name = [resultSet stringForColumn:@"name"];
            model.memoryWord = [resultSet stringForColumn:@"memoryWord"];
            model.privateKey = [resultSet stringForColumn:@"privateKey"];
            model.publicKey = [resultSet stringForColumn:@"publicKey"];
            model.address = [resultSet stringForColumn:@"address"];
            model.isCurrentWallet = 1; //
            model.userId = [resultSet stringForColumn:@"userId"];
            model.cmid = [resultSet stringForColumn:@"cmid"];
            model.isBackup = [resultSet intForColumn:@"isBackup"];
            model.imgUrl = [resultSet stringForColumn:@"imgUrl"];
            break;
        }
        [resultSet close];
        [db close];
    }
    if(count == 0)
       self.currentWallet =    [self tempabc];
    else
    self.currentWallet = model;
    return self.currentWallet;
}

-(WalletModel*)tempabc{
    
     WalletModel *model = [WalletModel new];
        
        FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
        if ([db open]) {
            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Wallet"];
           
           
            while (resultSet.next) {
                model.ID = [resultSet intForColumn:@"id"];
                model.name = [resultSet stringForColumn:@"name"];
                model.memoryWord = [resultSet stringForColumn:@"memoryWord"];
                model.privateKey = [resultSet stringForColumn:@"privateKey"];
                model.publicKey = [resultSet stringForColumn:@"publicKey"];
                model.address = [resultSet stringForColumn:@"address"];
                model.isCurrentWallet = 1; //
                model.userId = [resultSet stringForColumn:@"userId"];
                model.cmid = [resultSet stringForColumn:@"cmid"];
                model.isBackup = [resultSet intForColumn:@"isBackup"];
                model.imgUrl = [resultSet stringForColumn:@"imgUrl"];
                break;
            }
            [resultSet close];
            [db close];
        }
        
      
    return model;
}


 
- (BOOL)deleteCurrentWalletFun:(NSString*)wid
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"DELETE FROM Wallet WHERE address = ?", wid];
        [db close];
        if (res) {
           
            self.currentWallet = [WalletModel new];
            return YES;
        }
        else {
           
        }
    }
    return NO;
}


- (BOOL)deleteCurrentWalletFunAdress:(NSString*)wid{
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
       if ([db open]) {
           BOOL res = [db executeUpdate:@"DELETE FROM Wallet WHERE address = ?", wid];
           [db close];
           if (res) {
               
               return YES;
           }
           else {
             
           }
       }
       return NO;
    
}


 
- (BOOL)upIndexWallet:(NSString*)address0
{
    if (!self.currentWallet || !self.currentWallet.privateKey || [self.currentWallet.privateKey isEqualToString:@""]) {
        return NO;
    }
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"UPDATE Wallet SET isCurrentWallet = 1 WHERE address = ?", address0];
        [db close];
        if (res) {
            
            self.currentWallet.isBackup = 1;
            return YES;
        }
        else {
           
        }
    }
    return NO;
}



 
-(BOOL)upWalletName:(NSString* )name wheretoAdress:(NSString* )address{
    if (!self.currentWallet || !self.currentWallet.privateKey || [self.currentWallet.privateKey isEqualToString:@""]) {
        return NO;
    }
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"UPDATE Wallet SET name = ? WHERE address = ?",name,address];
        [db close];
        if (res) {
           
            return YES;
        }
        else {
            
        }
    }
    return NO;
}
@end
