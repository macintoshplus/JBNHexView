#import <Cocoa/Cocoa.h>
#import "JBNGutterTextView.h"
#import "JBNHexTextView.h"
#import "JBNAsciiTextView.h"
#import "JBNHexAddress.h"
#import "JBNHexRepresentation.h"


#define FONTNAME @"Courier"
#define FONTSIZE 11

@interface JBNHexView : NSView /* Specify a superclass (eg: NSObject or NSView) */ {
	
	NSScrollView * gutterScrollView;
	
	NSScrollView * hexScrollView;
	
	NSScrollView * asciiScrollView;
	JBNAsciiTextView * asciiRepresentation;
	
	JBNHexAddress * hexAddress;
	
	JBNHexRepresentation * hexRepresentation;
	
	NSData * data;
	
	
	NSString * bufferText;
	int gutterWidth;
	int hexWidth;
}

@property (assign) JBNHexAddress * hexAddress;
@property (assign) JBNHexRepresentation * hexRepresentation;
@property (assign) NSScrollView * gutterScrollView;
@property (assign) NSScrollView * hexScrollView;
@property (assign) NSScrollView * asciiScrollView;
@property (assign) JBNAsciiTextView * asciiRepresentation;
@property (retain) NSData * data;
@property (assign) int gutterWidth;
@property (assign) int hexWidth;


@end
