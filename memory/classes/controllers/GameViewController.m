//
//  GameViewController.m
//  memory
//
//  Created by K on 12/11/13.
//
//

#import <AVFoundation/AVFoundation.h>
#import "GameViewController.h"
#import "CardView.h"
#import "GameModel.h"
#import "CardModel.h"
#import "HighscoreModel.h"
#import "GameOverViewController.h"
#import "gameSettings.h"

@interface GameViewController ()

@property (nonatomic) GameModel *gameModel;
@property (nonatomic) NSMutableArray *turnedCardViews;
@property (nonatomic) HighscoreModel *hsModel;
@property (nonatomic) AVAudioPlayer *successAudio;
@property (nonatomic) AVAudioPlayer *failAudio;
@property (nonatomic) AVAudioPlayer *finishAudio;

@end

@implementation GameViewController

-(void) viewDidLoad {
    if (self.gameStateData != nil) {
        self.gameModel = [[GameModel alloc] initWithSavedData:self.gameStateData];
    } else {
        self.gameModel = [[GameModel alloc] initWithPlayers:self.numberOfPlayers];
    }
    
    self.hsModel = [[HighscoreModel alloc] init];
    self.turnedCardViews = [NSMutableArray array];
    
    // Load sounds
    self.successAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"]] error:NULL];
    self.failAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"fail" ofType:@"wav"]] error:NULL];
    self.finishAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"finish" ofType:@"wav"]] error:NULL];
    
    [self generateCardViews];
    [self updateScoreLabel:self.player1ScoreLabel withScore:(long)self.gameModel.player1Score];
    
    if (self.gameModel.isMultiplayer) {
        self.turnLabel.hidden = NO;
        self.player2ScoreLabel.hidden = NO;
        
        [self updateScoreLabel:self.player2ScoreLabel withScore:(long)self.gameModel.player2Score];
        [self updateTurnLabel];        
        [self changeActivePlayer];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.boardView addGestureRecognizer:tapGesture];
}

-(void) viewDidAppear: (BOOL)animated {
    [super viewDidAppear:animated];
    
    // Adjustments - need to be set when view has appeared
    self.scrollView.contentSize = self.boardView.frame.size;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = MIN_ZOOM;
}

-(void) generateCardViews {
    int positionsLeftInRow = CARDS_PER_ROW;
    int j = 0;
    
    for (int i = 0; i < [self.gameModel.cards count]; i++) {
        NSInteger value = ((CardModel *)self.gameModel.cards[i]).value;
        CardView *cv = [[CardView alloc] initWithFrame:CGRectMake((i % CARDS_PER_ROW) * 100 + (i % CARDS_PER_ROW) * 20 + 40, j * 100 + j * 20 + 40, 100, 100) andPosition:i andValue:value];
        
        if (!((CardModel *)self.gameModel.cards[i]).outOfPlay) {
            [self.boardView addSubview:cv];
            
            if ([self.gameModel.turnedCards containsObject: self.gameModel.cards[i]]) {
                [self.turnedCardViews addObject: cv];
                [cv flip];
            }
        }
        
        if (--positionsLeftInRow == 0) {
            j++;
            positionsLeftInRow = CARDS_PER_ROW;
        }
    }
}

-(void) handleTap: (UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    CGPoint location = [recognizer locationInView:view];
    UIView *subview = [view hitTest:location withEvent:nil];

    if ([self.turnedCardViews count] < 2) {
        if([subview isKindOfClass:[CardView class]]) {
            CardView *cv = (CardView *)subview;
            if (![self.turnedCardViews containsObject: cv]) {
                [self.gameModel pickCard:(long)cv.pos];
                
                [self.turnedCardViews addObject:cv];
                [self flipCard:cv];
            }
        }
    } else {
        [self flipBackCards];
        [self changeActivePlayer];
        [self.turnedCardViews removeAllObjects];
        [self.gameModel saveGameData];
    }
}

-(void) flipCard: (CardView *)cv {
    self.boardView.userInteractionEnabled = NO;
    [UIView transitionWithView:cv duration:.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [cv flip];
                    }
                    completion:^(BOOL finished){
                        self.boardView.userInteractionEnabled = YES;
                        [self checkState];
                    }];
}

-(void) flipBackCards {
    self.boardView.userInteractionEnabled = NO;
    CardView *cv1 = (CardView *) self.turnedCardViews[0];
    CardView *cv2 = (CardView *) self.turnedCardViews[1];
    
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            self.boardView.userInteractionEnabled = YES;
        }];
        [UIView transitionWithView:cv1
                          duration:.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ [cv1 flip]; }
                        completion:nil];
        [UIView transitionWithView:cv2
                          duration:.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ [cv2 flip]; }
                        completion:nil];
    } [CATransaction commit];
}

-(void) fadeOutTurnedCards {
    if ([self.turnedCardViews count] == 2) {
        self.boardView.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:.5
                         animations:^{
                             ((CardView *) self.turnedCardViews[0]).alpha = 0;
                             ((CardView *) self.turnedCardViews[1]).alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self.turnedCardViews removeAllObjects];
                             [self checkGameFinished];
                             self.boardView.userInteractionEnabled = YES;
                         }];
    }
}

/*
 * checkState checks if pair was found or not and updates the scoreboard.
 */
-(void) checkState {
    if ([self.turnedCardViews count] == 2) {
        CardView *cv1 = (CardView *) self.turnedCardViews[0];
        CardView *cv2 = (CardView *) self.turnedCardViews[1];

        if (cv1.value == cv2.value) {
            [self.gameModel answeredCorrect];
            [self fadeOutTurnedCards];
            [self.successAudio play];
        } else {
            [self.gameModel answeredWrong];
            [self.failAudio play];
        }
        
        [self updateScoreLabel:self.player1ScoreLabel withScore:(long) self.gameModel.player1Score];
        
        if (self.gameModel.isMultiplayer) {
            [self updateScoreLabel:self.player2ScoreLabel withScore:(long) self.gameModel.player2Score];
        }
    }
    
    [self.gameModel saveGameData];
}

-(void) checkGameFinished {
    if ([self.gameModel isGameOver]) {
        GameOverViewController *govc = [self.storyboard instantiateViewControllerWithIdentifier:@"gameOverViewController"];
        
        if (self.gameModel.isMultiplayer && !self.gameModel.isFirstPlayersTurn) {
            govc.score = self.gameModel.player2Score;
            govc.winner = @"Player 2";
        } else {
            govc.score = self.gameModel.player1Score;
            govc.winner = @"Player 1";
        }
        
        [self.finishAudio play];
        
        [self presentViewController:govc animated:NO completion:^(){
            [self.gameModel clearGameData];
        }];
    }
}

-(void) changeActivePlayer {
    if (self.gameModel.isMultiplayer) {
        UIColor *color = [UIColor colorWithRed:50/255.0 green:190/255.0 blue:255/255.0 alpha:1.0];
        
        if (self.gameModel.isFirstPlayersTurn) {
            [self.player1ScoreLabel setTextColor:color];
            [self.player2ScoreLabel setTextColor:[UIColor blackColor]];
        } else {
            [self.player2ScoreLabel setTextColor:color];
            [self.player1ScoreLabel setTextColor:[UIColor blackColor]];
        }
        
        [self updateTurnLabel];
    }
}

-(void) updateScoreLabel: (UILabel *)scoreLabel withScore: (long)score {
    scoreLabel.text = [NSString stringWithFormat:@"%ld", score];
}

-(void) updateTurnLabel {
    NSString *player = self.gameModel.isFirstPlayersTurn ? @"Player 1" : @"Player 2";
    self.turnLabel.text = [NSString stringWithFormat:@"%@, your turn!", player];
}

-(IBAction) displayMenu: (id)sender {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

-(UIView *) viewForZoomingInScrollView: (UIScrollView *)scrollView {
    return self.boardView;
}
@end
