//
//  QYSQLiteManager.m
//  QYSQLiteManagerDemo
//
//  Created by qianye on 15/6/18.
//  Copyright (c) 2015年 qianye. All rights reserved.
//

#import "QYSQLiteManager.h"
#import <sqlite3.h>

// 日志输出
#ifdef DEBUG
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif

@implementation QYSQLiteManager

#pragma mark - 创建数据库
// 创建数据库
+ (BOOL)createTableWithSqlString:(NSString *)sql
{
    // 初始化一个数据库
    sqlite3 *sqlite = nil;
    // 打开数据库路径，如果不存就在该路径下创建
    NSString *path = DB_SQLITE_PATH;
    // 打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        MyLog(@"数据库打开失败"); // 测试时可有
        return NO;
    }
    // 执行sql语句
    char *error ; // 接受错误信息
    result = sqlite3_exec(sqlite, [sql UTF8String], NULL, nil, &error);
    if (result != SQLITE_OK) {
        MyLog(@"数据库创建失败%s",error); // 测试时可有
        return NO;
    }
    // 关闭数据库
    sqlite3_close(sqlite);
    return YES;
}

// 修改数据库
+ (BOOL)alterTableWithSqlString:(NSString *)sql
{
    // 初始化一个数据库
    sqlite3 *sqlite = nil;
    // 打开数据库路径，如果不存就在该路径下创建
    NSString *path = DB_SQLITE_PATH;
    // 打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        MyLog(@"数据库打开失败"); // 测试时可有
        return NO;
    }
    // 执行sql语句
    char *error ; // 接受错误信息
    result = sqlite3_exec(sqlite, [sql UTF8String], NULL, nil, &error);
    if (result != SQLITE_OK) {
        MyLog(@"修改表失败%s",error); // 测试时可有
        return NO;
    }
    // 关闭数据库
    sqlite3_close(sqlite);
    return YES;
}
// 删除数据库
+ (BOOL)dropTableWithSqlString:(NSString *)sql
{
    // 初始化一个数据库
    sqlite3 *sqlite = nil;
    // 打开数据库路径，如果不存就在该路径下创建
    NSString *path = DB_SQLITE_PATH;
    // 打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        MyLog(@"数据库打开失败"); // 测试时可有
        return NO;
    }
    // 执行sql语句
    char *error ; // 接受错误信息
    result = sqlite3_exec(sqlite, [sql UTF8String], NULL, nil, &error);
    if (result != SQLITE_OK) {
        MyLog(@"删除表失败%s",error); // 测试时可有
        return NO;
    }
    // 关闭数据库
    sqlite3_close(sqlite);
    return YES;
}

#pragma mark - 插入数据库
// 插入数据库(不可变参数)
+ (BOOL)insertTableWithSqlString:(NSString *)sql andArray:(NSArray *)params
{
    // 初始化一个数据库
    sqlite3 *sqlite = nil;
    // 数据库路径
    NSString *path = DB_SQLITE_PATH;
    // 打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        MyLog(@"数据库打开失败");
        return NO;
    }
    // 创建一个句柄
    sqlite3_stmt *stmt = nil;
    // 编译sql语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        MyLog(@"编译失败");
        return NO;
    }
    // 绑定数据
    for (int i = 0;i < params.count;i++) {
        // 如果数据是字符串
        if([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i+1, [params[i] UTF8String], -1, NULL);
        }
        // 如果数据是整数
        if([params[i] isKindOfClass:[NSNumber class]]) {
            sqlite3_bind_int(stmt, i+1, [params[i] intValue]);
        }
    }
    // 执行句柄
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        MyLog(@"插入失败");
        // 关闭句柄
        sqlite3_finalize(stmt);
        // 关闭数据库
        sqlite3_close(sqlite);
        return NO;
    }
    // 关闭句柄
    sqlite3_finalize(stmt);
    // 关闭数据库
    sqlite3_close(sqlite);
    
    return YES;
}

// 插入数据库(可变参数)
+ (BOOL)insertTableWithSqlString:(NSString *)sql andObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    // 初始化一个可变数组用来存放参数
    NSMutableArray *params = [NSMutableArray array];
    // 创建一个指针指向一个指针列表
    va_list firstList;
    // 将指针的初始位置指向第一个指针列表的第一个指针
    va_start(firstList, firstObj);
    // 如果参数大于一个
    if(firstObj)
    {
        [params addObject:firstObj];
        // 让指针指向指针列表的下一个指针
        id arg; // 存放下一个指针
        while((arg= va_arg(firstList, id)))
        {
            [params addObject:arg];
        }
        // 置空指针
        va_end(firstList);
    }
    
    // 初始化一个数据库
    sqlite3 *sqlite = nil;
    // 数据库路径
    NSString *path = DB_SQLITE_PATH;
    // 打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        MyLog(@"数据库打开失败");
        return NO;
    }
    // 创建一个句柄
    sqlite3_stmt *stmt = nil;
    // 编译sql语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        MyLog(@"编译失败");
        return NO;
    }
    // 绑定数据
    for (int i = 0;i < params.count;i++) {
        // 如果数据是字符串
        if([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i+1, [params[i] UTF8String], -1, NULL);
        }
        // 如果数据是整数
        if([params[i] isKindOfClass:[NSNumber class]]) {
            sqlite3_bind_int(stmt, i+1, [params[i] intValue]);
        }
    }
    // 执行句柄
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        MyLog(@"插入失败");
        // 关闭句柄
        sqlite3_finalize(stmt);
        // 关闭数据库
        sqlite3_close(sqlite);
        return NO;
    }
    // 关闭句柄
    sqlite3_finalize(stmt);
    // 关闭数据库
    sqlite3_close(sqlite);
    
    return YES;
}

#pragma mark - 查询数据
// 查询数据(不可变参数)
+ (void)selectTableWithSqlString:(NSString *)sql
                        andArray:(NSArray *)params
                didFinishedBlock:(FinishedBlock)finishedBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            // 初始化一个数据库
            sqlite3 *sqlite = nil;
            // 数据库路径
            NSString *path = DB_SQLITE_PATH;
            // 打开数据库
            int result = sqlite3_open([path UTF8String], &sqlite);
            if (result != SQLITE_OK) {
                MyLog(@"数据库打开失败");
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(nil,@"数据库打开失败");
                });
                return ;
            }
            // 创建一个句柄
            sqlite3_stmt *stmt = nil;
            // 编译sql语句
            result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
            if (result != SQLITE_OK) {
                MyLog(@"编译失败");
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(nil,@"编译失败");
                });
                return ;
            }
            // 绑定数据
            for (int i = 0;i < params.count;i++) {
                // 如果数据是字符串
                if([params[i] isKindOfClass:[NSString class]]) {
                    sqlite3_bind_text(stmt, i+1, [params[i] UTF8String], -1, NULL);
                }
                // 如果数据是整数
                if([params[i] isKindOfClass:[NSNumber class]]) {
                    sqlite3_bind_int(stmt, i+1, [params[i] intValue]);
                }
            }
            // 执行句柄,并且返回一组数据到stmt中
            result = sqlite3_step(stmt);
            // 创建可变数组接受数据
            NSMutableArray *dataList = [NSMutableArray array];
            while (result == SQLITE_ROW) {
                // 创建可变字典存储当前这组数据
                NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
                // 获取当前数据的字段数
                int column_count = sqlite3_column_count(stmt);
                for (int i = 0; i < column_count; i++) {
                    // 获取字段名
                    char * keyName = (char *)sqlite3_column_name(stmt, i);
                    NSString *key = [NSString stringWithUTF8String:keyName];
                    if (sqlite3_column_type(stmt, i) == SQLITE_TEXT) { // 当字段数据是“text”时
                        // 获取字段对应的数据
                        char *valueName = (char *)sqlite3_column_text(stmt, i);
                        NSString *value = [NSString stringWithUTF8String:valueName];
                        [dataDic setObject:value forKey:key];
                    } else { // 当字段数据是integer时
                        int value = sqlite3_column_int(stmt, i);
                        [dataDic setObject:@(value) forKey:key];
                    }
                }
                // 将读取的字典存到数组
                [dataList addObject:dataDic];
                // 读取下一条数据,并继续循环
                result = sqlite3_step(stmt);
            }
            // 关闭句柄
            sqlite3_finalize(stmt);
            // 关闭数据库
            sqlite3_close(sqlite);
            // 返回数组
            dispatch_async(dispatch_get_main_queue(),^{
                finishedBlock(dataList,nil);
            });
        }
    });
    
}

// 查询数据(可变参数)
+ (void)selectTableWithSqlString:(NSString *)sql
                didFinishedBlock:(FinishedBlock)finishedBlock
                      andObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    // 初始化一个可变数组用来存放参数
    NSMutableArray *params = [NSMutableArray array];
    // 创建一个指针指向一个指针列表
    va_list firstList;
    // 将指针的初始位置指向第一个指针列表的第一个指针
    va_start(firstList, firstObj);
    // 如果参数大于一个
    if(firstObj)
    {
        [params addObject:firstObj];
        // 让指针指向指针列表的下一个指针
        id arg; // 存放下一个指针
        while((arg= va_arg(firstList, id)))
        {
            [params addObject:arg];
        }
        // 置空指针
        va_end(firstList);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            // 初始化一个数据库
            sqlite3 *sqlite = nil;
            // 数据库路径
            NSString *path = DB_SQLITE_PATH;
            // 打开数据库
            int result = sqlite3_open([path UTF8String], &sqlite);
            if (result != SQLITE_OK) {
                MyLog(@"数据库打开失败");
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(nil,@"数据库打开失败");
                });
                return ;
            }
            // 创建一个句柄
            sqlite3_stmt *stmt = nil;
            // 编译sql语句
            result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
            if (result != SQLITE_OK) {
                MyLog(@"编译失败");
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(nil,@"编译失败");
                });
                return ;
            }
            // 绑定数据
            for (int i = 0;i < params.count;i++) {
                // 如果数据是字符串
                if([params[i] isKindOfClass:[NSString class]]) {
                    sqlite3_bind_text(stmt, i+1, [params[i] UTF8String], -1, NULL);
                }
                // 如果数据是整数
                if([params[i] isKindOfClass:[NSNumber class]]) {
                    sqlite3_bind_int(stmt, i+1, [params[i] intValue]);
                }
            }
            // 执行句柄,并且返回一组数据到stmt中
            result = sqlite3_step(stmt);
            // 创建可变数组接受数据
            NSMutableArray *dataList = [NSMutableArray array];
            while (result == SQLITE_ROW) {
                // 创建可变字典存储当前这组数据
                NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
                // 获取当前数据的字段数
                int column_count = sqlite3_column_count(stmt);
                for (int i = 0; i < column_count; i++) {
                    // 获取字段名
                    char * keyName = (char *)sqlite3_column_name(stmt, i);
                    NSString *key = [NSString stringWithUTF8String:keyName];
                    if (sqlite3_column_type(stmt, i) == SQLITE_TEXT) { // 当字段数据是“text”时
                        // 获取字段对应的数据
                        char *valueName = (char *)sqlite3_column_text(stmt, i);
                        NSString *value = [NSString stringWithUTF8String:valueName];
                        [dataDic setObject:value forKey:key];
                    } else { // 当字段数据是integer时
                        int value = sqlite3_column_int(stmt, i);
                        [dataDic setObject:@(value) forKey:key];
                    }
                }
                // 将读取的字典存到数组
                [dataList addObject:dataDic];
                // 读取下一条数据,并继续循环
                result = sqlite3_step(stmt);
            }
            // 关闭句柄
            sqlite3_finalize(stmt);
            // 关闭数据库
            sqlite3_close(sqlite);
            // 返回数组
            dispatch_async(dispatch_get_main_queue(),^{
                finishedBlock(dataList,nil);
            });
        }
    });
}

#pragma mark - 修改数据
// 修改数据(不可变参数)
+ (BOOL)updateTableWithSqlString:(NSString *)sql
                        andArray:(NSArray *)params
{
    // 初始化一个数据库
    sqlite3 *sqlite = nil;
    // 数据库路径
    NSString *path = DB_SQLITE_PATH;
    // 打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        MyLog(@"数据库打开失败");
        return NO;
    }
    // 创建一个句柄
    sqlite3_stmt *stmt = nil;
    // 编译sql语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        MyLog(@"编译失败");
        return NO;
    }
    // 绑定数据
    for (int i = 0;i < params.count;i++) {
        // 如果数据是字符串
        if([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i+1, [params[i] UTF8String], -1, NULL);
        }
        // 如果数据是整数
        if([params[i] isKindOfClass:[NSNumber class]]) {
            sqlite3_bind_int(stmt, i+1, [params[i] intValue]);
        }
    }
    // 执行句柄
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        MyLog(@"修改失败");
        // 关闭句柄
        sqlite3_finalize(stmt);
        // 关闭数据库
        sqlite3_close(sqlite);
        return NO;
    }
    // 关闭句柄
    sqlite3_finalize(stmt);
    // 关闭数据库
    sqlite3_close(sqlite);
    
    return YES;
}

// 修改数据(可变参数)
+ (BOOL)updateTableWithSqlString:(NSString *)sql
                      andObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    // 初始化一个可变数组用来存放参数
    NSMutableArray *params = [NSMutableArray array];
    // 创建一个指针指向一个指针列表
    va_list firstList;
    // 将指针的初始位置指向第一个指针列表的第一个指针
    va_start(firstList, firstObj);
    // 如果参数大于一个
    if(firstObj)
    {
        [params addObject:firstObj];
        // 让指针指向指针列表的下一个指针
        id arg; // 存放下一个指针
        while((arg= va_arg(firstList, id)))
        {
            [params addObject:arg];
        }
        // 置空指针
        va_end(firstList);
    }
    
    // 初始化一个数据库
    sqlite3 *sqlite = nil;
    // 数据库路径
    NSString *path = DB_SQLITE_PATH;
    // 打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        MyLog(@"数据库打开失败");
        return NO;
    }
    // 创建一个句柄
    sqlite3_stmt *stmt = nil;
    // 编译sql语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        MyLog(@"编译失败");
        return NO;
    }
    // 绑定数据
    for (int i = 0;i < params.count;i++) {
        // 如果数据是字符串
        if([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i+1, [params[i] UTF8String], -1, NULL);
        }
        // 如果数据是整数
        if([params[i] isKindOfClass:[NSNumber class]]) {
            sqlite3_bind_int(stmt, i+1, [params[i] intValue]);
        }
    }
    // 执行句柄
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        MyLog(@"修改失败");
        // 关闭句柄
        sqlite3_finalize(stmt);
        // 关闭数据库
        sqlite3_close(sqlite);
        return NO;
    }
    // 关闭句柄
    sqlite3_finalize(stmt);
    // 关闭数据库
    sqlite3_close(sqlite);
    
    return YES;
}

#pragma mark - 删除数据
// 删除数据(不可变参数)
+ (BOOL)deleteTableWithSqlString:(NSString *)sql
                        andArray:(NSArray *)params
{
    // 初始化一个数据库
    sqlite3 *sqlite = nil;
    // 数据库路径
    NSString *path = DB_SQLITE_PATH;
    // 打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        MyLog(@"数据库打开失败");
        return NO;
    }
    // 创建一个句柄
    sqlite3_stmt *stmt = nil;
    // 编译sql语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        MyLog(@"编译失败");
        return NO;
    }
    // 绑定数据
    for (int i = 0;i < params.count;i++) {
        // 如果数据是字符串
        if([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i+1, [params[i] UTF8String], -1, NULL);
        }
        // 如果数据是整数
        if([params[i] isKindOfClass:[NSNumber class]]) {
            sqlite3_bind_int(stmt, i+1, [params[i] intValue]);
        }
    }
    // 执行句柄
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        MyLog(@"删除失败");
        // 关闭句柄
        sqlite3_finalize(stmt);
        // 关闭数据库
        sqlite3_close(sqlite);
        return NO;
    }
    // 关闭句柄
    sqlite3_finalize(stmt);
    // 关闭数据库
    sqlite3_close(sqlite);
    
    return YES;
}

// 删除数据(可变参数)
+ (BOOL)deleteTableWithSqlString:(NSString *)sql
                      andObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    // 初始化一个可变数组用来存放参数
    NSMutableArray *params = [NSMutableArray array];
    // 创建一个指针指向一个指针列表
    va_list firstList;
    // 将指针的初始位置指向第一个指针列表的第一个指针
    va_start(firstList, firstObj);
    // 如果参数大于一个
    if(firstObj)
    {
        [params addObject:firstObj];
        // 让指针指向指针列表的下一个指针
        id arg; // 存放下一个指针
        while((arg= va_arg(firstList, id)))
        {
            [params addObject:arg];
        }
        // 置空指针
        va_end(firstList);
    }
    
    // 初始化一个数据库
    sqlite3 *sqlite = nil;
    // 数据库路径
    NSString *path = DB_SQLITE_PATH;
    // 打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        MyLog(@"数据库打开失败");
        return NO;
    }
    // 创建一个句柄
    sqlite3_stmt *stmt = nil;
    // 编译sql语句
    result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        MyLog(@"编译失败");
        return NO;
    }
    // 绑定数据
    for (int i = 0;i < params.count;i++) {
        // 如果数据是字符串
        if([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i+1, [params[i] UTF8String], -1, NULL);
        }
        // 如果数据是整数
        if([params[i] isKindOfClass:[NSNumber class]]) {
            sqlite3_bind_int(stmt, i+1, [params[i] intValue]);
        }
    }
    // 执行句柄
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        MyLog(@"删除失败");
        // 关闭句柄
        sqlite3_finalize(stmt);
        // 关闭数据库
        sqlite3_close(sqlite);
        return NO;
    }
    // 关闭句柄
    sqlite3_finalize(stmt);
    // 关闭数据库
    sqlite3_close(sqlite);
    
    return YES;
}


@end
