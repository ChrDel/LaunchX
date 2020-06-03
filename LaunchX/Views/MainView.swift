//
//  MainView.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 17/5/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

struct MainView: View {
    
    ///Labels for the segmented control
    @State private var launchLabels = ["Past Lanches","Upcoming Launches"]
    
    ///State indicating if the search area should be hidden or vissible
    @State private var searchAreaVisible = false
    
    ///State indicating the height of the searchArea
    @State private var searchHeight: CGFloat? = 0
    
    ///State used to define where to apply padding for the searchArea
    @State private var searchPadding: Edge.Set = []
    
    ///Used to store the text entered in the Mission Name TextField (search criteria)
    @State private var missionName = ""
    
    ///Used to store the text entered in the Rocket Name TextField (search criteria)
    @State private var rocketName = ""
    
    ///Used to store the text entered in the Launch Year TextField (search criteria)
    @State private var launchYear = ""

    ///View Model for the Main View.
    @ObservedObject private var mainViewModel = MainViewModel()

    ///Used to hide and show the searchArea
    fileprivate func toggleSearchArea() {
        withAnimation {
            self.searchAreaVisible.toggle()
            self.searchHeight = self.searchAreaVisible ? nil : 0
            self.searchPadding = self.searchAreaVisible ? [.top,.bottom] : []
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                Image("NavBar").resizable().aspectRatio(contentMode:.fill).frame(height: 120).clipped()
                Text("LaunchX").foregroundColor(.white).font(.system(size: 30)).offset(y:10)
                HStack {
                    Button(action: {
                        self.toggleSearchArea()
                    }) {
                        VStack{
                            Image(systemName: "magnifyingglass")
                                .font(.system(size:40, weight: .light))
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(width: 60, height: 60)
                    }.frame(width: 60, height: 60)
                        .offset(y: 14)
                    Spacer()
                }.frame(maxWidth: UIScreen.main.bounds.width)
            }.frame(maxWidth: UIScreen.main.bounds.width)
            HStack(spacing: 0) {
                VStack {
                    TextField("Mission Name", text: $missionName).textFieldStyle(RoundedBorderTextFieldStyle()).padding([.leading, .trailing]).frame(height: searchHeight).clipped()
                    TextField("Rocket Name", text: $rocketName).textFieldStyle(RoundedBorderTextFieldStyle()).padding([.leading, .trailing]).frame(height: searchHeight).clipped()
                    TextField("Launch Year", text: $launchYear).keyboardType(.numberPad).textFieldStyle(RoundedBorderTextFieldStyle()).padding([.leading, .trailing]).frame(height: searchHeight).clipped()
                }.frame(height: searchHeight).clipped()
                VStack(alignment: .leading) {
//                    Spacer().frame(height: 5)
                    Button(action: {
                        self.missionName = ""
                        self.rocketName = ""
                        self.launchYear = ""
                        if self.mainViewModel.criteria.missionName != self.missionName {
                            self.mainViewModel.criteria.missionName = self.missionName
                        }
                        if self.mainViewModel.criteria.rocketName != self.rocketName {
                            self.mainViewModel.criteria.rocketName = self.rocketName
                        }
                        if self.mainViewModel.criteria.launchYear != self.launchYear {
                            self.mainViewModel.criteria.launchYear = self.launchYear
                        }
                    }) {
                        Image(systemName: "clear")
                            .font(.system(size:40, weight: .light))
                            .foregroundColor(.blue)
                    }.offset(x: -5)
                    Spacer().frame(height: 30)
                    Button(action: {
                        if self.mainViewModel.criteria.missionName != self.missionName {
                            self.mainViewModel.criteria.missionName = self.missionName
                        }
                        if self.mainViewModel.criteria.rocketName != self.rocketName {
                            self.mainViewModel.criteria.rocketName = self.rocketName
                        }
                        if self.mainViewModel.criteria.launchYear != self.launchYear {
                            self.mainViewModel.criteria.launchYear = self.launchYear
                        }
                        self.toggleSearchArea()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size:50, weight: .light))
                            .foregroundColor(.blue)
                    }.offset(x: -5)
                    Spacer().frame(height: 10)
                    }.frame(width: 50, height: searchHeight)
                
            }
            .frame(width: UIScreen.main.bounds.width, height: searchHeight).clipped()
            .padding(searchPadding)
            Picker("Launches", selection: $mainViewModel.segmentIndex) {
                ForEach(0 ..< launchLabels.count) { index in
                    Text(self.launchLabels[index]).tag(index)
                }
            }.frame(minHeight: 50,alignment: .top)
                .pickerStyle(SegmentedPickerStyle())
            if self.mainViewModel.launches.count == 0 {
                Text("Loading Launches... / No Launches Found...").padding()
            } else {
                List{
                    ForEach(self.mainViewModel.launches, id: \.self) { launch -> AnyView in
                        let youtubePlayer = YoutubePlayerView(videoLink: launch.videoLink)
                        return AnyView(VStack(alignment: .leading, spacing: 6) {
                            Text("Mission Name:").fontWeight(.semibold)
                            Text(launch.missionName ?? "-")
                            Text("Rocket Name:").fontWeight(.semibold)
                            Text(launch.rocketName ?? "-")
                            Text("Local Launch Time:").fontWeight(.semibold)
                            Text(launch.launchDateLocal?.localStringToDate?.toLongDateTime ?? "-")
                            Text("Video Link:").fontWeight(.semibold)
                            Text(launch.videoLink ?? "-").foregroundColor(.blue).onTapGesture {
                                if let index = self.mainViewModel.launches.firstIndex(where: { $0 == launch}) {
                                    self.mainViewModel.launches[index].isVideoPlayerHidden.toggle()
                                }
                            }
                            youtubePlayer.frame(width: UIScreen.main.bounds.width-30, height: (UIScreen.main.bounds.width-40)*9/16*(launch.isVideoPlayerHidden ? 0 : 1)).animation(.default)
                                .onAppear {
                                    if !launch.isVideoPlayerHidden {
                                        youtubePlayer.loadVideo()
                                    }
                            }
                        }
                        .padding([.top, .bottom])
                        )
                    }
                }
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            //Hack to change the size of the SegmentedControl
            // Not recommended since apple can always change the hierarchy of views.
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                if let windowScenedelegate = scene?.delegate as? SceneDelegate {
                    windowScenedelegate.window!.rootViewController!.view.subviews.forEach({ (view) in
                        print(view.description)
                        view.subviews.forEach({ (view2) in
                            if let view3 = view2 as? UISegmentedControl {
                                let width = view3.frame.width
                                view3.translatesAutoresizingMaskIntoConstraints = false
                                view3.heightAnchor.constraint(equalToConstant: 50).isActive = true
                                view3.widthAnchor.constraint(equalToConstant: width).isActive = true
                                view3.layoutSubviews()
                                view3.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
                            }
                        })
                    })
                }
            }
        }
        
    }
    
}

extension View {
    /// Whether the view is hidden.
    /// - Parameter bool: Set to `true` to hide the view. Set to `false` to show the view.
    func isHidden(_ bool: Bool) -> some View {
        modifier(HiddenModifier(isHidden: bool))
    }
}

/// Creates a view modifier that can be applied, like so:
///
/// ```
/// Text("Hello World!")
///     .isHidden(true)
/// ```
///
/// Variables can be used in place so that the content can be changed dynamically.
private struct HiddenModifier: ViewModifier {
    
    fileprivate let isHidden: Bool
    
    fileprivate func body(content: Content) -> some View {
        Group {
            if isHidden {
                content.hidden()
            } else {
                content
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
