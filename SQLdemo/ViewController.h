//
//  ViewController.h
//  SQLdemo
//
//  Created by yangqin on 13-10-21.
//  Copyright (c) 2013年 yangqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassInformation.h"
#import "ClassDAO.h"

@interface ViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain)ClassDAO *myClassDAO;
@property(nonatomic,retain)IBOutlet UITextField *idTextField;
@property(nonatomic,retain)IBOutlet UITextField *nameTextField;
@property(nonatomic,retain)IBOutlet UITextField *numTextField;
@property(nonatomic,retain)IBOutlet UITextView *resultTextView;
-(IBAction)addButtonPress:(id)sender;
-(IBAction)scanButtonPress:(id)sender;
-(IBAction)deleteButtonPress:(id)sender;
-(IBAction)updateButtonPress:(id)sender;
-(IBAction)searchButtonPress:(id)sender;
-(IBAction)hideKetBoard:(id)sender;

@end
