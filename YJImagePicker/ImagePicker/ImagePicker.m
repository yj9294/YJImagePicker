//
//  JZAlbumViewController.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/27.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "ImagePicker.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "PhotoView.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height


@interface ImagePicker ()<UIScrollViewDelegate,PhotoViewDelegate>
{
    CGFloat lastScale;
    MBProgressHUD *HUD;
    NSMutableArray *_subViewList;
}

@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation ImagePicker

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
        _subViewList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lastScale = 1.0;
    self.view.backgroundColor = [UIColor blackColor];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapView)];
//    [self.view addGestureRecognizer:tap];

    [self initScrollView];
    [self addLabels];
    [self addDeleteBtn];
    [self setPicCurrentIndex:self.currentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initScrollView{
//    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count*screen_width, screen_height);
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    //设置放大缩小的最大，最小倍数
//    self.scrollView.minimumZoomScale = 1;
//    self.scrollView.maximumZoomScale = 2;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.imgArr.count; i++) {
        [_subViewList addObject:[NSNull class]];
    }

}
//删除按钮
- (void)addDeleteBtn
{
    self.deleteBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(screen_width-50, 20, 45, 48);
//    self.deleteBtn.backgroundColor = [UIColor whiteColor];
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"img_del"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteBtn ];
}
//新增图片后
-(void)addLabels{
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, screen_height-64-49, 60, 30)];
    self.sliderLabel.backgroundColor = [UIColor clearColor];
    self.sliderLabel.textColor = [UIColor whiteColor];
    self.sliderLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.imgArr.count];
    [self.view addSubview:self.sliderLabel];
}
//删除后
- (void)addLabel2
{
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, screen_height-64-49, 60, 30)];
    self.sliderLabel.backgroundColor = [UIColor clearColor];
    self.sliderLabel.textColor = [UIColor whiteColor];
    if(self.currentIndex==0)
    {
        self.currentIndex = 1;
    }
    self.sliderLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex,(unsigned long)self.imgArr.count];
    [self.view addSubview:self.sliderLabel];

}
-(void)setPicCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.scrollView.contentOffset = CGPointMake(screen_width*currentIndex, 0);
    [self loadPhote:_currentIndex];
//    [self loadPhote:_currentIndex+1];
//    [self loadPhote:_currentIndex-1];
}
- (void)deleteImg:(UIButton *)btn
{
    self.flag = @"YES";
    [self.scrollView removeFromSuperview];
    [self.sliderLabel removeFromSuperview];
    [self.deleteBtn removeFromSuperview];
    CGFloat currentX = self.scrollView.contentOffset.x;
    int  index = (int)currentX/screen_width ;
    [self.imgArr removeObjectAtIndex:index];
    if(self.imgArr.count==0)
    {
        //调用block传回删除了图片的数组
        self.block(self.imgArr);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self initScrollView];
    [self addLabel2];
    [self addDeleteBtn];
    [self setPicCurrentIndex:(index-1==-1)?0:index-1];
}

-(void)loadPhote:(NSInteger)index{
    if (index<0 || index >=self.imgArr.count) {
        return;
    }
    
    id currentPhotoView = [_subViewList objectAtIndex:index];
    if (![currentPhotoView isKindOfClass:[PhotoView class]]) {
        
        CGRect frame = CGRectMake(index*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        PhotoView *photoV = [[PhotoView alloc] initWithFrame:frame withPhotoImage:[self.imgArr objectAtIndex:index]];
        photoV.delegate = self;
        [self.scrollView insertSubview:photoV atIndex:0];
        [_subViewList replaceObjectAtIndex:index withObject:photoV];
    }
    else{
//        PhotoView *photoV = (PhotoView *)currentPhotoView;
        CGRect frame = CGRectMake(index*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        PhotoView *photoV = [[PhotoView alloc] initWithFrame:frame withPhotoImage:[self.imgArr objectAtIndex:index]];
        photoV.delegate = self;
        [self.scrollView insertSubview:photoV atIndex:0];
        [_subViewList replaceObjectAtIndex:index withObject:photoV];
    }
    
}

#pragma mark - PhotoViewDelegate
-(void)TapHiddenPhotoView{
    //调用block传回删除了图片的数组
    self.block(self.imgArr);
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
//-(void)OnTapView{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//手势
-(void)pinGes:(UIPinchGestureRecognizer *)sender{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (lastScale -[sender scale]);
    lastScale = [sender scale];
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count*screen_width, screen_height*lastScale);
    NSLog(@"scale:%f   lastScale:%f",scale,lastScale);
    CATransform3D newTransform = CATransform3DScale(sender.view.layer.transform, scale, scale, 1);
    
    sender.view.layer.transform = newTransform;
    if ([sender state] == UIGestureRecognizerStateEnded) {
        //
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    int i = scrollView.contentOffset.x/screen_width+1;
    [self loadPhote:i-1];
    self.sliderLabel.text = [NSString stringWithFormat:@"%d/%lu",i,(unsigned long)self.imgArr.count];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
