//
//  YoutubePlayerView.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 20/5/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit
import SwiftUI
import youtube_ios_player_helper

///Used to integrate UIKit based YTPlayerView into a SwiftUI View
struct YoutubePlayerView: UIViewRepresentable {

    ///Link to the video to play
    private var videoLink: String?
    
    ///UIKit YTPlayerView
    private let youtubePlayerView = YTPlayerView()
    
    ///Initialize the View
    init(videoLink: String?) {
        self.videoLink = videoLink
    }
    
    ///Creates the view object and configures its initial state.
    func makeUIView(context: Context) -> YTPlayerView {
        youtubePlayerView
    }
    
    ///Updates the state of the specified view with new information from SwiftUI.
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        //
    }
    
    ///Load the video in the player
    func loadVideo() {
        if let text = videoLink {
            youtubePlayerView.load(withVideoId: (text as NSString).lastPathComponent)
        }
    }
    
}
