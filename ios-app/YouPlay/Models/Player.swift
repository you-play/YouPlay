//  Model of "Player" and "Actions"
//  Player.swift
//  YouPlay
//
//  Created by 趙藝鑫 on 3/30/24.
//

import Foundation

struct Player: Hashable {
    let repeatState: String
    let shuffleState: Bool
    let isPlaying: Bool
    let song: Song
    let actions: Actions
}

struct Actions: Hashable {
    let interruptingPlayback, pausing, resuming, seeking: Bool
    let skippingNext, skippingPrev, togglingRepeatContext, togglingShuffle: Bool
    let togglingRepeatTrack, transferringPlayback: Bool
}

extension Player{
    static let mock = Player(
        repeatState: "loop",
        shuffleState: false,
        isPlaying: true,
        song: Song.mock,
        actions: Actions.mock
    )
}

extension Actions {
    static let mock = Actions(
        interruptingPlayback: false,
        pausing: false,
        resuming: true,
        seeking: false,
        skippingNext: false,
        skippingPrev: false,
        togglingRepeatContext: false,
        togglingShuffle: false,
        togglingRepeatTrack: false,
        transferringPlayback: true
    )
}
