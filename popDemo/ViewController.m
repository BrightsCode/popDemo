//
//  ViewController.m
//  popDemo
//
//  Created by zhangchao on 15/4/23.
//  Copyright (c) 2015年 zhangchao. All rights reserved.
//

#import "ViewController.h"
#import <POP.h>
@interface ViewController ()
@property (nonatomic, strong) UIButton *btnDelay;
@property (nonatomic, strong) UITableView *viewPop;
@property (nonatomic, assign) BOOL isOpened;
@end

@implementation ViewController
@synthesize btnDelay;
@synthesize isOpened;
@synthesize viewPop;

- (void)viewDidLoad {
    [super viewDidLoad];
    btnDelay = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 50, 50, 50)];
    btnDelay.backgroundColor = [UIColor greenColor];
    btnDelay.layer.cornerRadius = 50;
    btnDelay.center = self.view.center;
    btnDelay.layer.masksToBounds = YES;
    [self.view addSubview:btnDelay];
    
    //弹簧动画
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    springAnimation.springSpeed = 2;
    springAnimation.springBounciness = 15;
    springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 300, 300)];
    [btnDelay pop_addAnimation:springAnimation forKey:nil];
    
    [btnDelay addTarget:self action:@selector(showPop) forControlEvents:UIControlEventTouchUpInside];
    
    //拖动手势
    //UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureMethod:)];
    //[btnDelay addGestureRecognizer:panGesture];
    
    viewPop = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    viewPop.backgroundColor = [UIColor yellowColor];
    viewPop.center = self.view.center;
    [self.view addSubview:viewPop];
}
#pragma mark - pop弹簧动画
- (void)showPop{
    
    if (isOpened) {
        [self hidePop];
        return;
    }
    isOpened = YES;
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    positionAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0,0, 0, 0)];
    positionAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0,0, 100, 100)];
    viewPop.center = self.view.center;
    positionAnimation.springBounciness = 15.0f;
    positionAnimation.springSpeed = 20.0f;
    [viewPop pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
}

- (void)hidePop{
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    positionAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)];
    positionAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)];
    //key一样就会用后面的动画覆盖之前的
    [viewPop pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
    
    isOpened = NO;
}

#pragma mark - pop衰减动画
-(void)panGestureMethod:(UIPanGestureRecognizer *)gesture
{
    CGPoint translate = [gesture translationInView:self.view];
    NSLog(@"translate.x = %f,%f",translate.x,translate.y);
    gesture.view.center = CGPointMake(translate.x + gesture.view.center.x, translate.y + gesture.view.center.y);
    NSLog(@"gesture.x = %f,%f",gesture.view.center.x,gesture.view.center.y);
    
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [gesture velocityInView:self.view];
        
        POPDecayAnimation *decayAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [gesture.view pop_addAnimation:decayAnimation forKey:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
