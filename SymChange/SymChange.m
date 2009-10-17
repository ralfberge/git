#import "SymChange.h"




@implementation SymChange

NSString * startDatei;




- (IBAction) tree: (id) sender
  
{

	
	NSLog(startDatei);
	
	XMLTree *baum =[[XMLTree alloc] initWithXMLFile:startDatei];

		
	//  796808.gpx  liste.plist liste2.plist 796808einzel.gpx
	
	
	
	
	[baum saveToFile:@"~/Desktop/out.gpx"];

	int res = NSRunAlertPanel (@"That«s all folks!", @"", nil, nil, nil);
	
	NSLog(@"o.k.");
	  
	[NSApp terminate:self];
	
	



}



- (void) awakeFromNib

{

	manager= [[NSFileManager alloc] init];
	liste = [[NSMutableDictionary alloc] init];
	liste2 = [[NSMutableDictionary alloc] init];
	
	liste2 = [NSMutableDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SymChange/settings.plist" stringByExpandingTildeInPath]];
	
	if (liste2 == nil) 
	{ 
		NSLog (@"Fehler: Datei falsch");
		int res = NSRunAlertPanel (@"settings not found", @"~/Library/Application Support/SymChange/settings.plist wird erzeugt!", nil, nil, nil);
		

		[liste setObject:@"Custom 1" forKey: @"traditional"];
		[liste setObject:@"Custom 2" forKey: @"multi"];
		[liste setObject:@"Custom 3" forKey: @"unknown"];
		[liste setObject:@"Custom 9" forKey: @"earth"];
		[liste setObject:@"Custom 8" forKey: @"letterbox"];
		[liste setObject:@"Custom 13" forKey: @"webcam"];		
		[liste setObject:@"Custom 14" forKey: @"event"];
		
		[manager createDirectoryAtPath:[@"~/Library/Application Support/SymChange" stringByExpandingTildeInPath] attributes:nil];
		
		[liste writeToFile:[@"~/Library/Application Support/SymChange/settings.plist" stringByExpandingTildeInPath] atomically:TRUE];

				
		[liste release];
		[liste2 release];
		
		
	}
	

}






- (IBAction) open: (id) sender

{

	startDatei = [[NSString alloc] init];
	
	NSLog(@"open");
  
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setCanChooseDirectories:NO];
    [op setCanChooseFiles:YES];
    if (NSOKButton != [op runModalForDirectory:nil file:nil types:[NSArray arrayWithObjects:@"gpx", nil]]) [NSApp terminate:self];
   
	NSString *path = [[op filenames] objectAtIndex:0];
    NSMovie *file = [[NSMovie alloc] initWithURL:[NSURL fileURLWithPath:path] byReference:NO];
 

	NSLog(path, file);
	
	[chosenFile setStringValue:path];
	
	startDatei=path;
    
	
	
	
	
	
	
	
	NSLog(startDatei);
	
	XMLTree *baum =[[XMLTree alloc] initWithXMLFile:startDatei];
	
	
	//  796808.gpx  liste.plist liste2.plist 796808einzel.gpx
	
	
	
	
	[baum saveToFile:@"~/Desktop/out.gpx"];
	
	int res = NSRunAlertPanel (@"That«s all folks!", @"out.gpx liegt auf dem Schreibtisch!", nil, nil, nil);
	
	NSLog(@"o.k.");
	
	[NSApp terminate:self];
	
	
	
}











@end
