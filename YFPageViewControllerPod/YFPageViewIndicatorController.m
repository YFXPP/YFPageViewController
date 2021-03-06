//
//  YFPageViewIndicatorController.m
//  YFPageViewControllerVC
//
//  Created by ios_yangfei on 2018/4/21.
//  Copyright © 2018年 jianghu3. All rights reserved.
//

#import "YFPageViewIndicatorController.h"
#import "YFIndexIndicatorView.h"
#import "YFPageConst.h"

@interface YFPageViewIndicatorController ()<YFIndexIndicatorViewDelegate,UIScrollViewDelegate>
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray<YFBasePageVC *> *subVCArr;
@property(nonatomic,weak)YFIndexIndicatorView *indicatorView;
@property(nonatomic,weak)UIScrollView *contentScrollView;
@end

@implementation YFPageViewIndicatorController

#pragma mark ====== Initialize =======
-(instancetype)initWith:(NSArray *)titleArr vcArr:(NSArray<YFBasePageVC *> *)vcArr{
    if (self = [super init]) {
        self.titleArr = titleArr;
        self.subVCArr = vcArr;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    YFIndexIndicatorView *indicatorView = [[YFIndexIndicatorView alloc] initWithFrame:CGRectMake(0, 0, VC_WIDTH, indicatorViewH)];
    [self.view addSubview:indicatorView];
    indicatorView.index_arr = self.titleArr;
    indicatorView.delegate = self;
    indicatorView.scrollEnabled = _indicator_scrollEnable;
    indicatorView.showAnmation = _indicator_scrollAnimation;
    indicatorView.showIndicatorLineView = YES;
    indicatorView.indicatorLineWidth = 100;
    indicatorView.indicatorLineColor = [UIColor blackColor];
    indicatorView.indicatorLineAutoWidth = NO;
    indicatorView.scrollToIndex = 0;
    self.indicatorView = indicatorView;

    YFBasePageVC *vc = self.subVCArr.firstObject;
    [self addChildViewController:vc];
    for (NSInteger i=0; i<_subVCArr.count; i++) {
        YFBasePageVC *vc = _subVCArr[i];
        vc.index = i;
        vc.superVC = self;
    }
    
    if (self.vcTransformType == VCTransformType_Scroll) {
        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT + indicatorViewH, VC_WIDTH, VC_HEIGHT - NAVI_HEIGHT)];
        [self.view addSubview:contentScrollView];
        contentScrollView.delegate = self;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.pagingEnabled = YES;
        contentScrollView.contentSize = CGSizeMake(VC_WIDTH * self.subVCArr.count, VC_HEIGHT - NAVI_HEIGHT);
        self.contentScrollView = contentScrollView;
        
        vc.view.frame = CGRectMake(0, 0, VC_WIDTH, VC_HEIGHT - NAVI_HEIGHT);
        [self.contentScrollView addSubview:vc.view];
        
    }else{
        vc.view.frame = CGRectMake(0, STATUS_HEIGHT + 40, VC_WIDTH, VC_HEIGHT - NAVI_HEIGHT);
        [self.view addSubview:vc.view];
    }
    
}

#pragma mark ====== YFIndexIndicatorViewDelegate =======
- (void)indexIndicatorView :(YFIndexIndicatorView *)indexIndicatorView didSelectItemAtIndex:(NSInteger)index{
    
    YFBasePageVC *vc = self.subVCArr[index];
    if (![vc isViewLoaded]) {
        switch (self.vcTransformType) {
            case VCTransformType_Scroll:
            {
                vc.view.frame = CGRectMake(VC_WIDTH * index, 0, VC_WIDTH, VC_HEIGHT - NAVI_HEIGHT);
                [self.contentScrollView addSubview:vc.view];
            }
                break;
            case VCTransformType_Overlay:
                vc.view.frame = CGRectMake(0, STATUS_HEIGHT + 40, VC_WIDTH, VC_HEIGHT - NAVI_HEIGHT);
                break;
            default:
                break;
        }
        
        [self addChildViewController:vc];
        vc.view.backgroundColor = RandomColor;
        [vc viewAppearToDoThing];
    }
    
    if (self.vcTransformType == VCTransformType_Scroll) {
        [self.contentScrollView setContentOffset:CGPointMake(VC_WIDTH *index, 0) animated:YES];
    }else{
        [self.view insertSubview:vc.view atIndex:0];
        [self.view bringSubviewToFront:vc.view];
    }
    
}

#pragma mark ====== UIScrollViewDelegate =======
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/VC_WIDTH;
    self.indicatorView.scrollToIndex = index;
    YFBasePageVC *vc = self.subVCArr[index];
    if (![vc isViewLoaded]) {
        vc.view.frame = CGRectMake(VC_WIDTH * index, 0, VC_WIDTH, HEIGHT - NAVI_HEIGHT);
        [self.contentScrollView addSubview:vc.view];
        [self addChildViewController:vc];
        vc.view.backgroundColor = RandomColor;
        [vc viewAppearToDoThing];
    }
}

@end

