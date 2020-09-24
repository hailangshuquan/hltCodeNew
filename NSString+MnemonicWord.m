 
#import "NSString+MnemonicWord.h"


#import "NSData+MyChange.h"
#import "NSString+MyChange.h"

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@implementation NSString (MnemonicWord)


 
+(NSString *)generateMnemonicString:(NSNumber *)strlength language:(NSString *)language
{
    
    if([strlength integerValue] % 32 != 0)
    {
        [NSException raise:@"Strength must be divisible by 32" format:@"Strength Was: %@",strlength];
    }
    
   
    NSMutableData *bytes = [NSMutableData dataWithLength:([strlength integerValue]/8)];
    
    
    int status = SecRandomCopyBytes(kSecRandomDefault, bytes.length, bytes.mutableBytes);
    
 
    if(status == 0)
    {
        NSString *hexString = [bytes my_hexString];
        
        return [self mnemonicStringFromRandomHexString:hexString language:language];
    }
    else
    {
        [NSException raise:@"Unable to get random data!" format:@"Unable to get random data!"];
    }
    return nil;
}


 
+ (NSString *)mnemonicStringFromRandomHexString:(NSString *)seed language:(NSString *)language
{
    
    NSData *seedData = [seed my_dataFromHexString];
    
 
    NSMutableData *hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(seedData.bytes, (int)seedData.length, hash.mutableBytes);
    
    
    NSMutableArray *checkSumBits = [NSMutableArray arrayWithArray:[[NSData dataWithData:hash] my_hexToBitArray]];
    
    NSMutableArray *seedBits = [NSMutableArray arrayWithArray:[seedData my_hexToBitArray]];
    
    for(int i = 0 ; i < (int)seedBits.count / 32 ; i++)
    {
        [seedBits addObject:checkSumBits[i]];
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@.txt",[[NSBundle mainBundle] bundlePath], language];
    NSString *fileText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lines = [fileText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
    NSMutableArray *words = [NSMutableArray arrayWithCapacity:(int)seedBits.count / 11];
    
    for(int i = 0 ; i < (int)seedBits.count / 11 ; i++)
    {
        NSUInteger wordNumber = strtol([[[seedBits subarrayWithRange:NSMakeRange(i * 11, 11)] componentsJoinedByString:@""] UTF8String], NULL, 2);
        
        [words addObject:lines[wordNumber]];
    }
    
    return [words componentsJoinedByString:@" "];
    
}

 
+ (BOOL)standardThesaurusContainWords:(NSString *)words {
    NSArray *wordsArray = [words componentsSeparatedByString:@" "];
    
    NSString *wordsPath = [NSString stringWithFormat:@"%@/english.txt",[[NSBundle mainBundle] bundlePath]];
    NSString *fileText = [NSString stringWithContentsOfFile:wordsPath encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lines = [fileText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    BOOL isContains = YES;
    for (NSString *word in wordsArray) {
        if (![lines containsObject:word]) {
            isContains = NO;
            break;
        }
    }
    return isContains;
}


@end
