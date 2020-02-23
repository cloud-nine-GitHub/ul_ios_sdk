//
//  ULAccountSQLiteManager.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/21.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULAccountSQLiteManager.h"
#import <sqlite3.h>


static NSString *const ULA_SQLITE_NAME = @"ULAccount.sqlite";//数据库名
static NSString *const ULA_SQLITE_TABLE_NAME = @"ulaccount_table";//表名
static NSString *const ULA_SQLITE_TABLE_UP_DATA_ID = @"up_data_id";
static NSString *const ULA_SQLITE_TABLE_UP_DATA = @"up_data";


@interface ULAccountSQLiteManager ()

@property (nonatomic,assign) sqlite3 *db;

@end

@implementation ULAccountSQLiteManager


static ULAccountSQLiteManager *instance = nil;

+ (instancetype)getInstance
{
    //确保整个应用启动后只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//打开数据库，返回是布尔值
- (BOOL)openDB
{
    NSLog(@"%s",__func__);
    //数据库路径，app内数据库文件存放路径-一般存放在沙盒中
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:ULA_SQLITE_NAME];
    //打开数据库，不存在的情况下自动创建
    if (sqlite3_open(DBPath.UTF8String, &_db) != SQLITE_OK) {
        //数据库打开失败
        NSLog(@"%s:数据库打开失败",__func__);
        return NO;
    }else{
        
        return YES;
    }
}

//关闭数据库
- (void)closeDB
{
    NSLog(@"%s",__func__);
    // 关闭数据库
    sqlite3_close(_db);
}


//创建表
- (BOOL)createTable
{
    NSLog(@"%s",__func__);
    //NOT NULL不为空
    //PRIMARY KEY 唯一
    //AUTOINCREMENT 自增
    NSString *createTableStr = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"CREATE TABLE IF NOT EXISTS ",ULA_SQLITE_TABLE_NAME,@" (",ULA_SQLITE_TABLE_UP_DATA_ID,@" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ",ULA_SQLITE_TABLE_UP_DATA,@" TEXT)"];
    
    if([self execuSQL:createTableStr])
    {
        return YES;
    }
    
    return NO;
}



#pragma 执行SQL语句
- (BOOL)execuSQL:(NSString *)sqlStr
{
    NSLog(@"%s",__func__);
    char *error;
    if (sqlite3_exec(_db, sqlStr.UTF8String, nil, nil, &error) == SQLITE_OK) {
        return YES;
    }else{
        NSLog(@"%s:执行SQL语句出错:%s",__func__,error);
        return NO;
    }
}



/*
 增加数据
 */
- (BOOL) insertData:(NSString *)upData
{
    NSLog(@"%s",__func__);
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values('%@')", ULA_SQLITE_TABLE_NAME,ULA_SQLITE_TABLE_UP_DATA,upData];
    if([self execuSQL:sql])
    {
        return YES;
    }else{
        return NO;
    }
}

/*
 获取当前数据库中的数据总条数
 **/

- (long)getCountNumFromSqlite
{
    return 0;
}


/*
 删除数据
 */
- (BOOL)deleteData :(long )idNum
{
     NSLog(@"%s",__func__);
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ <= '%ld'",ULA_SQLITE_TABLE_NAME,ULA_SQLITE_TABLE_UP_DATA_ID,idNum];
    if([self execuSQL:sql])
    {
        return YES;
    }else{
        return NO;
    }
}



/*
 查询数据
 */
- (void) queryData:(NSString *)upData
{
    NSLog(@"%s",__func__);
}


/*
 修改数据
 */
- (void) update
{
    NSLog(@"%s",__func__);
}


@end
