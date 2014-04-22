//
//  CardView.m
//  memory
//
//  Created by K on 12/11/13.
//
//

#import "CardView.h"

@interface CardView()

@property (nonatomic) UIImage *frontImage;
@property (nonatomic) UIImage *backImage;

@end

@implementation CardView

// instantiate custom view subclass programmatically
-(id) initWithFrame: (CGRect)frame andPosition: (NSInteger)pos andValue: (NSInteger)value {
    self = [super initWithFrame: frame];
    if (self) {
        self.frontImage = [UIImage imageNamed:[NSString stringWithFormat: @"card-%ld.png", (long) (value+1)]];
        self.backImage = [UIImage imageNamed:@"cardback.png"];
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.image = self.backImage;
        self.value = value;
        self.pos = pos;
    }
    return self;
}

-(void) flip {
    self.image = (self.image == self.frontImage) ? self.backImage : self.frontImage;
}

@end
