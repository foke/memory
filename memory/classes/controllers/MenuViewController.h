//
//  MenuViewController.h
//  memory
//
//  Created by K on 23/11/13.
//  
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *twoPlayersButton;
@property (strong, nonatomic) IBOutlet UIButton *onePlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
-(IBAction) startNewGame:(id)sender;
-(IBAction) continueGame:(id)sender;
-(IBAction) displayHighscore:(id)sender;
-(IBAction) setOnePlayer:(id)sender;
-(IBAction) setTwoPlayers:(id)sender;

@end
