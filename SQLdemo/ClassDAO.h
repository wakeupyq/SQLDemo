//
//  ClassDAO.h
//  SQLdemo
//
//  Created by yangqin on 13-10-21.
//  Copyright (c) 2013年 yangqin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ClassInformation.h"

@interface ClassDAO : NSObject

{
    sqlite3 *sqliteDB;
    
}
@property(nonatomic,assign)sqlite3 *sqliteDB;

//初始化数据库,打开数据库，有则打开，无就创建
-(BOOL)initDB;

//创建数据表
-(BOOL)initTable;

 //增加新班级信息
-(BOOL)addClass:(ClassInformation*)newClass;
//更新班级信息
-(BOOL)updateClassName:(NSString *)_name andNum:(NSUInteger)_num byID:(NSUInteger) _id;

//游览全部信息
-(NSMutableArray *)findAll;

//查找
-(NSMutableArray *)findClassByName:(NSString *)_name;

//删除
-(void)deleteClassByID:(NSUInteger) _id;

//关闭数据库
-(void)closeDB;
@end
