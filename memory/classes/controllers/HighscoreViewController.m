//
//  HighscoreViewController.m
//  memory
//
//  Created by K on 23/11/13.
//  
//

#import "HighscoreViewController.h"
#import "HighscoreModel.h"

@implementation HighscoreViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *highscore = [[[HighscoreModel alloc] init] getHighscore];
    NSInteger i = 0;
    
    for (NSDictionary *scoreDict in highscore) {
        [self addScoreRowViewWithIndex:(++i) andName:[scoreDict objectForKey:@"name"] andScore:[[scoreDict objectForKey:@"points"] integerValue]];
    }
}

-(IBAction) displayMenu:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) addScoreRowViewWithIndex:(NSInteger)index andName: (NSString *)name andScore: (NSInteger)score {
    UIView *scoreRowView    = [[UIView alloc] initWithFrame:CGRectMake(142, 48 + index * 20, 280, 20)];
	UILabel *indexLabel     = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    UILabel *nameLabel      = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 180, 20)];
	UILabel *scoreLabel     = [[UILabel alloc] initWithFrame:CGRectMake(240, 20, 20, 20)];
    
    [indexLabel setText:[@((int)index) stringValue]];
    [nameLabel setText:name];
    [scoreLabel setText:[@((int)score) stringValue]];
    
    [scoreRowView addSubview:indexLabel];
    [scoreRowView addSubview:nameLabel];
    [scoreRowView addSubview:scoreLabel];
    
    [self.view addSubview:scoreRowView];
}

@end
