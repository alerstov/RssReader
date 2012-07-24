
#import "MainViewController.h"

#import "AppDelegate.h"
#import "RssToken.h"
#import "HttpRequest.h"
#import "RssUserData.h"
#import "NewViewController.h"
#import "DetailViewController.h"


@interface MainViewController ()<HttpRequestDelgate, NewViewControllerDelegate>
{
    NSMutableArray* rssUserData;
    NSInteger refreshIndex; 
    RssUserData* current; 
}
@end


@implementation MainViewController
@synthesize detailViewController = _detailViewController;
@synthesize newViewController = _newViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                  target:self action:@selector(showNewView:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] 
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                      target:self action:@selector(refreshChannels:)];
    self.toolbarItems =[[NSArray alloc] initWithObjects:refreshButton, nil];
    self.navigationController.toolbarHidden = NO;

    
    rssUserData = [NSMutableArray new];
    
    id ri = [RssUserData new];
    [ri setName:@"test"];
    [ri setUrl:@"http://news.yandex.ru/computers.rss"];
    [rssUserData addObject:ri];
    
    ri = [RssUserData new];
    [ri setName:@"test2"];
    [ri setUrl:@"http://news.yandex.ru/index.rss"];
    [rssUserData addObject:ri];
    
    ri = [RssUserData new];
    [ri setName:@"gazeta"];
    [ri setUrl:@"http://www.gazeta.ru/export/gazeta_rss.xml"];
    [rssUserData addObject:ri];
    
    self.title = @"Channels";
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}




//-------------------------------------------------------------------------------------------------
//
#pragma mark - new channel
//
//-------------------------------------------------------------------------------------------------

- (void)showNewView:(id)sender
{
    if (!self.newViewController){
        self.newViewController = [[NewViewController alloc] initWithNibName:@"NewViewController" bundle:nil];
        self.newViewController.delegate = self;
    }
    
    AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.newViewController.view setFrame:CGRectMake(0, 460, 320, 460)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [ad.window addSubview:self.newViewController.view];
    [self.newViewController.view setFrame:CGRectMake(0, 20, 320, 460)];
    [UIView commitAnimations];
}

-(void)insertNewChannel:(NSString *)title :(NSString *)url
{
    RssUserData* newItem = [[RssUserData alloc] init];
    newItem.name = title;
    newItem.url = url;
    [rssUserData insertObject:newItem atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}


//-------------------------------------------------------------------------------------------------
//
#pragma mark - refreshing
//
//-------------------------------------------------------------------------------------------------

- (void)refreshChannels:(id)sender {
    
    if (rssUserData.count == 0) return;
    
    // disable UI
    self.title = @"refreshing...";
    self.navigationController.view.userInteractionEnabled = NO;
    refreshIndex = 0;
    [self startRequest];
}

-(void)startRequest
{
    current = [rssUserData objectAtIndex:refreshIndex];
    NSString* adr = [current url];
    [HttpRequest request:adr :self];
}

-(void)requestComplete:(NSData*)data
{
    RssToken* token = nil;
    if (data)
    {
        token = [RssToken parseWithData:data];
        // could be nil if error
    }
    [current setRssToken:token];
    current.status = token ? @"ok" : @"error";
    
    refreshIndex++;
    if (refreshIndex < rssUserData.count)
    {
        [self startRequest];
    }
    else
    {
        // enable UI
        self.title= @"Channels";
        self.navigationController.view.userInteractionEnabled = YES;

        // reload table
        NSLog(@"reload table"); 
        [self.tableView reloadData];
    }
}




//-------------------------------------------------------------------------------------------------
//
#pragma mark - Table View
//
//-------------------------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return rssUserData.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get cell
	static NSString *CellIdentifier = @"CellA";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	// Display
	NSUInteger row = [indexPath row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:10];
    
    RssUserData* data = [rssUserData objectAtIndex:row];
    if ([data rssToken]) {
        cell.textLabel.text = [[data rssToken]title];
        cell.detailTextLabel.text = data.rssToken.pubDate ? data.rssToken.pubDate : data.rssToken.description;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.textLabel.text = [data name];
        cell.detailTextLabel.text = data.status ? data.status : data.url;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [rssUserData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RssToken* token = [[rssUserData objectAtIndex:indexPath.row] rssToken];
    if (!token) return;
    
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    self.detailViewController.token = token;
    self.detailViewController.title = token.title;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}


@end
