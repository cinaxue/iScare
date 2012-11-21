//
//  AllPath.m
//  booksMe
//
//  Created by ihope ihope on 11-8-18.
//  Copyright 2011 北京. All rights reserved.
//

#import "AllPath.h"
#import "Tools.h"

@implementation AllPath

+(NSString*)getDocPath{
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	return docPath;
}

-(void) test
{
    self = [super init];
    if (self) {
        
        NSMutableArray *mWordList;
        
        // get word list
        NSString *path = [[AllPath getDocPath] stringByAppendingFormat:@"/Words.plist"];
        NSDictionary *aDic;
        
        // create words.plist if the local words plist does not exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"WordList" ofType:@"plist"];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:defaultPath]) {
                [[NSFileManager defaultManager] copyItemAtPath:defaultPath toPath:path error:nil];
                [Tools addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:path]];
            }else {
                [Tools showAlert:@"初始化列表没有找到！"];
            }
        }
        
        aDic = [NSDictionary dictionaryWithContentsOfFile:path];        
        mWordList = [[aDic objectForKey:@"Words"] mutableCopy];
    }
}

@end
