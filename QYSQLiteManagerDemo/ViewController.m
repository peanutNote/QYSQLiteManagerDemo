//
//  ViewController.m
//  QYSQLiteManagerDemo
//
//  Created by qianye on 15/6/18.
//  Copyright (c) 2015年 qianye. All rights reserved.
//

#import "ViewController.h"
#import "QYSQLiteManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [super viewDidLoad];
    
    // 创建表
    [self createTable];
    // 插入语句
//    [self insertTable];
    // 查询语句
//    [self selectTable];
    // 更新数据
//    [self updateTable];
    // 查询
//    [self selectTable];
    
    // 删除表数据
    [self deleteTableDate];
}


// 创建表
- (void)createTable
{
    NSString *sql = @"CREATE TABLE teacher(name text,id integer)";
    BOOL isOK = [QYSQLiteManager createTableWithSqlString:sql];
    if (isOK) {
        NSLog(@"数据库创建成功");
    } else {
        NSLog(@"数据库创建失败");
    }
}

// 插入
- (void)insertTable
{
    // 创建sql语句
    NSString *sql = @"insert into teacher(name,id) values(?,?)";
    // 不可变参数
//    BOOL isOK = [QYSQLiteManager insertTableWithSqlString:sql andArray:@[@"小明",@115]];
    // 可变参数
    BOOL isOK = [QYSQLiteManager insertTableWithSqlString:sql andObjects:@"小明",@115, nil];
    if (isOK) {
        NSLog(@"数据插入成功");
    } else {
        NSLog(@"数据插入失败");
    }
}
// 查询
- (void)selectTable
{
    NSString *sql = @"select * from teacher";
    [QYSQLiteManager selectTableWithSqlString:sql didFinishedBlock:^(NSArray *dataList, NSString *error) {
        NSLog(@"%@",dataList);
    } andObjects:nil];
}

// 修改表
- (void)alterTable
{
    NSString *sql = @"alter table teacher add column pwd integer";
    if([QYSQLiteManager alterTableWithSqlString:sql])
    {
        NSLog(@"修改成功");
    }
}

// 更新数据
- (void)updateTable
{
    NSString *sql = @"update teacher set name = ? where id = ?";
    if ([QYSQLiteManager updateTableWithSqlString:sql andArray:@[@"小明",@115]]) {
        NSLog(@"更新成功");
    }
}


// 删除表数据
-  (void)deleteTableDate
{
    NSString *sql = @"delete from teacher where name = ?";
    if ([QYSQLiteManager deleteTableWithSqlString:sql andArray:@[@"小明"]]) {
        NSLog(@"删除成功");
    }else {
        NSLog(@"删除失败");
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
