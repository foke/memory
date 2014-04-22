//
//  GameModel.h
//  memory
//
//  Created by K on 21/11/13.
//  
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

@property (nonatomic) NSMutableArray *cards;
@property (nonatomic) NSMutableArray *turnedCards;
@property (nonatomic) BOOL isMultiplayer;
@property (nonatomic) BOOL isFirstPlayersTurn;
@property (nonatomic) NSInteger player1Score;
@property (nonatomic) NSInteger player2Score;

-(id) initWithPlayers: (NSInteger)numberOfPlayers;
-(id) initWithSavedData: (NSDictionary *)gameStateData;
-(BOOL) canPickCard: (long)index;
-(BOOL) isPairFound;
-(BOOL) isGameOver;
-(void) pickCard: (long)index;
-(void) answeredCorrect;
-(void) answeredWrong;
-(void) saveGameData;
-(void) clearGameData;

@end
