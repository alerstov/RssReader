
#import "NewViewController.h"

@interface NewViewController ()
{
    UITextField* title;
    UITextField* url;
}
@end

@implementation NewViewController
@synthesize delegate;
@synthesize doneButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setFrame:CGRectMake(0, 20, 320, 460)];
    doneButton.enabled = NO;
    
    self.title = @"New channel";
}

- (void)viewDidUnload
{
    [self setDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//-------------------------------------------------------------------------------------------------
//
#pragma mark - Table View
//
//-------------------------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get cell
	static NSString *CellIdentifier = @"CellA";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UITextField* tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 280, 30)];
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) 
                                                     name:UITextFieldTextDidChangeNotification object:tf];
        [cell addSubview:tf];

        if (indexPath.section == 0) { title = tf; }
        if (indexPath.section == 1) { url = tf; }
    }
	        
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Title";
    if (section == 1) return @"Address";
    return nil;
}


//-------------------------------------------------------------------------------------------------
//
#pragma mark - Text Field
//
//-------------------------------------------------------------------------------------------------
-(void)textChanged:(id)sender
{
    doneButton.enabled = title.text.length > 0 && url.text.length > 0;    
}

//-------------------------------------------------------------------------------------------------
//
#pragma mark - Done/Cancel actions
//
//-------------------------------------------------------------------------------------------------
-(void)closeView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self.view];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [self.view setFrame:CGRectMake(0, 480, 320, 460)];
    [UIView commitAnimations];   
    title.text = nil;
    url.text = nil;
    doneButton.enabled = NO;
}

- (IBAction)doneAction:(id)sender {
    [self.delegate insertNewChannel:title.text.copy :url.text.copy];
    [self closeView];
}

- (IBAction)cancelAction:(id)sender {
    [self closeView];
}

@end
