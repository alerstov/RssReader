

#import <UIKit/UIKit.h>

@protocol NewViewControllerDelegate
// insertNewObject
-(void)insertNewChannel:(NSString*)title :(NSString*)url;
@end


@interface NewViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) id<NewViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@end
