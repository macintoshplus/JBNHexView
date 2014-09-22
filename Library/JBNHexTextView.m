//
//  JBNHexTextView.m
//  HexView
//
//  Created by Jean-Baptiste Nahan on 23/09/10.
//  Copyright 2010-2014 Jean-Baptiste Nahan. All rights reserved.
//

#import "JBNHexTextView.h"
#import "JBNHexView.h"


@implementation JBNHexTextView

- (id)initWithFrame:(NSRect)frame
{
	if (self = [super initWithFrame:frame]) {
		
		[self setContinuousSpellCheckingEnabled:NO];
		[self setAllowsUndo:NO];
		[self setAllowsDocumentBackgroundColorChange:NO];
		[self setRichText:NO];
		[self setUsesFindPanel:NO];
		[self setUsesFontPanel:NO];
		[self setAlignment:NSLeftTextAlignment];
		[self setEditable:NO];
		[self setSelectable:YES];
		[[self textContainer] setContainerSize:NSMakeSize(50, FLT_MAX)];
		[self setVerticallyResizable:YES];
		[self setHorizontallyResizable:YES];
		[self setAutoresizingMask:NSViewHeightSizable];
		[self setFont:[NSFont fontWithName:FONTNAME size:FONTSIZE]];
		
		//[self setFont:[NSFont fontWithName:[MTIDEDefault stringForKey:@"editorFontName"] size:[MTIDEDefault integerForKey:@"editorFontSize"]]];
		[self setTextColor:[NSColor textColor]];//[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:@"TextColourWell"]]];
		[self setInsertionPointColor:[NSColor textColor]];//[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:@"TextColourWell"]]];
		[self setBackgroundColor:[NSColor colorWithCalibratedWhite:0.98 alpha:1.0]];
		
		
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
	//NSLog(@"observeValueForKeyPath !");
	if([keyPath isEqualToString:@"data"]){
		//NSLog(@"Data has changed !");
		//NSInteger location = [self selectedRange].location;
		//[self refreshContent:object];
		
	}
}

- (void)viewBoundsDidChange:(NSNotification *)notification
{
	//NSLog(@"viewBoundsDidChange !");
	if (notification != nil && [notification object] != nil && [[notification object] isKindOfClass:[NSClipView class]]) {
		//[self updateLineNumbersForClipView:[notification object] checkWidth:YES recolour:YES];
	}
}

- (void)refreshContent:(id)object{
	
	//Récupère le nombre de caratère a afficher par ligne
	int nbChar = [[object asciiRepresentation] getNbCharByLine];
	
	//NSData * d = [object data];
	
	NSMutableString * representation = [[NSMutableString alloc] initWithData:[object data] encoding:NSASCIIStringEncoding];
	
	unsigned long i=0;
	unsigned long max = [representation length];
	
	NSString * s = @"";
	//char * charL;
	
	/*
	 
	 int i=0;
	 int max = [d length];
	 
	 NSString * s = @"";
	 char car;
	 
	 */
	
	int nbAddCar =0;
	
	for(i=0; i<max; i++){
		/*
		 [d getBytes:&car range:NSMakeRange(i, 1)];
		 s = [s stringByAppendingFormat:@"%02X ",car];
		 
		 */
		nbAddCar++;
		s = [s stringByAppendingFormat:@"%02X ",[representation characterAtIndex:i]];
		if(nbChar==nbAddCar){
			nbAddCar=0;
			s = [s stringByAppendingString:@"\n"];
		}
		
		
	}
	
	
	[self setString:s];
	//[self setSelectedRange:NSMakeRange(location, 0)];
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
