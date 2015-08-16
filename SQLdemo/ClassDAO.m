//
//  ClassDAO.m
//  SQLdemo
//
//  Created by yangqin on 13-10-21.
//  Copyright (c) 2013年 yangqin. All rights reserved.
//

#import "ClassDAO.h"

@implementation ClassDAO

@synthesize sqliteDB;
//初始化数据库,打开数据库，有则打开，无就创建
-(BOOL)initDB
{
    //获取沙盒路径
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取document路径
    NSString *documentPath=[paths objectAtIndex:0];
    //设置db路径
    NSString *dbpath=[documentPath stringByAppendingPathComponent:@"mydata.db"];

    if ( sqlite3_open([dbpath UTF8String], &sqliteDB)!=SQLITE_OK)
    {
        NSLog(@"Error1:打开数据库失败！！！");
        sqlite3_close(sqliteDB);
        return NO;
    }
    NSLog(@"打开数据库成功！！！！！");
    NSLog(@"dbpath=%@",dbpath);
    return YES;
    
}

//创建数据表
-(BOOL)initTable
{
    //创建Sql数据表的语句
    char *sql="CREATE TABLE member (id integer primary key autoincrement,classID integer,className text,classNum integer)";
    sqlite3_stmt *statement;//存储sql语句的结构指针

    //编译字节代码并做容错处理
    if (sqlite3_prepare_v2(sqliteDB, sql, -1, &statement, nil)==SQLITE_ERROR)
    {
        NSLog(@"Error2:initTable prepare");
        return NO;
    }
    //开始执行语句
    int success = sqlite3_step(statement);
    if (success != SQLITE_DONE)
    {
        NSLog(@"Error3:initTable step");
        //关闭statement，释放资源
        sqlite3_finalize(statement);
        return NO;
    }
    //关闭statement，释放资源
    sqlite3_finalize(statement);
    NSLog(@"创建数据表成功！");  
    return YES;
    
}

//增加新班级信息
-(BOOL)addClass:(ClassInformation*)newClass
{
    //添加内容的sql语句
    char *sql = "INSERT INTO member (classID,className,classNum)VALUES(?,?,?)";
    //结构体指针
    sqlite3_stmt *statement;
    //编码
    if (sqlite3_prepare_v2(sqliteDB, sql, -1, &statement, nil)!=SQLITE_OK)
    {
        NSLog(@"Error4:addClass prepare");
        return NO;
    }
    
    //用相应对象取代sql语句中的问号，其中第二个参数代表第几个问好
    
    sqlite3_bind_int(statement, 1, newClass.classID);
    sqlite3_bind_text(statement, 2, [newClass.className UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 3, newClass.classNum);
    
    //执行
    sqlite3_step(statement);
    //关闭资源
    sqlite3_finalize(statement);
    return YES;
}
//更新班级信息
-(BOOL)updateClassName:(NSString *)_name andNum:(NSUInteger)_num byID:(NSUInteger) _id
{
    //创建更新的sql语句
    char *sql="update member set className=?,classNum=? where classID=?";
    //创建结构体
    sqlite3_stmt *statement;
    //编码
    if (sqlite3_prepare_v2(sqliteDB, sql, -1, &statement, nil)==SQLITE_ERROR)
    {
        NSLog(@"Error5:updateClass prepare");
        sqlite3_finalize(statement);
        return NO;
    }
    //绑定
    sqlite3_bind_text(statement, 1, [_name UTF8String], -1, nil);
    sqlite3_bind_int(statement, 2, _num);
    sqlite3_bind_int(statement, 3, _id);
    //执行
    int success=sqlite3_step(statement);
    if (success!=SQLITE_DONE)
    {
        NSLog(@"Error6:updateClass step");
        sqlite3_finalize(statement);
        return NO;
    }
    NSLog(@"更新成功");
    sqlite3_finalize(statement);
    return YES;
    
}

//游览全部信息
-(NSMutableArray *)findAll
{
    //创建浏览全部信息的sql语句
    char *sql="select * from member order by classID";
    //创建结构体
    sqlite3_stmt *statement;
    //编码
    if (sqlite3_prepare_v2(sqliteDB, sql, -1, &statement, nil)==SQLITE_ERROR)
    {
        NSLog(@"Error5:findAll prepare");
        sqlite3_finalize(statement);
        return nil;
    }
    //存储所有数据的数组
    NSMutableArray *allData=[[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    
       //执行sql语句并从每行获取数据
    while (sqlite3_step(statement)==SQLITE_ROW)
    {
        //存储每行数据的字典
        NSMutableDictionary *rowDict=[[NSMutableDictionary alloc]initWithCapacity:10];
        //获取每行中列的信息
        int c_classID=sqlite3_column_int(statement, 1);
        [rowDict setObject:[NSString stringWithFormat:@"%d",c_classID] forKey:@"ID"];
        //获取行中的name信息
        char *c_name=(char*)sqlite3_column_text(statement, 2);
        [rowDict setObject:[NSString stringWithCString:c_name encoding:NSUTF8StringEncoding] forKey:@"NAME"];
        //获取行中num的信息

        int c_classNum=sqlite3_column_int(statement, 3);
        [rowDict setObject:[NSString stringWithFormat:@"%d",c_classNum] forKey:@"NUM"];
        //加到整体数据中
        [allData addObject:rowDict];
        [rowDict release];
        
    }
    //关闭
    sqlite3_finalize(statement);
    return allData;
    

    
}

//查找
-(NSMutableArray *)findClassByName:(NSString *)_name
{
    //创建查找的sql语句
    char *sql="select * from member where className=?";
    //结构体
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqliteDB, sql, -1, &statement, nil)==SQLITE_ERROR)
    {
        NSLog(@"Errror:findClassByname prepare");
        sqlite3_finalize(statement);
        return nil;
    }
    //绑定
    sqlite3_bind_text(statement, 1, [_name UTF8String],-1, SQLITE_TRANSIENT);
    //存储查找到的信息数组
    NSMutableArray *findData=[NSMutableArray arrayWithCapacity:10];
    
    //执行sql语句并从每行获取数据
    while (sqlite3_step(statement)==SQLITE_ROW)
    {
        //存储每行数据的字典
        NSMutableDictionary *rowDict=[[NSMutableDictionary alloc]initWithCapacity:10];
        //获取每行中id的信息
        int c_classID=sqlite3_column_int(statement, 1);
        [rowDict setObject:[NSString stringWithFormat:@"%d",c_classID] forKey:@"ID"];
        //获取行中的name信息
        char *c_name=(char*)sqlite3_column_text(statement, 2);
        [rowDict setObject:[NSString stringWithCString:c_name encoding:NSUTF8StringEncoding] forKey:@"NAME"];
        //获取行中num的信息
        
        int c_classNum=sqlite3_column_int(statement, 3);
        [rowDict setObject:[NSString stringWithFormat:@"%d",c_classNum] forKey:@"NUM"];
        //加到整体数据中
        [findData addObject:rowDict];
        [rowDict release];
        
    }
    //关闭
    sqlite3_finalize(statement);
    return findData;
    

    
    
}

//删除
-(void)deleteClassByID:(NSUInteger) _id
{
    
    //创建删除的sql语句
    char *sql="delete from member where classID=?";
    //结构体
    sqlite3_stmt *statement;
    //编码
    sqlite3_prepare_v2(sqliteDB, sql, -1, &statement, nil);
    //绑定
    sqlite3_bind_int(statement, 1, _id);
    //执行
    sqlite3_step(statement);
    //关闭
    sqlite3_finalize(statement);
}

//关闭数据库
-(void)closeDB
{
    if (sqliteDB)
    {
        sqlite3_close(sqliteDB);
    }
}
@end
