#import "AWTooltipView.h"

#pragma mark - AWTooltipMessageView

@interface AWTooltipMessageView : UIView
@property (nonatomic, retain) NSString *message;
@property (nonatomic, assign) CGPoint arrowPoint;
@property (nonatomic, assign) AWTooltipArrowDirection arrowDirection;
@end

@implementation AWTooltipMessageView
{
	NSString *message;
	CGPoint arrowPoint;
	AWTooltipArrowDirection arrowDirection;
}

- (id)init
{
	self = [super init];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	CGFloat radius = 5.0;
	CGFloat arrowHeight = 14.0;
	CGFloat width = CGRectGetWidth(self.bounds);
	CGFloat height = CGRectGetHeight(self.bounds);

	UIBezierPath *path = [UIBezierPath bezierPath];
	[[UIColor whiteColor] setFill];

	if (arrowDirection == AWTooltipArrowDirectionUp) {
		[path moveToPoint:CGPointMake(0.0, radius + arrowHeight)];
		[path addQuadCurveToPoint:CGPointMake(radius, arrowHeight) controlPoint:CGPointMake(0.0, arrowHeight)];
		[path addLineToPoint:CGPointMake(arrowPoint.x - 10.0, arrowHeight)];
		[path addLineToPoint:arrowPoint];
		[path addLineToPoint:CGPointMake(arrowPoint.x + 10.0, arrowHeight)];
		[path addLineToPoint:CGPointMake(width - radius, arrowHeight)];
		[path addQuadCurveToPoint:CGPointMake(width, arrowHeight + radius) controlPoint:CGPointMake(width, arrowHeight)];
		[path addLineToPoint:CGPointMake(width, height - radius)];
		[path addQuadCurveToPoint:CGPointMake(width - radius, height) controlPoint:CGPointMake(width, height)];
		[path addLineToPoint:CGPointMake(radius, height)];
		[path addQuadCurveToPoint:CGPointMake(0.0, height - radius) controlPoint:CGPointMake(0.0, height)];
	}
	else {
		[path moveToPoint:CGPointMake(0.0, radius)];
		[path addQuadCurveToPoint:CGPointMake(radius, 0.0) controlPoint:CGPointZero];
		[path addLineToPoint:CGPointMake(width - radius, 0.0)];
		[path addQuadCurveToPoint:CGPointMake(width, radius) controlPoint:CGPointMake(width, 0.0)];
		[path addLineToPoint:CGPointMake(width, height - arrowHeight - radius)];
		[path addQuadCurveToPoint:CGPointMake(width - radius, height - arrowHeight) controlPoint:CGPointMake(width, height - arrowHeight)];
		[path addLineToPoint:CGPointMake(arrowPoint.x + 10.0, height - arrowHeight)];
		[path addLineToPoint:arrowPoint];
		[path addLineToPoint:CGPointMake(arrowPoint.x - 10.0, height - arrowHeight)];
		[path addLineToPoint:CGPointMake(radius, height - arrowHeight)];
		[path addQuadCurveToPoint:CGPointMake(0.0, height - arrowHeight - radius) controlPoint:CGPointMake(0.0, height - arrowHeight)];
	}
	[path closePath];
	[path fill];

	[[UIColor blackColor] set];
	CGSize messageSize = [message sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(width - 30.0, 1000.0)];
	[message drawInRect:CGRectMake(15.0, (arrowDirection == AWTooltipArrowDirectionUp) ? 29.0 : 15.0, width - 30.0, messageSize.height) withFont:[UIFont boldSystemFontOfSize:14.0] lineBreakMode:NSLineBreakByWordWrapping];
}

- (BOOL)isAccessibilityElement
{
	return YES;
}

- (NSString *)accessibilityLabel
{
	return message;
}

- (UIAccessibilityTraits)accessibilityTraits
{
	return UIAccessibilityTraitNone;
}

@synthesize message;
@synthesize arrowPoint;
@synthesize arrowDirection;
@end

#pragma mark - AWTooltipView

@implementation AWTooltipView
{
	__weak id<AWTooltipViewDelegate> delegate;
	NSString *message;

	UIView *targetView;
	AWTooltipMessageView *messageView;
	CGRect targetFrame;
	AWTooltipArrowDirection arrowDirection;

	BOOL animated;
	BOOL tooltipVisible;
}

- (id)initWithMessage:(NSString *)inMessage
{
	self = [super init];
	if (self) {
		message = inMessage;
		self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
	return self;
}

- (void)presentTooltipFromView:(UIView *)inTargetView arrowDirection:(AWTooltipArrowDirection)inArrowDirection animated:(BOOL)inAnimated
{
	if (!inTargetView) {
		return;
	}

	UIView *containerView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
	self.frame = containerView.bounds;
	[containerView addSubview:self];

	targetView = inTargetView;
	targetFrame = [targetView.superview convertRect:targetView.frame toView:containerView];
	arrowDirection = inArrowDirection;
	animated = inAnimated;

	messageView = [[AWTooltipMessageView alloc] init];
	messageView.message = message;
	messageView.arrowDirection = inArrowDirection;

	CGSize messageSize = [message sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(CGRectGetWidth(containerView.bounds) - 30.0, 1000.0)];
	messageSize.width += 30.0;
	messageSize.height += 44.0;

	CGRect messageRect;
	CGPoint arrowPoint;
	if (CGRectGetMidX(targetFrame) - (messageSize.width / 2) < 0) {
		messageRect.origin.x = 15.0;
		arrowPoint.x = CGRectGetMidX(targetFrame) - 15.0;
	}
	else if (CGRectGetMidX(targetFrame) + (messageSize.width / 2) > CGRectGetWidth(containerView.bounds)) {
		messageRect.origin.x = CGRectGetWidth(containerView.bounds) - messageSize.width - 15.0;
		arrowPoint.x = CGRectGetMidX(targetFrame) - messageRect.origin.x;
	}
	else {
		messageRect.origin.x = CGRectGetMidX(targetFrame) - (messageSize.width / 2);
		arrowPoint.x = messageSize.width / 2.0;
	}
	messageRect.origin.y = (inArrowDirection == AWTooltipArrowDirectionUp) ? CGRectGetMaxY(targetFrame) + 3.0 : CGRectGetMinY(targetFrame) - messageSize.height - 3.0;
	messageRect.size.width = messageSize.width;
	messageRect.size.height = messageSize.height;
	arrowPoint.y = (inArrowDirection == AWTooltipArrowDirectionUp) ? 0 : messageSize.height;
	messageView.arrowPoint = arrowPoint;
	[self addSubview:messageView];

	if (animated) {
		messageView.frame = CGRectMake(CGRectGetMidX(targetFrame), (inArrowDirection == AWTooltipArrowDirectionUp) ? CGRectGetMaxY(targetFrame) : CGRectGetMinY(targetFrame), 0.0, 0.0);
		self.alpha = 0.0;
		[UIView animateWithDuration:0.3 animations:^{
			messageView.frame = CGRectIntegral(messageRect);
			self.alpha = 1.0;
		} completion:nil];
	}
	else {
		messageView.frame = CGRectIntegral(messageRect);
	}

	tooltipVisible = YES;
}

- (void)dismissAnimated:(BOOL)inAnimated
{
	if (inAnimated) {
		[UIView animateWithDuration:0.3 animations:^{
			messageView.frame = CGRectMake(CGRectGetMidX(targetFrame), (arrowDirection == AWTooltipArrowDirectionUp) ? CGRectGetMaxY(targetFrame) : CGRectGetMinY(targetFrame), 0.0, 0.0);
			self.alpha = 0.0;
		} completion:^(BOOL finished) {
			[self dismiss];
		}];
	}
	else {
		[self dismiss];
	}
}

- (void)dismiss
{
	[self removeFromSuperview];
	tooltipVisible = NO;
}

#pragma mark - Touch events

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *singleTouch = [touches anyObject];
	if (singleTouch.tapCount == 1) {
		[self dismissAnimated:animated];
		if ([delegate respondsToSelector:@selector(tooltipViewTapped:)]) {
			[delegate tooltipViewTapped:self];
		}
	}
}

@synthesize delegate;
@synthesize message;
@synthesize tooltipVisible;
@end
