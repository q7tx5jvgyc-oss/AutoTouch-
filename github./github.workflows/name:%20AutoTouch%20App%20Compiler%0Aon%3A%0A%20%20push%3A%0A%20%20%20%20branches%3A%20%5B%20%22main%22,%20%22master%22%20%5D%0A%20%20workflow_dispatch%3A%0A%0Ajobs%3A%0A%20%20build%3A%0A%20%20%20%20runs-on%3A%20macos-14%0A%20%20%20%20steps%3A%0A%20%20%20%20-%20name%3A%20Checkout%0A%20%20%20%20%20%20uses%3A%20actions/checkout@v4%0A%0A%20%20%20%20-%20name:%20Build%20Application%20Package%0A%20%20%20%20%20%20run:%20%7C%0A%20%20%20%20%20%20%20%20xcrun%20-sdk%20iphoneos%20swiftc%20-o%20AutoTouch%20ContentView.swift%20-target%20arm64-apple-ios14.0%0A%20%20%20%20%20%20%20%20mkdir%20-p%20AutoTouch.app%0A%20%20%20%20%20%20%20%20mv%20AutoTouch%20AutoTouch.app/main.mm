#import <UIKit/UIKit.h>

@interface AutoTouchWindow : UIWindow
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UISlider *speedSlider;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, assign) BOOL isRunning;
@end

@implementation AutoTouchWindow

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 10;
        self.backgroundColor = [UIColor clearColor];
        [self setHidden:NO];
        self.isRunning = NO;
        [self createFloatingButton];
        [self createMenuView];
    }
    return self;
}

- (void)createFloatingButton {
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = CGRectMake(50, 150, 60, 60);
    self.floatingButton.backgroundColor = [UIColor systemBlueColor];
    self.floatingButton.layer.cornerRadius = 30;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingButton addGestureRecognizer:pan];
    [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.floatingButton];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:self];
}

- (void)createMenuView {
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
    self.menuView.center = self.center;
    self.menuView.backgroundColor = [[UIColor systemBackgroundColor] colorWithAlphaComponent:0.95];
    self.menuView.layer.cornerRadius = 20;
    self.menuView.hidden = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 260, 25)];
    titleLabel.text = @"لوحة تحكم الأوتو";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.menuView addSubview:titleLabel];

    self.toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.toggleButton.frame = CGRectMake(20, 60, 240, 50);
    self.toggleButton.backgroundColor = [UIColor systemGreenColor];
    [self.toggleButton setTitle:@"▶️ تشغيل الأوتو" forState:UIControlStateNormal];
    [self.toggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.toggleButton.layer.cornerRadius = 12;
    [self.toggleButton addTarget:self action:@selector(toggleAutoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.toggleButton];

    self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 240, 20)];
    self.speedLabel.text = @"سرعة النقر: 1.0 ثانية";
    [self.menuView addSubview:self.speedLabel];

    self.speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 160, 240, 30)];
    self.speedSlider.minimumValue = 0.1;
    self.speedSlider.maximumValue = 5.0;
    self.speedSlider.value = 1.0;
    [self.speedSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menuView addSubview:self.speedSlider];

    [self addSubview:self.menuView];
}

- (void)toggleMenu { self.menuView.hidden = !self.menuView.hidden; }
- (void)toggleAutoClick { self.isRunning = !self.isRunning; }
- (void)sliderChanged:(UISlider *)sender { self.speedLabel.text = [NSString stringWithFormat:@"سرعة النقر: %.1f ثانية", sender.value]; }
@end

static void __attribute__((constructor)) initialize(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static AutoTouchWindow *window = nil;
        window = [[AutoTouchWindow alloc] init];
    });
}
