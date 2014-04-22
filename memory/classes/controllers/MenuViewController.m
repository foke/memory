//
//  MenuViewController.m
//  memory
//
//  Created by K on 23/11/13.
//  
//

#import "MenuViewController.h"
#import "GameViewController.h"
#import "HighscoreViewController.h"

@interface MenuViewController ()

@property (nonatomic) NSInteger numberOfPlayers;
@property (strong, nonatomic) UIColor *activeColor;
@property (strong, nonatomic) UIColor *inactiveColor;

@end

@implementation MenuViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.activeColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    self.inactiveColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
}

-(void) viewDidAppear:(BOOL)animated {
    // Check if there exists saved game data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.continueButton.hidden = ([defaults objectForKey:@"savedGame"]) ? NO : YES;
}

-(IBAction) startNewGame:(id)sender {
    [self startGameWithState:nil];
}

-(IBAction) continueGame:(id)sender {
    [self startGameWithState:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedGame"]];
}

-(void) startGameWithState:(NSDictionary *)gameStateData {
    GameViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"gameViewController"];
    gvc.numberOfPlayers = self.numberOfPlayers;
    gvc.gameStateData = gameStateData;
    
    [self presentViewController:gvc animated:NO completion:nil];
}

-(IBAction) displayHighscore:(id)sender {
    HighscoreViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"highscoreViewController"];
    
    [self presentViewController:hvc animated:YES completion:nil];
}

-(IBAction) setOnePlayer:(id)sender {
    self.numberOfPlayers = 1;
    [self.onePlayerButton setTitleColor:self.activeColor forState: UIControlStateNormal];
    [self.twoPlayersButton setTitleColor:self.inactiveColor forState: UIControlStateNormal];
}

-(IBAction)     setTwoPlayers:(id)sender {
    self.numberOfPlayers = 2;
    [self.onePlayerButton setTitleColor:self.inactiveColor forState: UIControlStateNormal];
    [self.twoPlayersButton setTitleColor:self.activeColor forState: UIControlStateNormal];
}

@end
