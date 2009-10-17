
#import "XMLTree.h"





// *** IMPLEMENTATION OF XMLTree ***

@implementation XMLTree


- (id)init {
	self = [super init];
	
	
	return self;
}


- (id)initWithXMLFile:(NSString *)filePath {
	
	// var
	
	BOOL			success = NO;
	NSURL *			xmlURL = nil;
	NSXMLParser	*	parser = nil;
	
	
	// begin
	
	liste = [[NSMutableDictionary alloc] init];
	liste = [NSMutableDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SymChange/settings.plist" stringByExpandingTildeInPath]];
	
		
	self = [self init];
	XMLDatei = [NSMutableString stringWithString:
		@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\n\n\n<gpx>\n"];
	
	// Grow up XML tree		
	if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
		xmlURL = [ NSURL fileURLWithPath:[filePath stringByExpandingTildeInPath] ];
		
		
		
		nextInhalt = NO;
		
		parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL ];
		if (parser) {
			[parser setDelegate: self];
			success = [parser parse];
						
		}
	}
	[parser release];
	
	
	
	
	[XMLDatei replaceOccurrencesOfString:@"Geocache|Traditional Cache" withString:[liste objectForKey:@"traditional"] options:0 range:NSMakeRange(0, [XMLDatei length])];
	[XMLDatei replaceOccurrencesOfString:@"Geocache|Multi-cache" withString:[liste objectForKey:@"multi"] options:0 range:NSMakeRange(0, [XMLDatei length])];
	[XMLDatei replaceOccurrencesOfString:@"Geocache|Unknown Cache" withString:[liste objectForKey:@"unknown"] options:0 range:NSMakeRange(0, [XMLDatei length])];
	[XMLDatei replaceOccurrencesOfString:@"Geocache|Earthcache" withString:[liste objectForKey:@"earth"] options:0 range:NSMakeRange(0, [XMLDatei length])];
	[XMLDatei replaceOccurrencesOfString:@"Geocache|Letterbox Hybrid" withString:[liste objectForKey:@"letterbox"] options:0 range:NSMakeRange(0, [XMLDatei length])];
	[XMLDatei replaceOccurrencesOfString:@"Geocache|Webcam Cache" withString:[liste objectForKey:@"webcam"] options:0 range:NSMakeRange(0, [XMLDatei length])];	[XMLDatei replaceOccurrencesOfString:@"Geocache|Event Cache" withString:[liste objectForKey:@"event"] options:0 range:NSMakeRange(0, [XMLDatei length])];

	
	
	if ( !success ) {
		[self release];
		self = nil;
		
		[liste release];
	}
	
	return self;
	
	
	
	
}


- (void)saveToFile:(NSString *)filePath {
	
	
	// var
	
	// begin
	
	[XMLDatei appendString:@"</gpx>\n"];

	
	[XMLDatei writeToFile:[filePath stringByExpandingTildeInPath] atomically:YES];
	
	
	
}




// *** XML EVENTS ***


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
	{
	
	
	NSLog (@"Fehler in XML");
	
	//NSLog ([NSString stringWithString:[[parser parserError] localizedDescription]]);
	
	int reso = NSRunAlertPanel (@"Fehler in der GPX Datei!", @"", nil, nil, nil);
	
	NSLog(@"o.k.");
	
	[NSApp terminate:self];
	
	}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	
	// var

	NSMutableString * helpString;
	int i;
	
	// begin
		
	helpString  = [[NSMutableString alloc] init];

	
	if ([elementName isEqualToString:@"name"])
		{
		[XMLDatei appendString:@"<name>"];
		nextInhalt = YES;
		}	
	
	if ([elementName isEqualToString:@"desc"])
		{
		[XMLDatei appendString:@"<desc>"];
		nextInhalt = YES;
		}	

	if ([elementName isEqualToString:@"wpt"])
		{
		
		[helpString setString:[attributeDict descriptionInStringsFileFormat]];	
		
		[helpString replaceCharactersInRange:[helpString rangeOfString:@"\"lat\""] withString:@" lat"]; 
		[helpString replaceCharactersInRange:[helpString rangeOfString:@"\"lon\""] withString:@"lon"]; 
		[helpString deleteCharactersInRange:[helpString rangeOfString:@"\n"]];
		[helpString deleteCharactersInRange:[helpString rangeOfString:@"\n"]]; 
		[helpString deleteCharactersInRange:[helpString rangeOfString:@";"]]; 
		[helpString deleteCharactersInRange:[helpString rangeOfString:@";"]]; 
	
		
		[XMLDatei appendString:@"<wpt "];
		[XMLDatei appendString:helpString];		
		[XMLDatei appendString:@">\n"];
		}	
	

	if ([elementName isEqualToString:@"type"])
		{
		[XMLDatei appendString:@"<sym>"];
		nextInhalt = YES;
		}	

	[helpString release];	
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string

{

		
	if (nextInhalt) 
	{	[XMLDatei appendString:string];
		nextInhalt = NO;
	}
	
}




- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 

{
	
	if ([elementName isEqualToString:@"name"])
	{
		[XMLDatei appendString:@"</name>\n"];
		nextInhalt = NO;
	}	
	
	if ([elementName isEqualToString:@"desc"])
	{
		[XMLDatei appendString:@"</desc>\n"];
		nextInhalt = NO;
	}	
	
	if ([elementName isEqualToString:@"wpt"])
	{
		[XMLDatei appendString:@"</wpt>\n"];
		nextInhalt = NO;

	}	
	
	
	if ([elementName isEqualToString:@"type"])
	{
		[XMLDatei appendString:@"</sym>\n"];
		nextInhalt = NO;
	}	


	
}


- (void)dealloc {
	
}



@end    // of XMLTree



