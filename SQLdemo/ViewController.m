//
//  ViewController.m
//  SQLdemo
//
//  Created by yangqin on 13-10-21.
//  Copyright (c) 2013年 yangqin. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

-(void)dealloc
{
    [_myClassDAO release];
    [_nameTextField release];
    [_numTextField release];
    [_resultTextView release];
    [_idTextField release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.myClassDAO =[[[ClassDAO alloc]init]autorelease];
    [self.myClassDAO initDB];
    [self.myClassDAO initTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addButtonPress:(id)sender
{
    ClassInformation *newClass=[[ClassInformation alloc]init];
    newClass.classID=[self.idTextField.text integerValue];
    newClass.className=self.nameTextField.text;
    newClass.classNum=[self.numTextField.text integerValue];
    [self.myClassDAO addClass:newClass];
}
-(IBAction)scanButtonPress:(id)sender
{
    NSMutableArray *allData=[self.myClassDAO findAll];
    //显示信息的字符串
    NSMutableString *resultStr=[NSMutableString stringWithCapacity:10];
    [resultStr appendString:@"-----班级信息-----"];
    for (int i=0; i<allData.count; i++)
    {
        NSMutableDictionary *calssData=[allData objectAtIndex:i];
        [resultStr appendFormat:@"\nID=%@\nName=%@\nNum=%@\n",[calssData objectForKey:@"ID"],[calssData objectForKey:@"NAME"],[calssData objectForKey:@"NUM"] ];
        [resultStr appendString:@"--------------"];
        
    }
    self.resultTextView.text=resultStr;
    
}
-(IBAction)deleteButtonPress:(id)sender
{
    [self.myClassDAO deleteClassByID:[self.idTextField.text integerValue]];
}
-(IBAction)updateButtonPress:(id)sender
{
    [self.myClassDAO updateClassName:self.nameTextField.text andNum:[self.numTextField.text integerValue] byID:[self.idTextField.text integerValue]];
}
-(IBAction)searchButtonPress:(id)sender
{
    NSMutableArray *allData=[self.myClassDAO findClassByName:self.nameTextField.text];
    //显示信息的字符串
    NSMutableString *resultStr=[NSMutableString stringWithCapacity:10];
    [resultStr appendString:@"-----查询结果-----"];
    for (int i=0; i<allData.count; i++)
    {
        NSMutableDictionary *calssData=[allData objectAtIndex:i];
        [resultStr appendFormat:@"\nID=%@\nName=%@\nNum=%@\n",[calssData objectForKey:@"ID"],[calssData objectForKey:@"NAME"],[calssData objectForKey:@"NUM"] ];
        
    }
    self.resultTextView.text=resultStr;
    

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)hideKetBoard:(id)sender
{
    [self.idTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.numTextField resignFirstResponder];
    [self.resultTextView resignFirstResponder];
   
}


@end
