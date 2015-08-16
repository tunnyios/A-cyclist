//
//  ACAnnotationView.m
//  A-cyclist
//
//  Created by tunny on 15/8/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACAnnotationView.h"

@interface ACAnnotationView ()
/** imageView */
@property (nonatomic, strong) UIImageView *annotationImageView;

@end

@implementation ACAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, 32.f, 32.f)];
        
//        [self setBackgroundColor:[UIColor clearColor]];
        
        _annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _annotationImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_annotationImageView];
    }
    return self;
}

- (void)setBMKimage:(UIImage *)BMKimage
{
    _BMKimage = BMKimage;
    
    self.annotationImageView.image = BMKimage;
}

@end
