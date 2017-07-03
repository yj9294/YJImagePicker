//
//  ViewController.m
//  YJImagePicker
//
//  Created by cptech on 2017/6/30.
//  Copyright © 2017年 cptech. All rights reserved.
//

#import "ViewController.h"
#import "ImagePicker.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectImagePicker:(id)sender {
    
    //初始化
    ImagePicker *imgpicker = [[ImagePicker alloc] init];
    
    //图片数组可以是imagearr也可以是url的arr
    imgpicker.imgArr = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"], nil];
    
    //图片选择器的回调block返回操作后的图片数组
    imgpicker.block = ^(NSMutableArray *imageArray) {
        NSLog(@"返回的图片数组%@",imageArray);
    };
    
    //模态出viewcontroller
    [self presentViewController:imgpicker animated:YES completion:nil];
}

@end
