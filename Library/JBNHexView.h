//
//  JBNHexView.h
//  HexView
//
//  Created by Jean-Baptiste Nahan on 23/09/10.
//  Copyright 2010-2014 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBNGutterTextView.h"
#import "JBNHexTextView.h"
#import "JBNAsciiTextView.h"
#import "JBNHexAddress.h"
#import "JBNHexRepresentation.h"

@class JBNHexAddress;
@class JBNHexRepresentation;

#define FONTNAME @"Courier"
#define FONTSIZE 10

@interface JBNHexView : NSView /* Specify a superclass (eg: NSObject or NSView) */ {
	
	/*NSScrollView * gutterScrollView;
	
	NSScrollView * hexScrollView;
	
	NSScrollView * asciiScrollView;
	JBNAsciiTextView * asciiRepresentation;
	
	JBNHexAddress * hexAddress;
	
	JBNHexRepresentation * hexRepresentation;
	*/
	NSData * data;
	
	
	NSString * bufferText;
	int gutterWidth;
	int hexWidth;
}

@property (retain) JBNHexAddress * hexAddress;
@property (retain) JBNHexRepresentation * hexRepresentation;
@property (retain) NSScrollView * gutterScrollView;
@property (retain) NSScrollView * hexScrollView;
@property (retain) NSScrollView * asciiScrollView;
@property (retain) JBNAsciiTextView * asciiRepresentation;
@property (nonatomic,retain) NSData * data;
@property (assign) int gutterWidth;
@property (assign) int hexWidth;


@end
