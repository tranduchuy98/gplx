
import UIKit
import RxSwift
import RxCocoa

public let kWindow                = UIApplication.shared.windows[0]
public let kScreenWidth           = UIScreen.main.bounds.size.width
public let kScreenHeight          = UIScreen.main.bounds.size.height
public let kSafeAreaTopPadding    = kWindow.safeAreaInsets.top
public let kSafeAreaBottomPadding = kWindow.safeAreaInsets.bottom

struct NavigationSetting {
    var title: String? = nil
    var isHiddenTabbar: Bool = false
    var isHiddenNavigation: Bool = false
    var backImage: String = "ic_arrow_left"
    var navigationColor: UIColor = StyleKit.MainColorNavigationBar
    var navigationShadow: UIImage? = nil
    var rightButtons: [UIBarButtonItem]? = nil
    var leftButtons: [UIBarButtonItem]? = nil
}

extension NavigationSetting {
    
    static func singleTitle(_ title: String) -> Self {
        let lblTitle = UILabel()
        lblTitle.font = UIFont.appxmLargeMedium
        lblTitle.text = " \(title)"
        lblTitle.textAlignment = .left
        lblTitle.textColor = .white
        
        return NavigationSetting(
            isHiddenTabbar: false,
            isHiddenNavigation: false,
            leftButtons: [UIBarButtonItem(customView: lblTitle)]
        )
    }

}

class BaseViewController<T: ViewModelProtocol>: UIViewController, UseViewModel, UIGestureRecognizerDelegate {
    public typealias Model = T
    var disposeBag = DisposeBag()
    var viewModel: Model!
    var bottomConstraint: NSLayoutConstraint?
    
    var refreshControl = UIRefreshControl()
    var triggerReload = PublishSubject<Void>()
    
    var isLoading: Bool = false
    
    public var setting: NavigationSetting {
        let button = UIButton(type: .custom)
        button.setImage(Asset.Icon.icArrowLeft.image, for: .normal)
        button.titleLabel?.font = UIFont.appxmLargeMedium
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        button.sizeToFit()
        
        return NavigationSetting(
            isHiddenTabbar: true,
            isHiddenNavigation: false,
            leftButtons: [UIBarButtonItem(customView: button)]
        )
    }
    
    public func defaultNav(_ title: String, tinColor: UIColor = .black) -> NavigationSetting {
        let button = UIButton(type: .custom)
        button.setImage(Asset.Icon.icArrowLeft.image, for: .normal)
        button.tintColor = tinColor
        button.titleLabel?.font = UIFont.appxmLargeMedium
        button.setTitle(" \(title)", for: .normal)
        button.setTitleColor(tinColor, for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        button.sizeToFit()
        
        return NavigationSetting(
            isHiddenTabbar: true,
            isHiddenNavigation: false,
            leftButtons: [UIBarButtonItem(customView: button)]
        )
    }
    
    open func bind(to model: Model) {
        self.viewModel = model
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.rx.controlEvent(.valueChanged).mapToVoid()
            .bind(to: triggerReload)
            .disposed(by: disposeBag)
        initData()
        configUI()
        configRx()
        bind()
        extendedLayoutIncludesOpaqueBars = true
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func viewDidBecomeActive() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavigation()
        navigationController?.navigationBar.isHidden = setting.isHiddenNavigation
        tabBarController?.tabBar.isHidden = setting.isHiddenTabbar
        tabBarController?.tabBar.backgroundColor = .white
        tabBarController?.tabBar.tintColor = UIColor(hex: "#14307C")
    }
    
    func showAlertWithConfirmation(title: String, message: String, confirmActionTitle: String, cancelActionTitle: String, confirmHandler: @escaping () -> Void, cancelHandler: (() -> Void)? = nil) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default) { _ in
                confirmHandler()
            }

            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel) { _ in
                cancelHandler?()
            }

            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
        }
    
    func initData() {}
    func configUI() {}
    func configRx() {}
    func bind() {}

    
    private func styleNavigation() {
        if let leftButtons = setting.leftButtons {
            navigationItem.leftBarButtonItems = leftButtons
        } else {
            navigationItem.leftBarButtonItems = nil
        }
        
        if let rightButtons = setting.rightButtons {
            navigationItem.rightBarButtonItems = rightButtons
        } else {
            navigationItem.rightBarButtonItems = nil
        }
        let titleLabel = UILabel()
        titleLabel.text = setting.title ?? ""
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
    }

    
    @objc func backAction() {
        if viewModel != nil {
            viewModel.back()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func handleKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.bottomConstraint?.constant = 10.0
        } else {
            if #available(iOS 11.0, *) {
                self.bottomConstraint?.constant = (endFrame?.size.height ?? 0.0) - self.view.safeAreaInsets.bottom + 10
            } else {
                self.bottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }
        }
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
    
    //Pannable
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.5
    public var animationDuration: TimeInterval = 0.2
    
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }
    
    func addPannable() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
            
        case .began, .changed:
            // If pan started or is ongoing then
            // slide the view to follow the finger
            let translation = panGesture.translation(in: view)
            let y = max(0, translation.y)
            slideViewVerticallyTo(y)
            
        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > self.view.frame.size.height * minimumScreenRatioToHide) ||
            (velocity.y > minimumVelocityToHide)
            
            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                    self.slideViewVerticallyTo(self.view.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        // Dismiss the view when it dissapeared
                        self.viewModel.dismissViewNoAnimated()
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ConstantKeys.RefreshFeatured), object: nil)
                    }
                })
            } else {
                // If not closing, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(0)
                })
            }
            
        default:
            // If gesture state is undefined, reset the view to the top
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(0)
            })
            
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = otherGestureRecognizer.view as? UIScrollView {
            return scrollView.contentOffset.x == 0
        }
        return false
    }
}
