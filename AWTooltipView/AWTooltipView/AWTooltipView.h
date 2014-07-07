@class AWTooltipView;

typedef enum {
	AWTooltipArrowDirectionUp,
	AWTooltipArrowDirectionDown
} AWTooltipArrowDirection;

@protocol AWTooltipViewDelegate <NSObject>
@optional
- (void)tooltipViewTapped:(AWTooltipView *)inTooltipView;
@end

@interface AWTooltipView : UIView

- (id)initWithMessage:(NSString *)inMessage;

- (void)presentTooltipFromView:(UIView *)inTargetView arrowDirection:(AWTooltipArrowDirection)inArrowDirection animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

@property (weak, nonatomic) id<AWTooltipViewDelegate> delegate;
@property (readonly, nonatomic) NSString *message;
@property (readonly, nonatomic, getter = isTooltipVisible) BOOL tooltipVisible;
@end
