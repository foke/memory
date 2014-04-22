//
//  GameViewController.h
//  memory
//
//  Created by K on 12/11/13.
//
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *boardView;
@property (strong, nonatomic) IBOutlet UILabel *player1ScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *player2ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property (nonatomic) NSInteger numberOfPlayers;
@property (nonatomic) NSDictionary *gameStateData;

-(IBAction) displayMenu: (id)sender;

@end
