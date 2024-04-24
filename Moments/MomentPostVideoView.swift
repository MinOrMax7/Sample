//
//  MomentPostVideoView.swift
//  Amigo
//
//  Created by Jack Liu on 9/9/22.
//

import SwiftUI
import CoreMedia
import AVFoundation
import AVKit

struct MomentPostVideoView: View {
    @StateObject private var videoViewModel = VideoViewModel()
    var videoPlayerWorker = VideoPlayerWorker()
    @State var player : AVPlayer = AVPlayer()

    @Binding var videoPullURL : String
    @Binding var mute : Bool
    @State var play = false

    @Binding var width : CGFloat
    @Binding var height : CGFloat

    @State var videoWidth = UIScreen.main.bounds.size.width
    @State var videoHeight = UIScreen.main.bounds.size.width
    
    @State var sizeAdjusted = false;

    let globalCenter = UIScreen.main.bounds.size.height / 2

    private func checkPlay(_ geo: GeometryProxy){
        if(geo.frame(in: .global).midY > globalCenter + 200 || geo.frame(in: .global).midY < globalCenter - 200) {
            player.pause()
        } else {
            player.play()
        }
    }

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center){
                if player.currentItem != nil {
                    VStack{
                        if(sizeAdjusted){
                            VideoPlayer(player: player, videoOverlay: {
                                VStack(alignment: .leading){
                                    if(mute){
                                        Image(systemName: "speaker.slash.fill")
                                            .foregroundColor(.white)
                                            .offset(x: width / 2 - 10, y: height - 18)
                                    }
                                    Spacer()
                                }
                            })
                            .frame(width: videoWidth, height: videoHeight, alignment: .center)
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)) { (output) in
                        player.seek(to: .zero)
                        checkPlay(geo)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemNewAccessLogEntry, object: player.currentItem)) { (output) in
                        guard let item = self.player.currentItem, let track = item.asset.tracks(withMediaType: AVMediaType.video).first else { return }
                        let size = track.naturalSize.applying(track.preferredTransform)
                        let ratio = abs(size.height) / abs(size.width)
                        if(ratio > 1){
                            let multiplier = (ratio > 1.3 ? 1.3 : ratio)
                            self.height = multiplier * width
                            self.videoWidth = width
                            self.videoHeight = videoWidth * ratio
                        } else {
                            let multiplier = (ratio < 0.7 ? 0.7 : ratio)
                            self.height = multiplier * width
                            self.videoHeight = height
                            self.videoWidth = videoHeight / ratio
                        }
                        self.sizeAdjusted = true
                    }
                }
            }
            .onDisappear {
                player.pause()
            }
            .onTapGesture {
                mute.toggle()
                player.isMuted = mute
            }
            .onChange(of: geo.frame(in: .global).midY, perform: { newValue in
                if(newValue > globalCenter + 200 || newValue < globalCenter - 200) {
                    player.pause()
                } else {
                    player.play()
                }
            })
            .onAppear() {
                if(videoViewModel.url.isEmpty){
                    videoViewModel.downloadVideoFromStorage(videoPullURL: videoPullURL, preload: true)
                }
                checkPlay(geo)
            }
            .onChange(of: videoViewModel.url) { newValue in
                self.player = videoPlayerWorker.getPlayer(with: URL(string: newValue)!)
                self.player.isMuted = mute
                checkPlay(geo)
            }
        }
    }
}

