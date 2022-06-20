//
//  VIPViewController.swift
//  
//
//  Created by Rok Cresnik on 01/12/2021.
//

import UIKit
import SnapKit

class VIPViewController<C: CoordinatableRoutes,
                        I: Interactor,
                        P: Presenter,
                        DS: BaseDataStore & NSObject>: UIViewController,
                                                       UIAdaptivePresentationControllerDelegate,
                                                       Controller,
                                                       BaseDataPassing,
                                                       BaseResponseDisplays,
                                                       ModalDismissable,
                                                       Blurrable {
    
    // MARK: Title and tab bar appearance
    var sceneTitle: String? { return nil }
    var sceneLeftAlignedTitle: String? { return nil }
    var tabIcon: UIImage? { return nil }
    
    lazy var leftAlignedTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.Title.four
        view.textAlignment = .left
        view.textColor = LightColors.Icons.one
        return view
    }()
    
    // MARK: Modal dimissable
    var isModalDismissableEnabled: Bool { return false }
    var dismissText: String { return "" }

    var isRootInNavigationController: Bool {
        guard let navigationController = navigationController else { return true }
        return navigationController.viewControllers.first === self
    }

    // MARK: VIP
    weak var coordinator: C?
    var interactor: I?
    var dataStore: DS? {
        return interactor?.dataStore as? DS
    }
    
    lazy var blurView: UIVisualEffectView? = {
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurView
    }()

    // MARK: Initialization
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setupVIP()
    }

    func setupVIP() {
        interactor = I()
        let presenter = P()
        let dataStore = DS()
        presenter.viewController = self as? P.ResponseDisplays
        interactor?.presenter = presenter as? I.ActionResponses
        interactor?.dataStore = dataStore as? I.Store

        setupSubviews()
        localize()
    }

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isModalDismissableEnabled {
            setupAsVIPModalDismissable(closeAction: #selector(dismissModal))
        }
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        parent?.presentationController?.delegate = self
        guard parent == nil else { return }

        coordinator?.goBack()
    }

    func setupAsVIPModalDismissable(closeAction: Selector) {
        guard isRootInNavigationController else { return }
        setupCloseButton(closeAction: closeAction)
    }

    func setupCloseButton(closeAction: Selector) {
        guard navigationItem.leftBarButtonItem?.title != dismissText,
              navigationItem.rightBarButtonItem?.title != dismissText
        else { return }

        let closeButton = UIBarButtonItem(title: dismissText,
                                          style: .plain,
                                          target: self,
                                          action: closeAction)

        guard navigationItem.rightBarButtonItem == nil else {
            navigationItem.setLeftBarButton(closeButton, animated: false)
            return
        }
        navigationItem.setRightBarButton(closeButton, animated: false)
    }

    @objc func dismissModal() {
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.coordinator?.goBack()
        })
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        coordinator?.goBack()
    }

    func setupSubviews() {
        tabBarItem.image = tabIcon
    }

    func localize() {
        tabBarItem.title = sceneTitle
        title = sceneTitle
        leftAlignedTitleLabel.text = sceneLeftAlignedTitle
    }
    
    func prepareData() {}

    // MARK: BaseResponseDisplay
    func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        coordinator?.showMessage(with: responseDisplay.model, configuration: responseDisplay.config)
    }
    
    func hideNotification(notification: UIView) {
        coordinator?.hideMessage(notification)
    }
    // MARK: - Blurrable
    func toggleBlur(animated: Bool) {
        guard let blurView = blurView else { return }
        guard blurView.superview == nil else {
            UIView.animate(withDuration: animated ? Presets.Animation.duration: 0) {
                blurView.alpha = 0
            } completion: { _ in
                blurView.removeFromSuperview()
            }
            return
        }
        
        blurView.alpha = 0
        blurView.frame = view.bounds
        view.addSubview(blurView)
        UIView.animate(withDuration: animated ? Presets.Animation.duration: 0) {
            blurView.alpha = 1
        }
    }
}

protocol ModalDismissable {
    var dismissText: String { get }

    func setupAsVIPModalDismissable(closeAction: Selector)
    func setupCloseButton(closeAction: Selector)
}

protocol Blurrable: UIViewController {
    var blurView: UIVisualEffectView? { get }
    
    func toggleBlur(animated: Bool)
}
