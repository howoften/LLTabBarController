//
//  ViewController.m
//  LLTabbarController
//
//  Created by 刘江 on 2019/12/6.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageview.image = [UIImage imageNamed:@"tab_home01"];
    [self.btn setImage:[UIImage imageNamed:@"tab_home01"] forState:UIControlStateNormal];
    
}

- (IBAction)action:(id)sender {
    [self.tabBarController setSelectedIndex:1];
    NSLog(@"%@", self.tabBarController.selectedViewController);
}

@end
