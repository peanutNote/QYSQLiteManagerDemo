## QYSQLiteManager
* The easiest way to use SQLite
* 使用简单的SQLite操作第三方

## 如何使用QYSQLiteManager
* Bulid Phases 导入所需的静态库文件*libsqlite3.0.dylib*
* 将QYSQLiteManager文件add到项目中，并在需要对SQLite进行操作的类中添加`#import "QYSQLiteManager"`


## 具体用法
```objc
// 插入语句
- (void)insertTable
{
    // 创建sql语句
    NSString *sql = @"insert into teacher(name,id) values(?,?)";
    // 不可变参数
//    BOOL isOK = [QYSQLiteManager insertTableWithSqlString:sql andArray:@[@"小明",@115]];
    // 可变参数
    BOOL isOK = [QYSQLiteManager insertTableWithSqlString:sql andObjects:@"小明",@"115", nil];
    if (isOK) {
        NSLog(@"数据插入成功");
    } else {
        NSLog(@"数据插入失败");
    }
}
// 查询语句
- (void)selectTable
{
    NSString *sql = @"select * from teacher";
    [QYSQLiteManager selectTableWithSqlString:sql didFinishedBlock:^(NSArray *dataList, NSString *error) {
        NSLog(@"%@",dataList);
    } andObjects:nil];
}

// 修改表语句
- (void)alterTable
{
    NSString *sql = @"alter table teacher add column pwd integer";
    if([QYSQLiteManager alterTableWithSqlString:sql])
    {
        NSLog(@"修改成功");
    }
}

// 更新数据语句
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
```
  
