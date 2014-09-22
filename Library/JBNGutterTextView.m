//
//  JBNGutterTextView.m
//  HexView
//
//  Created by Jean-Baptiste Nahan on 23/09/10.
//  Copyright 2010-2014 Jean-Baptiste Nahan. All rights reserved.
//

#import "JBNGutterTextView.h"
#import "JBNHexView.h"


@implementation JBNGutterTextView

- (id)initWithFrame:(NSRect)frame
{
	if (self = [super initWithFrame:frame]) {
		
		[self setContinuousSpellCheckingEnabled:NO];
		[self setAllowsUndo:NO];
		[self setAllowsDocumentBackgroundColorChange:NO];
		[self setRichText:NO];
		[self setUsesFindPanel:NO];
		[self setUsesFontPanel:NO];
		[self setAlignment:NSRightTextAlignment];
		[self setEditable:NO];
		[self setSelectable:NO];
		[[self textContainer] setContainerSize:NSMakeSize(50, FLT_MAX)];
		[self setVerticallyResizable:YES];
		[self setHorizontallyResizable:YES];
		[self setAutoresizingMask:NSViewHeightSizable];
		[self setFont:[NSFont fontWithName:FONTNAME size:FONTSIZE]];
		
		//[self setFont:[NSFont fontWithName:[MTIDEDefault stringForKey:@"editorFontName"] size:[MTIDEDefault integerForKey:@"editorFontSize"]]];
		[self setTextColor:[NSColor textColor]];//[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:@"TextColourWell"]]];
		[self setInsertionPointColor:[NSColor textColor]];//[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:@"TextColourWell"]]];
		[self setBackgroundColor:[NSColor colorWithCalibratedWhite:0.94 alpha:1.0]];
		
		[self setDelegate:self];
		
		//[MTIDEDefault addObserver:self forKeyPath:@"editorFontName" options:NSKeyValueObservingOptionNew context:nil];
		//[MTIDEDefault addObserver:self forKeyPath:@"editorFontSize" options:NSKeyValueObservingOptionNew context:nil];
	}
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	
	
	if([keyPath isEqualToString:@"data"]){
		//[self refreshContent:object];
		
	}

	
	
}

- (void)refreshContent:(id)object{
	//Récupère le nombre de caratère a afficher par ligne
	int nbChar = [[object asciiRepresentation] getNbCharByLine];
	int nbLine = [[object asciiRepresentation] getNbLine];
	
	NSString * s=@"";
	
	int i=0;
	for(i=0;i<=nbLine;i++){
		s=[s stringByAppendingFormat:@"%06X\n",(int)(i*(nbChar+1))];
	}
	
	[self setString:s];

}

- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
	
	NSRect bounds = [self bounds]; 
	if ([self needsToDrawRect:NSMakeRect(bounds.size.width - 1, 0, 1, bounds.size.height)] == YES) {
		[[NSColor lightGrayColor] set];
		NSBezierPath *dottedLine = [NSBezierPath bezierPathWithRect:NSMakeRect(bounds.size.width, 0, 0, bounds.size.height)];
		CGFloat dash[2];
		dash[0] = 1.0;
		dash[1] = 2.0;
		[dottedLine setLineDash:dash count:2 phase:1.0];
		[dottedLine stroke];
	}
	
}


- (BOOL)isOpaque
{
	return YES;
}


@end
