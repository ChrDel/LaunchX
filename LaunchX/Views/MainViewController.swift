//
//  MainViewController.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 14/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxApolloClient
import Apollo

class MainViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var searchButton: UIBarButtonItem!
    @IBOutlet private var searchView: UIStackView!
    @IBOutlet private var searchStackVisibleHeight: NSLayoutConstraint!
    @IBOutlet private var searchStackHiddenHeight: NSLayoutConstraint!
    @IBOutlet private var clearButton: UIButton!
    @IBOutlet private var queryButton: UIButton!
    @IBOutlet private var missionNameField: UITextField!
    @IBOutlet private var rocketNameField: UITextField!
    @IBOutlet private var yearField: UITextField!
    @IBOutlet private var textFields: [UITextField]!
    
    /// To make sure all bindings are freed and we don't have any memory leak.
    private let disposeBag = DisposeBag()
    
    /// View Model for the Main View.
    private let mainViewModel = MainViewModel()
    
    /// Datasource to display launches in the tableView
    lazy private var dataSource: RxTableViewSectionedReloadDataSource<LaunchDataSection> = {
        
        let dataSource = RxTableViewSectionedReloadDataSource<LaunchDataSection>(configureCell: { (_, tableView, indexPath, launchData) -> UITableViewCell in
            
            // I resorted to use the resultMap here and go with a generic array of GraphQLSelectionSet instead of using
            // LaunchListQuery.Data.LaunchesPast and LaunchListQuery.Data.LaunchesUpcoming to have a generic type that can be used in all cases.
            let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as! LaunchCell
            cell.missionName.text = launchData.resultMap["mission_name"] as? String
            cell.rocketName.text = (launchData.resultMap["rocket"] as? [String: String?])?["rocket_name"] as? String
            cell.launchDate.text = (launchData.resultMap["launch_date_local"] as? String)?.localStringToDate?.toLongDateTime ?? "-"
            cell.videoLink.text = (launchData.resultMap["links"] as? [String: String?])?["video_link"] as? String
            return cell
            
        })
        
        return dataSource
        
    }()
    
    /// Setup all Bindings  to the View Model
    fileprivate func bindViews(to mainViewModel: MainViewModel) {
        
        // Link date to tableview using dataSource
        mainViewModel.launches.launchDataSections.asObservable().subscribe(onNext: { [weak self] (observable) in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.dataSource = nil
            observable.bind(to: strongSelf.tableView.rx.items(dataSource: strongSelf.dataSource)).disposed(by: strongSelf.disposeBag)
            
        }).disposed(by: disposeBag)
        
        // Link selected segment index to view model to display the approproate data in the tableView
        segmentedControl.rx.selectedSegmentIndex
            .bind(to: mainViewModel.selection.segmentIndex)
            .disposed(by: disposeBag)
        
        // Hide and show the search area
        searchButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.toggleSearchArea()
            }).disposed(by: disposeBag)
        
        // Limit years to 4 digits
        yearField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] in
            if let text = self?.yearField.text {
                self?.yearField.text = String(text.prefix(4))
            }
        }).disposed(by: disposeBag)
        
        // Close search area and clear all search fields and dismiss keyboard when clear button tapped
        clearButton.rx.tap.subscribe { [weak self] _ in
            guard let strongSelf = self else { return }
            for textField in strongSelf.textFields {
                textField.text = nil
                textField.resignFirstResponder()
            }
            strongSelf.toggleSearchArea()
        }.disposed(by: disposeBag)
        
        // Request all launches data by setting nil to search criteria
        clearButton.rx.tap.map {
            (nil, nil, nil)
        }
        .bind(to: mainViewModel.search.criteria)
        .disposed(by: disposeBag)
        
        // Close search area and dismiss keyboard when search button tapped
        queryButton.rx.tap.subscribe { [weak self] _ in
            guard let strongSelf = self else { return }
            for textField in strongSelf.textFields {
                textField.resignFirstResponder()
            }
            strongSelf.toggleSearchArea()
        }.disposed(by: disposeBag)
        
        // Initiate search for criteria
        queryButton.rx.tap.map { [weak self] in
            (self?.missionNameField.text, self?.rocketNameField.text, self?.yearField.text)
        }
        .bind(to: mainViewModel.search.criteria)
        .disposed(by: disposeBag)
        
        // when cell tapped, play the video friom the URL
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            // begin tableview update to force cell size to change and display the video player.
            self?.tableView.beginUpdates()
            guard let cell = self?.tableView.cellForRow(at: indexPath) as? LaunchCell, let videoLinkText = cell.videoLink.text, !videoLinkText.isEmpty else {
                self?.tableView.endUpdates()
                return
            }
            cell.playVideo()
            self?.tableView.endUpdates()
        }).disposed(by: disposeBag)
        
    }
    
    /// Hides and Shows the search area
    fileprivate func toggleSearchArea() {
        UIView.animate(withDuration: 0.3) {
            self.searchStackVisibleHeight.isActive.toggle()
            self.searchStackHiddenHeight.isActive.toggle()
            self.searchView.alpha = self.searchView.alpha == 0 ? 1 : 0
            self.view.layoutIfNeeded()
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    /// Setup button images and segmented control font
    fileprivate func setupUI() {
        
        searchView.clipsToBounds = true
        
        var configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass", withConfiguration: configuration), for: .normal, barMetrics: .default)
        
        queryButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: configuration), for: .normal)
        
        configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        clearButton.setImage(UIImage(systemName: "clear", withConfiguration: configuration), for: .normal)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViews(to: mainViewModel)
        
    }
    
}
