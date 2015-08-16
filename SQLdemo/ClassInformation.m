//
//  ClassInformation.m
//  SQLdemo
//
//  Created by yangqin on 13-10-21.
//  Copyright (c) 2013年 yangqin. All rights reserved.
//

#import "ClassInformation.h"

@implementation ClassInformation

@synthesize classID=_classID;
@synthesize className=_className;
@synthesize classNum=_classNum;
-(void)dealloc
{
    [_className release];
    [super dealloc];
}
@end
