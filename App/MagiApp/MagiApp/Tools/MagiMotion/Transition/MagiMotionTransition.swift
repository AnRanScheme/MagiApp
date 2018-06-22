//
//  MagiMotionTransition.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/4.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

@objc(MagiMotionViewControllerDelegate)
public protocol MagiMotionViewControllerDelegate {
    
    
    /// An optional delegation method that is executed motion will start the transition.
    ///
    /// - Parameter motion: 一个MagiMotionTransition实例.
    @objc
    optional func motionWillStartTransition(motion: MagiMotionTransition)
    
    /// An optional delegation method that is executed motion did end the transition.
    ///
    /// - Parameter motion: 一个MagiMotionTransition实例.
    @objc
    optional func motionDidEndTransition(motion: MagiMotionTransition)
    
    /// An optional delegation method that is executed motion did cancel the transition.
    ///
    /// - Parameter motion: 一个MagiMotionTransition实例.
    @objc
    optional func motionDidCancelTransition(motion: MagiMotionTransition)
    
    
    /// An optional delegation method that is executed when the source
    /// view controller will start the transition.
    ///
    /// - Parameters:
    ///   - motion: 一个MagiMotionTransition实例.
    ///   - viewController: A UIViewController.
    @objc
    optional func motion(motion: MagiMotionTransition, willStartTransitionFrom viewController: UIViewController)
    
    /// An optional delegation method that is executed when the source
    /// view controller did end the transition.
    ///
    /// - Parameters:
    ///   - motion: 一个MagiMotionTransition实例.
    ///   - viewController: A UIViewController.
    @objc
    optional func motion(motion: MagiMotionTransition, didEndTransitionFrom viewController: UIViewController)
    
    /// An optional delegation method that is executed when the source
    /// view controller did cancel the transition.
    ///
    /// - Parameters:
    ///   - motion: 一个MagiMotionTransition实例.
    ///   - viewController: A UIViewController.
    @objc
    optional func motion(motion: MagiMotionTransition, didCancelTransitionFrom viewController: UIViewController)
    
    /// An optional delegation method that is executed when the source
    /// view controller will start the transition.
    ///
    /// - Parameters:
    ///   - motion: 一个MagiMotionTransition实例.
    ///   - viewController: A UIViewController.
    @objc
    optional func motion(motion: MagiMotionTransition, willStartTransitionTo viewController: UIViewController)
    
    /// An optional delegation method that is executed when the source
    /// view controller did end the transition.
    ///
    /// - Parameters:
    ///   - motion: 一个MagiMotionTransition实例.
    ///   - viewController: A UIViewController.
    @objc
    optional func motion(motion: MagiMotionTransition, didEndTransitionTo viewController: UIViewController)
    
    /// An optional delegation method that is executed when the source
    /// view controller did cancel the transition.
    ///
    /// - Parameters:
    ///   - motion: 一个MagiMotionTransition实例.
    ///   - viewController: A UIViewController.
    @objc
    optional func motion(motion: MagiMotionTransition, didCancelTransitionTo viewController: UIViewController)
    
    
}

/**
 ### The singleton class/object for controlling interactive transitions.
 
 ```swift
 Motion.shared
 ```
 
 #### Use the following methods for controlling the interactive transition:
 
 ```swift
 func update(progress: Double)
 func end()
 func cancel()
 func apply(transitions: [MagiMotionTargetState], to view: UIView)
 ```
 */

public typealias MagiMotionCancelBlock = (Bool) -> Void

public class MagiMotion: NSObject {
    /// Shared singleton object for controlling the transition
    public static let shared = MagiMotion()
}

extension MagiMotion {
    
    /// Executes a block of code asynchronously on the main thread.
    ///
    /// - Parameter execute: A block that is executed asynchronously on the main thread.
    public class func async(_ execute: @escaping () -> Void) {
        DispatchQueue.main.async(execute: execute)
    }
    
    /// Executes a block of code after a time delay.
    ///
    /// - Parameters:
    ///   - time: A delay time.
    ///   - execute: A block that is executed once delay has passed.
    /// - Returns: An optional MagiMotionCancelBlock.
    @discardableResult
    public class func delay(_ time: TimeInterval, execute: @escaping () -> Void) -> MagiMotionCancelBlock? {
        
        var cancelable: MagiMotionCancelBlock?
        
        let delayed: MagiMotionCancelBlock = {
            if !$0 {
                async(execute)
            }
            cancelable = nil
        }
        
        cancelable = delayed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            cancelable?(false)
        }
        
        return cancelable
    }
    
    /// Cancels the delayed MotionCancelBlock.
    ///
    /// - Parameter completion: An MotionCancelBlock.
    public class func cancel(delayed completion: MagiMotionCancelBlock) {
        completion(true)
    }

    /// Disables the default animations set on CALayers.
    ///
    /// - Parameter animations: A callback that wraps the animations to disable.
    public class func disable(_ animations: (() -> Void)) {
        animate(duration: 0, animations: animations)
    }
    
    /// CATransaction 事务 对于layer的属性操作 添加动画
    /// Runs an animation with a specified duration.
    ///
    /// - Parameters:
    ///   - duration: An animation duration time.
    ///   - timingFunction: A CAMediaTimingFunction.
    ///   - animations: An animation block.
    ///   - completion: A completion block that is executed once
    ///     the animations have completed.
    public class func animate(duration: CFTimeInterval, timingFunction: CAMediaTimingFunction = .easeInOut, animations: (()->Void), completion: (()->Void)? = nil) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock(completion)
        CATransaction.setAnimationTimingFunction(timingFunction)
        animations()
        CATransaction.commit()
    }
    
    /// Creates a CAAnimationGroup.
    ///
    /// - Parameters:
    ///   - animations: An Array of CAAnimation objects.
    ///   - timingFunction: A CAMediaTimingFunction.
    ///   - duration: An animation duration time for the group.
    /// - Returns: a CAAnimationGroup.
    public class func animate(group animations: [CAAnimation], timingFunction: CAMediaTimingFunction = .easeInOut, duration: CFTimeInterval = 0.5) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.fillMode = MagiMotionAnimationFillModeToValue(mode: .both)
        group.isRemovedOnCompletion = false
        group.animations = animations
        group.duration = duration
        group.timingFunction = timingFunction
        return group
    }
    
}


public enum MagiMotionTransitionState: Int {
    /// MagiMotion is able to start a new transition.
    case possible
    
    /// UIKit has notified MagiMotion about a pending transition.
    /// MagiMotion hasn't started preparation.
    case notified
    
    /// MagiMotion's `start` method has been called. Preparing the animation.
    case starting
    
    /// MagiMotion's `animate` method has been called. Animation has started.
    case animating
    
    /// MagiMotion's `complete` method has been called. Transition has ended or has
    /// been cancelled. Motion is cleaning up.
    case completing
}


open class MagiMotionTransition: NSObject {
    /// Shared singleton object for controlling the transition
    public static let shared = MagiMotionTransition()
    
    /// Default animation type.
    internal var defaultAnimation = MagiMotionTransitionAnimationType.auto
    
    /// The color of the transitioning container.
    internal var containerBackgroundColor = UIColor.black
    
    /// A boolean indicating if the user may interact with the
    /// view controller while in transition.
    public var isUserInteractionEnabled = false
    
    /// A reference to the MagiMotionViewOrderStrategy.
    public var viewOrderStrategy = MagiMotionViewOrderStrategy.auto
    
    public internal(set) var state = MagiMotionTransitionState.possible {
        didSet{
            guard state != .notified, state != .starting else {
                return
            }
            beginCallback?(.animating == state)
            beginCallback = nil
        }
    }
    
    /// A boolean indicating whether a transition is active.
    public var isTransitioning: Bool {
        return state != .possible
    }
    
    /// Whether or not we are presenting the destination view controller.
    public internal(set) var isPresenting = true
    
    /// A boolean indicating whether the transition interactive or not.
    public var isInteractive: Bool {
        return !progressRunner.isRunning
    }
    
    /**
     A view container used to hold all the animating views during a
     transition.
     */
    public internal(set) var container: UIView!
    
    /// UIKit's supplied transition container.
    internal var transitionContainer: UIView?
    
    /// An optional begin callbcak.
    internal var beginCallback: ((Bool) -> Void)?
    
    /// An optional completion callback.
    internal var completionCallback: ((Bool) -> Void)?
    
    /// An Array of MotionPreprocessors used during a transition.
    internal lazy var preprocessors = [MagiMotionPreprocessor]()
    
    /// An Array of MotionAnimators used during a transition.
    internal lazy var animators = [MagiMotionAnimator]()
    
    /// An Array of MotionPlugins used during a transition.
    internal lazy var plugins = [MagiMotionPlugin]()
    
    /// The matching fromViews to toViews based on the motionIdentifier value.
    internal var animatingFromViews = [UIView]()
    internal var animatingToViews = [UIView]()
    
    /// Plugins that are enabled during the transition.
    internal static var enabledPlugins = [MagiMotionPlugin.Type]()
    
    /// Source view controller.
    public internal(set) var fromViewController: UIViewController?
    
    /// A reference to the fromView, fromViewController.view.
    internal var fromView: UIView? {
        return fromViewController?.view
    }
    
    /// Destination view controller.
    public internal(set) var toViewController: UIViewController?
    
    /// A reference to the toView, toViewController.view.
    internal var toView: UIView? {
        return toViewController?.view
    }
    
    /// A reference to the MagiMotionContext.
    public internal(set) var context: MagiMotionContext!
    
    /// An Array of observers that are updated during a transition.
    internal var transitionObservers: [MagiMotionTargetStateObserver]?
    
    /// Max duration used by MotionAnimators and MotionPlugins.
    public internal(set) var totalDuration: TimeInterval = 0
    
    /// Progress of the current transition. 0 if no transition is happening.
    public internal(set) var progress: TimeInterval = 0 {
        didSet {
            guard .animating == state else {
                return
            }
            
            updateTransitionObservers()
            
            if isInteractive {
                updateAnimators()
            } else {
                updatePlugins()
            }
            
            transitionContext?.updateInteractiveTransition(CGFloat(progress))
        }
    }
    
    /// A reference to a MotionProgressRunner.
    lazy var progressRunner: MagiMotionProgressRunner = {
        let runner = MagiMotionProgressRunner()
        runner.delegate = self
        return runner
    }()
    
    /**
     A UIViewControllerContextTransitioning object provided by UIKit, which
     might be nil when isTransitioning. This happens when calling motionReplaceViewController
     */
    internal weak var transitionContext: UIViewControllerContextTransitioning?
    
    /// A reference to a fullscreen snapshot.
    internal var fullScreenSnapshot: UIView?
    
    /**
     By default, Motion will always appear to be interactive to UIKit. This forces it to appear non-interactive.
     Used when doing a motionReplaceViewController within a UINavigationController, to fix a bug with
     UINavigationController.setViewControllers not able to handle interactive transitions.
     */
    internal var forceNonInteractive = false
    internal var forceFinishing: Bool?
    internal var startingProgress: TimeInterval?
    
    /// Indicates whether a UINavigationController is transitioning.
    internal var isNavigationController = false
    
    /// Indicates whether a UITabBarController is transitioning.
    internal var isTabBarController = false
    
    /// Indicates whether a UINavigationController or UITabBarController is transitioning.
    internal var isContainerController: Bool {
        return isNavigationController || isTabBarController
    }
    
    /// Indicates whether the to view controller is full screen.
    internal var toOverFullScreen: Bool {
        return !isContainerController && (toViewController?.modalPresentationStyle == .overFullScreen || toViewController?.modalPresentationStyle == .overCurrentContext)
    }
    
    /// Indicates whether the from view controller is full screen.
    internal var fromOverFullScreen: Bool {
        return !isContainerController && (fromViewController?.modalPresentationStyle == .overFullScreen || fromViewController?.modalPresentationStyle == .overCurrentContext)
    }
    
    /// An initializer.
    internal override init() {
        super.init()
    }
    
    /**
     Complete the transition.
     - Parameter after: A TimeInterval.
     - Parameter isFinishing: A Boolean indicating if the transition
     has completed.
     */
    func complete(after: TimeInterval, isFinishing: Bool) {
        guard [MagiMotionTransitionState.animating, .starting, .notified].contains(state) else {
            return
        }
        
        if after <= 1.0 / 120 {
            complete(isFinishing: isFinishing)
            return
        }
        
        let duration = after / (isFinishing ? max((1 - progress), 0.01) : max(progress, 0.01))
        
        progressRunner.start(progress: progress * duration, duration: duration, isReversed: !isFinishing)
    }
  
}

extension MagiMotionTransition: MagiMotionProgressRunnerDelegate {
    func update(progress: TimeInterval) {
        self.progress = progress
    }
}

extension MagiMotionTransition {
    /**
     Receive callbacks on each animation frame.
     Observers will be cleaned when a transition completes.
     - Parameter observer: A MotionTargetStateObserver.
     */
    func addTransitionObserver(observer: MagiMotionTargetStateObserver) {
        if nil == transitionObservers {
            transitionObservers = []
        }
        
        transitionObservers?.append(observer)
    }
}

fileprivate extension MagiMotionTransition {
    /// Updates the transition observers.
    func updateTransitionObservers() {
        guard let observers = transitionObservers else {
            return
        }
        
        for v in observers {
            v.motion(transitionObserver: v, didUpdateWith: progress)
        }
    }
    
    /// Updates the animators.
    func updateAnimators() {
        let t = progress * totalDuration
        for v in animators {
            v.seek(to: t)
        }
    }
    
    /// Updates the plugins.
    func updatePlugins() {
        let t = progress * totalDuration
        for v in plugins where v.requirePerFrameCallback {
            v.seek(to: t)
        }
    }
}

internal extension MagiMotionTransition {
    /**
     Checks if a given plugin is enabled.
     - Parameter plugin: A MotionPlugin.Type.
     - Returns: A boolean indicating if the plugin is enabled or not.
     */
    static func isEnabled(plugin: MagiMotionPlugin.Type) -> Bool {
        return nil != enabledPlugins.index(where: { return $0 == plugin })
    }
    
    /**
     Enables a given plugin.
     - Parameter plugin: A MotionPlugin.Type.
     */
    static func enable(plugin: MagiMotionPlugin.Type) {
        disable(plugin: plugin)
        enabledPlugins.append(plugin)
    }
    
    /**
     Disables a given plugin.
     - Parameter plugin: A MotionPlugin.Type.
     */
    static func disable(plugin: MagiMotionPlugin.Type) {
        guard let index = enabledPlugins.index(where: { return $0 == plugin }) else {
            return
        }
        
        enabledPlugins.remove(at: index)
    }
}

public extension MagiMotionTransition {
    /// Turn off built-in animations for the next transition.
    func disableDefaultAnimationForNextTransition() {
        defaultAnimation = .none
    }
    
    /**
     Set the default animation for the next transition. This may override the
     root-view's motionModifiers during the transition.
     - Parameter animation: A MotionTransitionAnimationType.
     */
    func setAnimationForNextTransition(_ animation: MagiMotionTransitionAnimationType) {
        defaultAnimation = animation
    }
    
    /**
     Set the container background color for the next transition.
     - Parameter _ color: A UIColor.
     */
    func setContainerBackgroundColorForNextTransition(_ color: UIColor) {
        containerBackgroundColor = color
    }
}

internal extension MagiMotionTransition {
    /**
     Processes the start transition delegation methods.
     - Parameter fromViewController: An optional UIViewController.
     - Parameter toViewController: An optional UIViewController.
     */
    func processStartTransitionDelegation(fromViewController: UIViewController?, toViewController: UIViewController?) {
        guard let fvc = fromViewController else {
            return
        }
        
        guard let tvc = toViewController else {
            return
        }
        
        fvc.beginAppearanceTransition(false, animated: true)
        tvc.beginAppearanceTransition(true, animated: true)
        
        processForMotionDelegate(viewController: fvc) { [weak self] in
            guard let `self` = self else {
                return
            }
            
            $0.motion?(motion: self, willStartTransitionTo: tvc)
            $0.motionWillStartTransition?(motion: self)
        }
        
        processForMotionDelegate(viewController: tvc) { [weak self] in
            guard let `self` = self else {
                return
            }
            
            $0.motion?(motion: self, willStartTransitionFrom: fvc)
            $0.motionWillStartTransition?(motion: self)
        }
    }
    
    /**
     Processes the end transition delegation methods.
     - Parameter transitionContext: An optional UIViewControllerContextTransitioning.
     - Parameter fromViewController: An optional UIViewController.
     - Parameter toViewController: An optional UIViewController.
     */
    func processEndTransitionDelegation(transitionContext: UIViewControllerContextTransitioning?, fromViewController: UIViewController?, toViewController: UIViewController?) {
        guard let fvc = fromViewController else {
            return
        }
        
        guard let tvc = toViewController else {
            return
        }
        
        tvc.endAppearanceTransition()
        fvc.endAppearanceTransition()
        
        processForMotionDelegate(viewController: fvc) { [weak self] in
            guard let `self` = self else {
                return
            }
            
            $0.motion?(motion: self, didEndTransitionTo: tvc)
            $0.motionDidEndTransition?(motion: self)
        }
        
        processForMotionDelegate(viewController: tvc) { [weak self] in
            guard let `self` = self else {
                return
            }
            
            $0.motion?(motion: self, didEndTransitionFrom: fvc)
            $0.motionDidEndTransition?(motion: self)
        }
        
        transitionContext?.finishInteractiveTransition()
    }
    
    /**
     Processes the cancel transition delegation methods.
     - Parameter transitionContext: An optional UIViewControllerContextTransitioning.
     - Parameter fromViewController: An optional UIViewController.
     - Parameter toViewController: An optional UIViewController.
     */
    func processCancelTransitionDelegation(transitionContext: UIViewControllerContextTransitioning?, fromViewController: UIViewController?, toViewController: UIViewController?) {
        guard let fvc = fromViewController else {
            return
        }
        
        guard let tvc = toViewController else {
            return
        }
        
        tvc.endAppearanceTransition()
        fvc.endAppearanceTransition()
        
        processForMotionDelegate(viewController: fvc) { [weak self] in
            guard let `self` = self else {
                return
            }
            
            $0.motion?(motion: self, didCancelTransitionTo: tvc)
            $0.motionDidCancelTransition?(motion: self)
        }
        
        processForMotionDelegate(viewController: tvc) { [weak self] in
            guard let `self` = self else {
                return
            }
            
            $0.motion?(motion: self, didCancelTransitionFrom: fvc)
            $0.motionDidCancelTransition?(motion: self)
        }
        
        transitionContext?.finishInteractiveTransition()
    }
}

internal extension MagiMotionTransition {
    /**
     Helper for processing the MotionViewControllerDelegate.
     - Parameter viewController: A UIViewController of type `T`.
     - Parameter execute: A callback for execution during processing.
     */
    func processForMotionDelegate<T: UIViewController>(viewController: T, execute: (MagiMotionViewControllerDelegate) -> Void) {
        if let delegate = viewController as? MagiMotionViewControllerDelegate {
            execute(delegate)
        }
        
        if let v = viewController as? UINavigationController,
            let delegate = v.topViewController as? MagiMotionViewControllerDelegate {
            execute(delegate)
        }
        
        if let v = viewController as? UITabBarController,
            let delegate = v.viewControllers?[v.selectedIndex] as? MagiMotionViewControllerDelegate {
            execute(delegate)
        }
    }
}

