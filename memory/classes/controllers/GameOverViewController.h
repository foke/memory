//
//  GameOverViewController.h
//  memory
//
//  Created by K on 03/12/13.
//  
//

#import <UIKit/UIKit.h>

@interface GameOverViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) NSInteger score;
@property (nonatomic) NSString *winner;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(IBAction) goToMenu:(id)sender;

@end
