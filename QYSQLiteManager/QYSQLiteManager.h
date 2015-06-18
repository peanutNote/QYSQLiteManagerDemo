//
//  QYSQLiteManager.h
//  QYSQLiteManagerDemo
//
//  Created by qianye on 15/6/18.
//  Copyright (c) 2015年 qianye. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_SQLITE_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySql.db"]
// 声明一个block类型
typedef void(^FinishedBlock) (NSArray *dataList,NSString *error);


@interface QYSQLiteManager : NSObject

// 创建数据库
+ (BOOL)createTableWithSqlString:(NSString *)sql;
// 修改数据库
+ (BOOL)alterTableWithSqlString:(NSString *)sql;
// 删除数据库
+ (BOOL)dropTableWithSqlString:(NSString *)sql;

// 插入数据库(可变参数)
+ (BOOL)insertTableWithSqlString:(NSString *)sql
                      andObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

// 插入数据库(不可变参数)
+ (BOOL)insertTableWithSqlString:(NSString *)sql
                        andArray:(NSArray *)params;

// 查询数据(不可变参数)
+ (void)selectTableWithSqlString:(NSString *)sql
                        andArray:(NSArray *)params
                didFinishedBlock:(FinishedBlock)finishedBlock;

// 查询数据(可变参数)
+ (void)selectTableWithSqlString:(NSString *)sql
                didFinishedBlock:(FinishedBlock)finishedBlock
                      andObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

// 修改数据(不可变参数)
+ (BOOL)updateTableWithSqlString:(NSString *)sql
                        andArray:(NSArray *)params;

// 修改数据(可变参数)
+ (BOOL)updateTableWithSqlString:(NSString *)sql
                      andObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

// 删除数据(不可变参数)
+ (BOOL)deleteTableWithSqlString:(NSString *)sql
                        andArray:(NSArray *)params;

// 删除数据(可变参数)
+ (BOOL)deleteTableWithSqlString:(NSString *)sql
                      andObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

@end
