//
//  CardModel.m
//  memory
//
//  Created by K on 21/11/13.
//  
//

#import "CardModel.h"

@implementation CardModel

-(id) initWithValue:(NSInteger)value {
    self = [super init];
    
    if (self) {
        self.value = value;
        self.outOfPlay = NO;
    }
    
    return self;
}

@end
