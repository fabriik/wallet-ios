//
//  TransactionsTableViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-16.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class TransactionsTableViewController: UITableViewController, Subscriber, Trackable {

    // MARK: - Public
    init(currency: Currency, wallet: Wallet?, didSelectTransaction: @escaping ([Transaction], Int) -> Void) {
        self.wallet = wallet
        self.currency = currency
        self.didSelectTransaction = didSelectTransaction
        self.showFiatAmounts = Store.state.showFiatAmounts
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        wallet?.unsubscribe(self)
        Store.unsubscribe(self)
    }

    let didSelectTransaction: ([Transaction], Int) -> Void

    var filters: [TransactionFilter] = [] {
        didSet {
            transactions = filters.reduce(allTransactions, { $0.filter($1) })
            tableView.reloadData()
        }
    }
    
    var didScrollToYOffset: ((CGFloat) -> Void)?
    var didStopScrolling: (() -> Void)?

    // MARK: - Private
    var wallet: Wallet? {
        didSet {
            if wallet != nil {
                subscribeToTransactionUpdates()
            }
        }
    }
    private let currency: Currency
    
    private let transactionCellIdentifier = "TransactionCellIdentifier"
    private var transactions: [Transaction] = []
    private var allTransactions: [Transaction] = [] {
        didSet { transactions = allTransactions }
    }
    private var showFiatAmounts: Bool {
        didSet { reload() }
    }
    private var rate: Rate? {
        didSet { reload() }
    }
    private let emptyMessage = UILabel.wrapping(font: .customBody(size: 16.0), color: .grayTextTint)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TxListCell.self, forCellReuseIdentifier: transactionCellIdentifier)

        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never

        let header = SyncingHeaderView(currency: currency)
        header.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40.0)
        tableView.tableHeaderView = header

        emptyMessage.textAlignment = .center
        emptyMessage.text = L10n.TransactionDetails.emptyMessage
        
        setupSubscriptions()
        updateTransactions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Store.trigger(name: .didViewTransactions(transactions))
    }
    
    private func setupSubscriptions() {
        Store.subscribe(self,
                        selector: { $0.showFiatAmounts != $1.showFiatAmounts },
                        callback: { [weak self] state in
                            self?.showFiatAmounts = state.showFiatAmounts
        })
        Store.subscribe(self,
                        selector: { [weak self] oldState, newState in
                            guard let self = self else { return false }
                            return oldState[self.currency]?.currentRate != newState[self.currency]?.currentRate},
                        callback: { [weak self] state in
                            guard let self = self else { return }
                            self.rate = state[self.currency]?.currentRate
        })
        
        Store.subscribe(self, name: .txMetaDataUpdated("")) { [weak self] trigger in
            guard let trigger = trigger else { return }
            if case .txMetaDataUpdated(let txHash) = trigger {
                _ = self?.reload(txHash: txHash)
            }
        }
        subscribeToTransactionUpdates()
    }
    
    private func subscribeToTransactionUpdates() {
        wallet?.subscribe(self) { [weak self] event in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch event {
                case .balanceUpdated, .transferAdded, .transferDeleted:
                    self.updateTransactions()

                case .transferChanged(let transfer),
                     .transferSubmitted(let transfer, _):
                    if let txHash = transfer.hash?.description, self.reload(txHash: txHash) {
                        break
                    }
                    self.updateTransactions()
                default:
                    break
                }
            }
        }
        
        wallet?.subscribeManager(self) { [weak self] event in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if case .blockUpdated = event {
                    self.updateTransactions()
                }
            }
        }
    }

    // MARK: - 

    private func reload() {
        assert(Thread.isMainThread)
        tableView.reloadData()
        if transactions.isEmpty {
            if emptyMessage.superview == nil {
                tableView.addSubview(emptyMessage)
                emptyMessage.constrain([
                    emptyMessage.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                    emptyMessage.topAnchor.constraint(equalTo: tableView.topAnchor, constant: E.isIPhone5 ? 50.0 : AccountHeaderView.headerViewMinHeight),
                    emptyMessage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -C.padding[2]) ])
            }
        } else {
            emptyMessage.removeFromSuperview()
        }
    }

    private func reload(txHash: String) -> Bool {
        assert(Thread.isMainThread)
        
        guard let index = transactions.firstIndex(where: { txHash == $0.hash }) else { return false }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView.endUpdates()
        
        return true
    }
    
    private func updateTransactions() {
        assert(Thread.isMainThread)
        
        guard let transfers = wallet?.transfers else { return }
        allTransactions = transfers.sorted(by: { $0.timestamp > $1.timestamp })
        
        TransferManager.shared.reload { [weak self] exchanges in
            exchanges?.forEach { exchange in
                let source = exchange.source
                let destination = exchange.destination
                let sourceId = source.transactionId
                let destinationId = destination.transactionId
                
                if let element = self?.allTransactions.first(where: { $0.transfer.hash?.description == sourceId || $0.transfer.hash?.description == destinationId }) {
                    // TODO: check if source currency is USD -> buy else swap
                    element.transactionType = exchange.source.isFiat ? .buyTransaction : .swapTransaction
//                    element.transactionType = exchange.type // TODO: Use this logic after backend supports it.
                    element.swapOrderId = exchange.orderId
                    element.swapTransationStatus = exchange.status
                    element.swapSource = exchange.source
                    element.swapDestination = exchange.destination
                }
                self?.reload()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return transactionCell(tableView: tableView, indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTransaction(transactions, indexPath.row)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Cell Builders

extension TransactionsTableViewController {

    private func transactionCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: transactionCellIdentifier,
                                                       for: indexPath) as? TxListCell else { assertionFailure(); return UITableViewCell() }
        
        cell.setTransaction(TxListViewModel(tx: transactions[indexPath.row]),
                            showFiatAmounts: showFiatAmounts,
                            rate: rate ?? Rate.empty,
                            isSyncing: currency.state?.syncState != .success)
        
        return cell
    }
}

extension TransactionsTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollToYOffset?(scrollView.contentOffset.y)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            didStopScrolling?()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didStopScrolling?()
    }
}
