//
//  HNHHEQVisualizer.m
//  HNHH
//
//  Created by Dobango on 9/17/13.
//  Copyright (c) 2013 RC. All rights reserved.
//

#import "PCSEQVisualizer.h"
#import "UIImage+Color.h"


//#define kWidth 8
//#define kHeight 25
#define kPadding 1
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface PCSEQVisualizer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *barArray;
@property (nonatomic, assign) NSInteger numberOfBars;
@property(nonatomic,assign) NSInteger kWidth;
@property(nonatomic,assign) NSInteger kHeight;

@end

@implementation PCSEQVisualizer

- (id)initWithNumberOfBars:(int)numberOfBars {
    self = [super init];
    if (self) {
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            _kWidth = 3;
            _kHeight = 15;
        }
        else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            _kWidth = 8;
            _kHeight = 25;
        }
        
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            self.frame = CGRectMake(0, 0, kPadding*numberOfBars+(_kWidth*numberOfBars), _kHeight);
        }
        
        else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            CGFloat WidthIcon = ScreenWidth * 0.05;
            CGFloat HeightIcon = ScreenWidth * 0.05;
            CGFloat leftIcon = ScreenWidth * 0.92;
            CGFloat h1 =  [UIApplication sharedApplication].statusBarFrame.size.height + 44 + ScreenHeight * 0.03;
            CGFloat topIcon = h1/2 - HeightIcon/2 + [UIApplication sharedApplication].statusBarFrame.size.height/2;
            self.frame = CGRectMake(0, 0, WidthIcon, HeightIcon);
        }
        

        self.numberOfBars = numberOfBars;
        //self.frame = CGRectMake(0, 0, kPadding*numberOfBars+(kWidth*numberOfBars), kHeight);
        //self.backgroundColor = [UIColor redColor];
        
        //self.frame = CGRectMake(leftIcon, topIcon, WidthIcon, HeightIcon);
        
        NSMutableArray* tempBarArray = [[NSMutableArray alloc]initWithCapacity:numberOfBars];
        for(int i=0;i<numberOfBars;i++) {
            UIImageView* bar = [[UIImageView alloc]initWithFrame:CGRectMake(i*_kWidth+i*kPadding, 0, _kWidth, 1)];
            //UIImageView* bar = [[UIImageView alloc]initWithFrame:CGRectMake(leftIcon, topIcon, WidthIcon, HeightIcon)];
            
            bar.image = [UIImage imageWithColor:self.barColor];
            [self addSubview:bar];
            [tempBarArray addObject:bar];
        }
        self.barArray = [[NSArray alloc]initWithArray:tempBarArray];
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2*2);
        self.transform = transform;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"stopTimer" object:nil];
    }
    return self;
}

- (void)start {
    self.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.35 target:self selector:@selector(ticker) userInfo:nil repeats:YES];
}

- (void)stop{
    self.hidden = YES;
    
}



- (void)ticker {
    [UIView animateWithDuration:.35 animations:^{
        for(UIImageView* bar in self.barArray) {
            CGRect rect = bar.frame;
            rect.size.height = arc4random() % _kHeight + 1;
            bar.frame = rect;
        }
    }];
    
}

@end
