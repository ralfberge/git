/* SymChange */

#import <Cocoa/Cocoa.h>

#import <XMLTree.h>





@interface SymChange : NSObject
{
    

	
	NSMutableDictionary *liste;
	NSMutableDictionary *liste2;
	NSFileManager *manager;

}

IBOutlet NSTextField *chosenFile;

- (IBAction)open:(id)sender;

- (IBAction)tree:(id)sender;

@end
