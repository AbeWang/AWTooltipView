#import "AWViewController.h"

@implementation AWViewController
{
	UIButton *buttonOne;
	UIButton *buttonTwo;
	UIButton *buttonThree;

	AWTooltipView *tooltipOne;
	AWTooltipView *tooltipTwo;
	AWTooltipView *tooltipThree;
}

- (void)loadView
{
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];

	tooltipOne = [[AWTooltipView alloc] initWithMessage:@"Message One!!\nHello world!!"];
	tooltipOne.delegate = self;
	buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonOne setTitle:@"One" forState:UIControlStateNormal];
	[buttonOne setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	buttonOne.frame = CGRectMake(10.0, 250.0, 86.0, 44.0);
	buttonOne.layer.borderWidth = 1.0;
	buttonOne.layer.borderColor = [UIColor blueColor].CGColor;
	buttonOne.layer.cornerRadius = 5.0;
	[buttonOne addTarget:self action:@selector(tapButtonOne:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:buttonOne];

	tooltipTwo = [[AWTooltipView alloc] initWithMessage:@"Message Two!!\nHello world!!"];
	tooltipTwo.delegate = self;
	buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonTwo setTitle:@"Two" forState:UIControlStateNormal];
	[buttonTwo setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	buttonTwo.frame = CGRectMake(116.0, 250.0, 86.0, 44.0);
	buttonTwo.layer.borderWidth = 1.0;
	buttonTwo.layer.borderColor = [UIColor blueColor].CGColor;
	buttonTwo.layer.cornerRadius = 5.0;
	[buttonTwo addTarget:self action:@selector(tapButtonTwo:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:buttonTwo];

	tooltipThree = [[AWTooltipView alloc] initWithMessage:@"Message Three!!\nHello world!!"];
	tooltipThree.delegate = self;
	buttonThree = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonThree setTitle:@"Three" forState:UIControlStateNormal];
	[buttonThree setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	buttonThree.frame = CGRectMake(222.0, 250.0, 86.0, 44.0);
	buttonThree.layer.borderWidth = 1.0;
	buttonThree.layer.borderColor = [UIColor blueColor].CGColor;
	buttonThree.layer.cornerRadius = 5.0;
	[buttonThree addTarget:self action:@selector(tapButtonThree:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:buttonThree];
}

- (IBAction)tapButtonOne:(id)sender
{
	[tooltipOne presentTooltipFromView:buttonOne arrowDirection:AWTooltipArrowDirectionDown animated:YES];
}
- (IBAction)tapButtonTwo:(id)sender
{
	[tooltipTwo presentTooltipFromView:buttonTwo arrowDirection:AWTooltipArrowDirectionUp animated:YES];
}
- (IBAction)tapButtonThree:(id)sender
{
	[tooltipThree presentTooltipFromView:buttonThree arrowDirection:AWTooltipArrowDirectionDown animated:YES];
}

#pragma mark - AWTooltipViewDelegate

- (void)tooltipViewTapped:(AWTooltipView *)inTooltipView
{
	NSLog(@"%@", inTooltipView.message);
}

@end
