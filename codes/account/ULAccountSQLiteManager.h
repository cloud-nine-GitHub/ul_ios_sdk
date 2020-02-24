//
//  ULAccountSQLiteManager.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/21.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULAccountSQLiteManager : NSObject

{
    
}

+ (instancetype)getInstance;
- (BOOL)openDB;
- (void)closeDB;
- (BOOL)createTable;
- (BOOL)execuSQL:(NSString *)sqlStr;
- (BOOL) insertData:(NSString *)upData;
- (BOOL)deleteData :(long )idNum;
- (void) queryData:(NSString *)upData;
- (void) update;
- (long)getCountNumFromSqlite;
- (NSMutableArray *)getCountUpData;
@end

NS_ASSUME_NONNULL_END
