
#import <UIKit/UIKit.h>

@class DetailViewController;
@class NewViewController;

@interface MainViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic, getter = theNewViewController) NewViewController *newViewController;

@end
