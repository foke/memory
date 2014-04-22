//
//  HighscoreModel.m
//  memory
//
//  Created by K on 30/11/13.
//  
//

#import "HighscoreModel.h"

#define MAX_ENTRIES 10

@interface HighscoreModel ()

@property (nonatomic) NSMutableArray *highscore;

@end

@implementation HighscoreModel

-(id) init {
    self = [super init];
    
    if (self) {
        self.highscore = [self sortArrayByPoints:[self retrieveHighscore] andAscending:NO];
    }
    
    return self;
}

-(NSArray *) getHighscore {
    return [self sortArrayByPoints:self.highscore andAscending:NO];
}

-(void) saveScoreWithPoints:(NSInteger)points andName:(NSString *)name {
    if ([self didReachHighscore:points]) {
        [self.highscore addObject:@{ @"points" : [NSNumber numberWithInteger:points], @"name" : name}];
        [self writeHighscore];
    }
}

-(NSMutableArray *) retrieveHighscore {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [defaults objectForKey:@"highscore"];
    
    return array;
}

/*
 * writeHighscore stores the MAX_ENTRIES highest scores
 */
-(void) writeHighscore {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *sortedScores = [self sortArrayByPoints: self.highscore andAscending: NO];
    
    if ([sortedScores count] > MAX_ENTRIES) {
        sortedScores = [sortedScores subarrayWithRange:NSMakeRange(0, MAX_ENTRIES)];
    }
    
    [defaults setObject:sortedScores forKey:@"highscore"];
}

-(BOOL) didReachHighscore:  (NSInteger)points {
    if ([self.highscore count] >= MAX_ENTRIES) {
        self.highscore = [self sortArrayByPoints: self.highscore andAscending: YES];
        NSInteger lowestPoints = [[[self.highscore objectAtIndex: 0] objectForKey: @"points"] integerValue];
        
        if (points <= lowestPoints) {
            return NO;
        }
    }
    
    return YES;
}

-(NSMutableArray *) sortArrayByPoints: (NSMutableArray *)array andAscending:(BOOL)ascending {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"points" ascending: ascending];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors: [NSMutableArray arrayWithObjects: descriptor,nil]];
    
    return [NSMutableArray arrayWithArray: sortedArray];
}

@end
