//
//  ZCScrollImageDemoController.m
//  SouFun
//
//  Created by ShiPanpan on 2018/1/29.
//

#import "ZCScrollImageDemoController.h"
#import "AsyncImageView.h"

#define imageWide 320
#define imageHeight 320 * 0.618
#define leftImageViewTag 100
#define currentImageViewTag 200
#define rightImageViewTag 300


@interface ZCScrollImageDemoController ()

@end

@implementation ZCScrollImageDemoController

static NSArray *imageUrlArray;
static UIScrollView *scrollView;
static NSInteger currentPage = 0;


//static NSArray *imageArray = @[@1, @2, @3];

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self initUI];
}

- (void)initData {
    imageUrlArray = @[@"http://sfbagent-10022965.image.myqcloud.com/1/2018_1/29/M15/22/b9da1558d2f34696b100363a4a212df1.jpg", @"http://sfbagent-10022965.image.myqcloud.com/1/2018_1/29/M15/22/80323aaee09e418296b34fab2ce1788c.jpg", @"http://sfbagent-10022965.image.myqcloud.com/1/2018_1/29/M15/22/ae99170caae243f2a1c5c037991507b9.jpg", @"http://sfbagent-10022965.image.myqcloud.com/1/2018_1/29/M15/22/d5215c9157634402b2151cb267770164.jpg"];
}

- (void)initUI {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, imageWide, imageHeight)];
    scrollView.contentSize = CGSizeMake(imageWide * 3, imageHeight);
    scrollView.contentOffset = CGPointMake(imageWide, 0);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    [self addAsyImageWithRect:CGRectMake(0, 0, imageWide, imageHeight) andURLString:imageUrlArray[2] tag:leftImageViewTag];
    [self addAsyImageWithRect:CGRectMake(imageWide, 0, imageWide, imageHeight) andURLString:imageUrlArray[0] tag:currentImageViewTag];
    [self addAsyImageWithRect:CGRectMake(2 * imageWide, 0, imageWide, imageHeight) andURLString:imageUrlArray[1] tag:rightImageViewTag];
}

//异步图片加载函数 zc
- (void)addAsyImageWithRect:(CGRect)rect andURLString:(NSString *)imageURLString tag:(NSInteger)tag
{
    if ([scrollView viewWithTag:tag]) {
        AsyncImageView *asyncImage = [scrollView viewWithTag:tag];
        [asyncImage loadImageFromURLString:imageURLString];//图片的URL
    } else {
        AsyncImageView *asyncImage = [[AsyncImageView alloc] initWithFrame:rect];
        asyncImage.tag = tag;
        [asyncImage setUserInteractionEnabled:YES];
        asyncImage.imageView.contentMode = UIViewContentModeScaleToFill;
        [asyncImage setDefaultImageNameString:@"loading_list.png"];//默认图片
        [asyncImage setFailLoadImageNameString:@"loading_list.png"];//加载失败的图片
        [asyncImage loadImageFromURLString:imageURLString];//图片的URL
        [scrollView addSubview:asyncImage];//加到你想用的地方
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x != imageWide) {
        if (scrollView.contentOffset.x == 2 * imageWide) {
            currentPage++;
        }
        
        if (scrollView.contentOffset.x == 0) {
            currentPage--;
        }
        
        scrollView.contentOffset = CGPointMake(imageWide, 0);
        
        if (currentPage == -1) {
            currentPage = imageUrlArray.count - 1;
        }
        
        if (currentPage == imageUrlArray.count) {
            currentPage = 0;
        }
        
        if (currentPage == 0) {
            [self addAsyImageWithRect:CGRectMake(0, 0, imageWide, imageHeight) andURLString:[imageUrlArray lastObject] tag:leftImageViewTag];
        } else {
            [self addAsyImageWithRect:CGRectMake(0, 0, imageWide, imageHeight) andURLString:imageUrlArray[currentPage - 1] tag:leftImageViewTag];
        }
        
        [self addAsyImageWithRect:CGRectMake(imageWide, 0, imageWide, imageHeight) andURLString:imageUrlArray[currentPage] tag:currentImageViewTag];
        
        if (currentPage == imageUrlArray.count - 1) {
            [self addAsyImageWithRect:CGRectMake(2 * imageWide, 0, imageWide, imageHeight) andURLString:[imageUrlArray firstObject] tag:rightImageViewTag];
        } else {
            [self addAsyImageWithRect:CGRectMake(2 * imageWide, 0, imageWide, imageHeight) andURLString:imageUrlArray[currentPage + 1] tag:rightImageViewTag];
            
        }
    } else {
        
    }
    
    SL_Log(@"currentPage = %i", currentPage);
}

@end
