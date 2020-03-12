//
//  NTANewsViewController.swift
//  NewsTestApp
//
//  Created by Вячеслав on 08/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class NTANewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {//UITableViewController {
    
    @IBOutlet var tableView: UITableView!
    private let refControl = UIRefreshControl()
    
    private var viewModel = NewsViewModel()
    private let rowHeight: CGFloat = 385.0
    private let footerHeight: CGFloat = 80.0
    private let countOfPrefetchedRows: CGFloat = 5.0
    
    let refreshString = "Refreshing..."
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NEWS"
        
        self.setupTableView()
        self.setupViewModel()
        self.setupRefreshControl()
        self.viewModel.initialLoadNews()
    }
    
    func setupTableView() {
        self.tableView!.register(NTANewsTableViewCell.nib(), forCellReuseIdentifier: NTANewsTableViewCell.reuseIdentifier()!)
        self.tableView!.register(NTANoConnectionFooter.nib(), forHeaderFooterViewReuseIdentifier: NTANoConnectionFooter.reuseIdentifier()!)
    }
    
    func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refControl
        } else {
            tableView.addSubview(refControl)
        }
        refControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refControl.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let range = (refreshString as NSString).range(of: refreshString)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        let attributeString = NSMutableAttributedString.init(string: "Refreshing...")
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), range: range)
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        refControl.attributedTitle = attributeString//NSAttributedString(string: "Refreshing...")
    }
    
    func setupViewModel() {
        
        self.viewModel.networkBlock = { status in
            self.stopRefreshControll()
            self.tableView.reloadData()
        }
        
        self.viewModel.errorBlock = { error in
            
            self.stopRefreshControll()
            
            let alert = UIAlertController(title: "ERROR", message: error?.message, preferredStyle: .alert)
            
            let dismiss = UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true)
            })
            
            alert.addAction(dismiss)
            self.present(alert, animated: true)
        }
        
        self.viewModel.updateBlock = {
            self.stopRefreshControll()
            self.tableView.reloadData()
        }
        
        self.viewModel.selectionBlock = { entity in
            let webVC = NTADetailNewsViewController()
            webVC.viewModel = NTANewsDetailViewModel.init(newsEntity: entity as! NTANewsEntity)
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func stopRefreshControll() {
        if (self.refControl.isRefreshing) {
            self.refControl.endRefreshing()
        }
    }
    
    // MARK: - ACTION
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        self.viewModel.updateNews()
    }
    
    @objc private func retryConnection(_ sender: Any) {
        self.viewModel.loadNews()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel.getNewsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NTANewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: NTANewsTableViewCell.reuseIdentifier()!, for: indexPath) as! NTANewsTableViewCell
        
        let cellViewModel = self.viewModel.cellViewModel(atIndexPath: indexPath)
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (!self.viewModel.isConnected) {
            let footerView: NTANoConnectionFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: NTANoConnectionFooter.reuseIdentifier()!) as! NTANoConnectionFooter
            footerView.retryButton.addTarget(self, action: #selector(retryConnection(_:)), for: UIControl.Event.touchUpInside)
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.viewModel.isConnected ? 0.0 : footerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = self.viewModel.cellViewModel(atIndexPath: indexPath)
        if cellViewModel.selectBlock != nil {
            cellViewModel.selectBlock!()
        }
    }
    
    //    MARK: - UIScrollViewDelegate
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let maximumOffset = scrollView.contentSize.height - self.rowHeight * self.countOfPrefetchedRows
        
        if (targetContentOffset.pointee.y >= maximumOffset) && (targetContentOffset.pointee.y > 0) {
            self.viewModel.loadNews()
        }
    }
}
