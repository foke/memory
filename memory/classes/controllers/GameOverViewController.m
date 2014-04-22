//
//  GameOverViewController.m
//  memory
//
//  Created by K on 03/12/13.
//
//

#import "GameOverViewController.h"
#import "HighscoreModel.h"

@interface GameOverViewController ()

@property (nonatomic) HighscoreModel *hsModel;

@end

@implementation GameOverViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
	self.hsModel = [[HighscoreModel alloc] init];
    
    UILabel *winnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(161, 100, 170, 30)];
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(310, 100, 110, 30)];
    winnerLabel.font = [winnerLabel.font fontWithSize:25];
    scoreLabel.font = [scoreLabel.font fontWithSize:25];
    
    [winnerLabel setText: self.winner];
    [scoreLabel setText: [NSString stringWithFormat:@"%ld points", (long) self.score]];
    
    [self.view addSubview:winnerLabel];
    [self.view addSubview:scoreLabel];
    
    if ([self.hsModel didReachHighscore: self.score]) {
        self.nameField.delegate = self;
        [self.nameField setText: self.winner];
        
        self.nameLabel.hidden = NO;
        self.nameField.hidden = NO;
    }
    
}

-(IBAction) goToMenu: (id)sender {
    [self.hsModel saveScoreWithPoints:self.score andName:self.nameField.text];
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

-(BOOL) textFieldShouldReturn: (UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) textFieldShouldBeginEditing: (UITextField *)textField {
    [textField setText:@""];
    return YES;
}
@end
