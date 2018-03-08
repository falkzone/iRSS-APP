//
//  ViewController.h
//  iRSS
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate> {
	
    IBOutlet UIAlertView *devlinks;
    
    // UITableView - listing the RSS feed
    IBOutlet UITableView * newsTable;
    
    // UIWebView - showing the selected feed to the user
    IBOutlet UIWebView *webviewer;
    
    // RSS feed loader activity indicator
	UIActivityIndicatorView * activityIndicator;
	
    // UITableView properties
    CGSize cellSize;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableDictionary * item;
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
    
    // UIWebView activity indicator
    IBOutlet UIActivityIndicatorView *active;
    
    IBOutlet UIToolbar *barone;
    
    // UISegmentedControl - Show & Hide Feed list
    IBOutlet UISegmentedControl *control;
    
}

-(IBAction)devlinksbutton;

-(IBAction)feedcontrolselection;

- (void)parseXMLFileAtURL:(NSString *)URL;

@property (nonatomic, retain) UIWebView *webviewer;

@end
