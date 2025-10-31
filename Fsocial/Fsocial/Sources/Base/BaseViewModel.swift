//
//  File.swift
//  Fsocial
//
//  Created by Huy Tran on 14/8/24.
//


import Foundation
import RxSwift
import RxDataSources
import MobileBase
import UIKit


protocol ViewModelProtocol {
    associatedtype RouteType: Route
    var router: WeakRouter<RouteType> { get }
    var disposeBag: DisposeBag { get set }
    init(with router: WeakRouter<RouteType>)
    func back()
    func dismissViewNoAnimated()
    func dismissAnimated()
}


class BaseViewModel: MViewModel, ViewModelProtocol {
    public typealias RouteType = AppRoute
    public var router: WeakRouter<AppRoute>
    public var disposeBag: DisposeBag = DisposeBag()
   // public let errorTracker = ErrorTracker()

    required public init(with router: WeakRouter<AppRoute>) {
        self.router = router
    }
    
    func back() {
        router.trigger(.pop)
    }
    
    func dismissViewNoAnimated() {
        router.trigger(.dismiss)
    }
    
    func dismissAnimated() {
        router.trigger(.dismiss, with: .init(animated: true))
    }
}

extension UseViewModel where Self: UIViewController {
    static func newInstance(with viewModel: Model) -> Self {
        let viewController = self.initFromNib()
        viewController.bind(to: viewModel)
        return viewController
    }
    
    static func newInstance() -> Self {
        return self.initFromNib()
    }
}

protocol UseViewModel {
    associatedtype Model
    var viewModel: Model! { get set }
    func bind(to model: Model)
}
