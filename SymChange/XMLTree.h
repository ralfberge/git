

#import <Cocoa/Cocoa.h>




@interface XMLTree : NSObject {

	NSMutableString * XMLDatei;
	BOOL nextInhalt;
	NSMutableDictionary *liste;


	
}

- (id)initWithXMLFile:(NSString *)filePath;
- (void)saveToFile:(NSString *)filePath;


@end
