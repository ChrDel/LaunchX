//
//  LaunchCell.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 14/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import youtube_ios_player_helper

class LaunchCell: UITableViewCell {
    
    @IBOutlet var missionName: UILabel!
    @IBOutlet var rocketName: UILabel!
    @IBOutlet var launchDate: UILabel!
    @IBOutlet var videoLink: UILabel!
    @IBOutlet var videoLinkLabel: UILabel!
    @IBOutlet private var youtubePlayerView: YTPlayerView!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetPlayer()
        setupVideoLinkBinding()
    }
    
    /// Hides the video link seciton if the video link is nil
    fileprivate func setupVideoLinkBinding() {
        videoLink.rx.observe(String.self, "text")
            .subscribe(onNext: { [weak self] text in
                self?.videoLinkLabel.isHidden = text == nil
                self?.videoLinkLabel.isHidden = text == nil
            })
            .disposed(by: disposeBag)
    }
    
    /// Prepare the player for reuse
    fileprivate func resetPlayer() {
        youtubePlayerView.stopVideo()
        youtubePlayerView.isHidden = true
    }
    
    /// Play Youtube video from video link
    func playVideo() {
        guard let text = videoLink.text, youtubePlayerView.isHidden else { return }
        
        self.youtubePlayerView.load(withVideoId: (text as NSString).lastPathComponent)//, playerVars: ["playsinline": 1])
        UIView.transition(with: youtubePlayerView, duration: 0.3, options: .allowAnimatedContent, animations: {
            self.youtubePlayerView.isHidden = false
        }) { [weak self] _ in
            self?.youtubePlayerView.playVideo()
        }
    }
    
    /// Make sure the cell is empty before reusing it
    override func prepareForReuse() {
        missionName.text = nil
        rocketName.text = nil
        launchDate.text = nil
        videoLink.text = nil
        videoLinkLabel.isHidden = false
        videoLink.isHidden = false
        resetPlayer()
    }
    
}
