//
//  CardModel.h
//  memory
//
//  Created by K on 21/11/13.
//  
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject

@property (nonatomic) NSInteger value;
@property (nonatomic) BOOL outOfPlay;

-(id) initWithValue:(NSInteger)value;

@end
