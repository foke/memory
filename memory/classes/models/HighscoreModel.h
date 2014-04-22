//
//  HighscoreModel.h
//  memory
//
//  Created by K on 30/11/13.
//
//

#import <Foundation/Foundation.h>

@interface HighscoreModel : NSObject

-(NSArray *) getHighscore;
-(void) saveScoreWithPoints: (NSInteger)points andName: (NSString *)name;
-(BOOL) didReachHighscore: (NSInteger)points;

@end
