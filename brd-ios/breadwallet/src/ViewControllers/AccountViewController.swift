//
//  AccountViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-16.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, Subscriber {
    
    // MARK: - Public
    
    var currency: Currency
    
    init(currency: Currency, wallet: Wallet?) {
        self.wallet = wallet
        self.currency = currency
        self.headerView = AccountHeaderView(currency: currency)
        self.footerView = AccountFooterView(currency: currency)
        self.createFooter = CreateAccountFooterView(currency: currency)
        self.searchHeaderview = SearchHeaderView()
        
        super.init(nibName: nil, bundle: nil)
        
        transactionsTableView = TransactionsTableViewController(currency: currency,
                                                                wallet: wallet,
                                                                didSelectTransaction: { [unowned self] (transactions, index) in
            self.didSelectTransaction(transactions: transactions, selectedIndex: index)
        })
        
        footerView.sendCallback = { [unowned self] in
            Store.perform(action: RootModalActions.Present(modal: .send(currency: self.currency))) }
        footerView.receiveCallback = { [unowned self] in
            Store.perform(action: RootModalActions.Present(modal: .receive(currency: self.currency))) }
    }
    
    deinit {
        Store.unsubscribe(self)
    }
    
    // MARK: - Private
    
    private let headerView: AccountHeaderView
    private let footerView: AccountFooterView
    private let createFooter: CreateAccountFooterView
    private var footerHeightConstraint: NSLayoutConstraint?
    private var createFooterHeightConstraint: NSLayoutConstraint?
    private let transitionDelegate = ModalTransitionDelegate(type: .transactionDetail)
    private var transactionsTableView: TransactionsTableViewController?
    private let searchHeaderview: SearchHeaderView
    private let headerContainer = UIView()
    private var loadingTimer: Timer?
    private var isSearching = false
    private var shouldShowStatusBar = true {
        didSet {
            if oldValue != shouldShowStatusBar {
                UIView.animate(withDuration: Presets.Animation.duration) {
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
    }
    
    private var wallet: Wallet? {
        didSet {
            if wallet != nil {
                transactionsTableView?.wallet = wallet
            }
        }
    }
    
    private var createTimeoutTimer: Timer? {
        willSet {
            createTimeoutTimer?.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addSubviews()
        addConstraints()
        addTransactionsView()
        addSubscriptions()
        setInitialData()
        
        transactionsTableView?.didScrollToYOffset = { [weak self] offset in
            self?.headerView.setOffset(offset)
        }
        transactionsTableView?.didStopScrolling = { [weak self] in
            self?.headerView.didStopScrolling()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shouldShowStatusBar = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        wallet?.startGiftingMonitor()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        footerHeightConstraint?.constant = AccountFooterView.height + view.safeAreaInsets.bottom
        createFooterHeightConstraint?.constant = AccountFooterView.height + view.safeAreaInsets.bottom
    }
    
    // MARK: -
    
    private func setupNavigationBar() {
        let searchButton = UIButton(type: .system)
        searchButton.setImage(#imageLiteral(resourceName: "SearchIcon"), for: .normal)
        searchButton.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        searchButton.tintColor = .white
        searchButton.tap = { [unowned self] in
            self.showSearchHeaderView()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }
    
    private func addSubviews() {
        view.addSubview(headerContainer)
        headerContainer.addSubview(headerView)
        headerContainer.addSubview(searchHeaderview)
        view.addSubview(footerView)
        view.addSubview(createFooter)
    }
    
    private func addConstraints() {
        let topConstraint = headerContainer.topAnchor.constraint(equalTo: view.topAnchor)
        topConstraint.priority = .required
        headerContainer.constrain([
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topConstraint,
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        headerView.constrain(toSuperviewEdges: nil)
        searchHeaderview.constrain(toSuperviewEdges: nil)
        
        footerHeightConstraint = footerView.heightAnchor.constraint(equalToConstant: AccountFooterView.height)
        footerView.constrain([
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -C.padding[1]),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: C.padding[1]),
            footerHeightConstraint ])
        
        createFooterHeightConstraint = createFooter.heightAnchor.constraint(equalToConstant: AccountFooterView.height)
        createFooter.constrain([
            createFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            createFooter.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -C.padding[1]),
            createFooter.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: C.padding[1]),
            createFooterHeightConstraint ])
    }
    
    private func addSubscriptions() {
        Store.subscribe(self, name: .showStatusBar, callback: { [weak self] _ in
            self?.shouldShowStatusBar = true
        })
        Store.subscribe(self, name: .hideStatusBar, callback: { [weak self] _ in
            self?.shouldShowStatusBar = false
        })
    }
    
    private func setInitialData() {
        view.clipsToBounds = true
        searchHeaderview.isHidden = true
        searchHeaderview.didCancel = { [weak self] in
            self?.hideSearchHeaderView()
            self?.isSearching = false
        }
        searchHeaderview.didChangeFilters = { [weak self] filters in
            self?.transactionsTableView?.filters = filters
        }
        headerView.setHostContentOffset = { [weak self] offset in
            self?.transactionsTableView?.tableView.contentOffset.y = offset
        }
        
        if currency.isHBAR && wallet == nil {
            createFooter.isHidden = false
        } else {
            createFooter.isHidden = true
        }
        
        createFooter.didTapCreate = { [weak self] in
            let alert = UIAlertController(title: L10n.AccountCreation.title,
                                          message: L10n.AccountCreation.body,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L10n.AccountCreation.notNow, style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: L10n.AccountCreation.create, style: .default, handler: { [weak self] _ in
                self?.createAccount()
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func createAccount() {
        let activity = BRActivityViewController(message: L10n.AccountCreation.creating)
        present(activity, animated: true, completion: nil)
        
        let completion: (Wallet?) -> Void = { [weak self] wallet in
            DispatchQueue.main.async {
                self?.createTimeoutTimer?.invalidate()
                self?.createTimeoutTimer = nil
                activity.dismiss(animated: true, completion: {
                    if wallet == nil {
                        self?.showErrorMessage(L10n.AccountCreation.error)
                    } else {
                        UIView.animate(withDuration: 0.5, animations: {
                            self?.createFooter.alpha = 0.0
                        })
                        Store.perform(action: Alert.Show(.accountCreation))
                        self?.wallet = wallet
                    }
                })
            }
        }
        
        let handleTimeout: (Timer) -> Void = { [weak self] _ in
            activity.dismiss(animated: true, completion: {
                self?.showErrorMessage(L10n.AccountCreation.timeout)
            })
        }
        
        // This could take a while because we're waiting for a transaction to confirm, so we need a decent timeout of 45 seconds.
        createTimeoutTimer = Timer.scheduledTimer(withTimeInterval: 45, repeats: false, block: handleTimeout)
        
        Store.trigger(name: .createAccount(currency, completion))
    }
    
    private func addTransactionsView() {
        if let transactionsTableView = transactionsTableView {
            transactionsTableView.view.backgroundColor = .clear
            view.backgroundColor = .white
            
            addChildViewController(transactionsTableView, layout: {
                transactionsTableView.view.constrain([
                    transactionsTableView.view.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                    transactionsTableView.view.bottomAnchor.constraint(equalTo: footerView.topAnchor),
                    transactionsTableView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    transactionsTableView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
            })
            
            view.sendSubviewToBack(transactionsTableView.view)
            headerView.setExtendedTouchDelegate(transactionsTableView.tableView)
        }
    }
    
    // MARK: keyboard management
    
    private func hideSearchKeyboard() {
        isSearching = searchHeaderview.isFirstResponder
        if isSearching {
            _ = searchHeaderview.resignFirstResponder()
        }
    }
    
    private func showSearchKeyboard() {
        _ = searchHeaderview.becomeFirstResponder()
    }
    
    // MARK: show transaction details
    
    private func didSelectTransaction(transactions: [TxListViewModel], selectedIndex: Int) {
        hideSearchKeyboard()
        
        let transaction = transactions[selectedIndex]
        
        switch transaction.transactionType {
        case .defaultTransaction:
            guard let tx = transactions[selectedIndex].tx else { return }
            let transactionDetails = TxDetailViewController(transaction: tx, delegate: self)
            transactionDetails.modalPresentationStyle = .overCurrentContext
            transactionDetails.transitioningDelegate = transitionDelegate
            transactionDetails.modalPresentationCapturesStatusBarAppearance = true
            
            present(transactionDetails, animated: true)
            
        case .swapTransaction, .buyTransaction:
            let vc = ExchangeDetailsViewController()
            vc.isModalDismissable = false
            vc.dataStore?.itemId = String(transaction.tx?.swapOrderId ?? transaction.swap?.orderId ?? -1)
            vc.dataStore?.transactionType = transaction.transactionType
            
            LoadingView.show()
            navigationController?.pushViewController(viewController: vc, animated: true) {
                LoadingView.hide()
            }
            
        }
    }
    
    private func showSearchHeaderView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        headerView.stopHeightConstraint()
        UIView.animate(withDuration: Presets.Animation.duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        
        UIView.transition(from: headerView,
                          to: searchHeaderview,
                          duration: Presets.Animation.duration,
                          options: [.transitionFlipFromBottom, .showHideTransitionViews, .curveEaseOut],
                          completion: { [weak self] _ in
            self?.searchHeaderview.triggerUpdate()
            self?.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    private func hideSearchHeaderView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        headerView.resumeHeightConstraint()
        UIView.animate(withDuration: Presets.Animation.duration, animations: {
            self.view.layoutIfNeeded()
        })
        
        UIView.transition(from: searchHeaderview,
                          to: headerView,
                          duration: Presets.Animation.duration,
                          options: [.transitionFlipFromTop, .showHideTransitionViews, .curveEaseOut],
                          completion: { [weak self] _ in
            self?.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return searchHeaderview.isHidden ? .lightContent : .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return !shouldShowStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: TxDetailDelegate
extension AccountViewController: TxDetaiViewControllerDelegate {
    func txDetailDidDismiss(detailViewController: TxDetailViewController) {
        if isSearching {
            // Restore the search keyboard that we hid when the transaction details were displayed
            searchHeaderview.becomeFirstResponder()
        }
    }
}
