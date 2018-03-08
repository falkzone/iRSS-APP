//
//  ViewController.m
//  iRSS
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize webviewer;

-(IBAction)feedcontrolselection {
    
    if (control.selectedSegmentIndex ==0) {
        // Show feed list - (With simple fade style animation)
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView setAnimationDuration:1.2];
        newsTable.alpha = 1.0;
        webviewer.alpha = 0.0;
        barone.alpha = 0.0;
        [UIView commitAnimations];
    }
    
    if (control.selectedSegmentIndex ==1) {
        // Hide feed list - (With simple fade style animation)
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView setAnimationDuration:1.2];
        newsTable.alpha = 0.0;
        webviewer.alpha = 1.0;
        barone.alpha = 1.0;
        [UIView commitAnimations];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier = @"MyIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        
	}
    
	// Set up the cell
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    
    // Title text line of UITableView cell (Top line text)
    cell.textLabel.text=[[stories objectAtIndex: storyIndex] objectForKey: @"title"];
    
    // Detail text line of UITableView cell (Bottom line text)
    cell.detailTextLabel.text=[[stories objectAtIndex: storyIndex] objectForKey: @"date"];
    
    // UITableView cell text font
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17.0];
    
    // UITableView cell text colour
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // UITableView Cell background image (normal)
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellv10.png"]];
    
    // UITableView Cell background image (pressed)
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellv10g.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    
    NSString * storyLink = [[stories objectAtIndex: storyIndex] objectForKey: @"link"];
    NSLog(@"%@",stories );
    
    // clean up the link - get rid of spaces, returns, and tabs...
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
    
    // View selected feed
    [webviewer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:storyLink]]];
    
    // Fade in UIWebView - By default the UIWebView is hidden. Once a feed is selected the UiWebView will fade in with a smooth (and minimal) animation.
    [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
    [UIView setAnimationDuration:1.2];
    webviewer.alpha = 1.0;
    newsTable.alpha = 0.0;
    barone.alpha = 1.0;
    control.selectedSegmentIndex =1;
    [UIView commitAnimations];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    webviewer.backgroundColor = [UIColor clearColor];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkLoad) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkNotLoad) userInfo:nil repeats:YES];
    
    // Height of UITableView cell
    self->newsTable.rowHeight = 70;
    
	if ([stories count] == 0) {
        
        
        ///////////////////////////////////////////////////////////////
        //////////////////////// RSS FEED URL /////////////////////////
        
		NSString * path = @"http://feeds.macrumors.com/MacRumors-All";
        
        //////////////////////// RSS FEED URL /////////////////////////
        ///////////////////////////////////////////////////////////////
        
        
        [self parseXMLFileAtURL:path];
	}
	
    cellSize = CGSizeMake([newsTable bounds].size.width, 60);
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

-(void)webView: (UIWebView *)youtubewebview didFailLoadWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"There appears to be a problem with your Internet Connection. This Application requires an EDGE/3G or WiFi Network in order to work. Please connect to a network and try agsin." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

-(void)checkLoad {
	if (webviewer.loading) {
		[active startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

-(void)checkNotLoad {
	if (!(webviewer.loading)) {
		[active stopAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // All screen orientations supported
    return YES;
}

#pragma mark - parseing_Delegate_methods
- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"found file and started parsing");
}

- (void)parseXMLFileAtURL:(NSString *)URL
{
	stories = [[NSMutableArray alloc] init];
    
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL URLWithString:URL];
    
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [rssParser setDelegate:self];
    
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
    [rssParser parse];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"]) {
        
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentSummary forKey:@"summary"];
		[item setObject:currentDate forKey:@"date"];
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", currentTitle);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"description"]) {
		[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[currentDate appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
    
	NSLog(@"all done!");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    NSLog(@"stories array has %d items", [stories count]);
	
    [newsTable reloadData];
}



//// Developed by Daniel Sadjadian - Developer Links:

- (IBAction)devlinksbutton {
    devlinks = [[UIAlertView alloc] initWithTitle:@"Developed by Supertecnoboff" message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"iOS Apps", @"Website", @"Twitter", @"YouTube", nil];
	[devlinks show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 1) {
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/supertecnoboffapps"]];
	}
	
	if (buttonIndex == 2) {
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://supertecnoboff.co.uk"]];
	}
	
	if (buttonIndex == 3) {
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mobile.twitter.com/supertecnoboff"]];
	}
	
	if (buttonIndex == 4) {
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.youtube.co.uk/supertecnoboff"]];
	}
}

@end
