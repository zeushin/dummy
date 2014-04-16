//
//  DIVMainViewController.m
//  DemoImageViewer
//
//  Created by masher on 4/16/14.
//  Copyright (c) 2014 masher. All rights reserved.
//

#import "DIVMainViewController.h"

#define TAG_OF_IMAGE_VIEW 999

@interface DIVMainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UITabBar *tabBar;
@property UIView *tappedView;
@property IBOutlet UIImageView *headerView;
@property IBOutlet UIView *guideView;

@end

@implementation DIVMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height - 1, _headerView.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:216.0f / 255.0f green:216.0f / 255.0f blue:216.0f / 255.0f alpha:1.0f]];
    [_headerView addSubview:line];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTappedMain:)];
    tapRecognizer.numberOfTapsRequired = 2;
    tapRecognizer.numberOfTouchesRequired = 1;
    [_headerView addGestureRecognizer:tapRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTappedMain:)];
    tapRecognizer.numberOfTapsRequired = 2;
    tapRecognizer.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:tapRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTappedMain:)];
    tapRecognizer.numberOfTapsRequired = 2;
    tapRecognizer.numberOfTouchesRequired = 1;
    [_tabBar addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *guideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapped:)];
    [_guideView addGestureRecognizer:guideTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - Action
- (void)didDoubleTappedMain:(UITapGestureRecognizer *)tap
{
    self.tappedView = tap.view;
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)didTapped:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.5 animations:^{
        [_guideView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [_guideView removeFromSuperview];
    }];
}


- (void)removeSubImageViews:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if (v.tag == TAG_OF_IMAGE_VIEW) {
            [v removeFromSuperview];
        }
    }
}


#pragma mark - image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setTag:TAG_OF_IMAGE_VIEW];

    CGFloat height = 0;
    if ([_tappedView isKindOfClass:[UIImageView class]]) {
        [self removeSubImageViews:_headerView];
        height = image.size.width * _headerView.frame.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, 0, _headerView.frame.size.width, _headerView.frame.size.height)];
        [_headerView addSubview:imageView];
    } else if ([_tappedView isKindOfClass:[UIScrollView class]]) {
        [self removeSubImageViews:_scrollView];
        height = image.size.height * _scrollView.frame.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, 0, _scrollView.frame.size.width, height)];
        [_scrollView addSubview:imageView];
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, height)];
    } else if ([_tappedView isKindOfClass:[UITabBar class]]) {
        [self removeSubImageViews:_tappedView];
        height = image.size.width * _tabBar.frame.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, 0, _tabBar.frame.size.width, _tabBar.frame.size.height)];
        [_tabBar addSubview:imageView];
    }
}


@end
