/*
 This SDK is licensed under the MIT license (MIT)
 Copyright (c) 2015- Applied Technologies Internet SAS (registration number B 403 261 258 - Trade and Companies Register of Bordeaux – France)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */





//
//  LiveMedium.swift
//  Tracker
//

import Foundation


/// Wrapper class for live audio tracking
public class LiveMedium: RichMedia {
    
    override init(tracker: Tracker, playerId: Int) {
        super.init(tracker: tracker, playerId: playerId)
        broadcastMode = BroadcastMode.live
    }
}


/// Wrapper class to manage LiveAudio instances
public class LiveMedia: NSObject {
    
    @objc var list: [String: LiveMedium] = [String: LiveMedium]()
    
    /// MediaPlayer instance
    @objc weak var player: MediaPlayer!
    
    /**
     LiveMedia initializer
     - parameter player: the player instance
     - returns: LiveMedia instance
     */
    @objc init(player: MediaPlayer) {
        self.player = player
    }
    
    /// Add a new live medium
    ///
    /// - Parameter mediaLabel: medium name
    /// - Returns: new live medium instance
    @objc public func add(_ mediaLabel:String, mediaType:String) -> LiveMedium {
        if let liveMedium = self.list[mediaLabel] {
            self.player.tracker.delegate?.warningDidOccur?("A LiveMedium with the same name already exists.")
            return liveMedium
        } else {
            let liveMedium = LiveMedium(tracker: self.player.tracker, playerId: self.player.playerId)
            liveMedium.mediaLabel = mediaLabel
            liveMedium.type = mediaType
            
            self.list[mediaLabel] = liveMedium
            
            return liveMedium
        }
    }
    
    /// Add a new live medium
    ///
    /// - Parameters:
    ///   - mediaLabel: name
    ///   - mediaTheme1: chapter1 label
    /// - Returns: new live medium instance
    @objc public func add(_ mediaLabel: String, mediaTheme1: String, mediaType:String) -> LiveMedium {
        let liveMedium = add(mediaLabel, mediaType:mediaType)
        liveMedium.mediaTheme1 = mediaTheme1
        return liveMedium
    }
    
    /// Add a new live medium
    ///
    /// - Parameters:
    ///   - mediaLabel: name
    ///   - mediaTheme1: chapter1 label
    ///   - mediaTheme2: chapter2 label
    /// - Returns: a new live medium instance
    @objc public func add(_ mediaLabel: String, mediaTheme1: String, mediaTheme2: String, mediaType:String) -> LiveMedium {
        let liveMedium = add(mediaLabel, mediaTheme1: mediaTheme1, mediaType:mediaType)
        liveMedium.mediaTheme2 = mediaTheme2
        return liveMedium
    }
    
    /// Add a new live medium
    ///
    /// - Parameters:
    ///   - mediaLabel: name
    ///   - mediaTheme1: chapter1 label
    ///   - mediaTheme2: chapter2 label
    ///   - mediaTheme3: chapter3 label
    /// - Returns: a new live medium instance
    @objc public func add(_ mediaLabel: String, mediaTheme1: String, mediaTheme2: String, mediaTheme3: String, mediaType:String) -> LiveMedium {
        let liveMedium = add(mediaLabel, mediaTheme1: mediaTheme1, mediaTheme2: mediaTheme2, mediaType:mediaType)
        liveMedium.mediaTheme3 = mediaTheme3
        return liveMedium
    }
    
    /// Remove a live medium
    ///
    /// - Parameter mediaLabel: name
    @objc public func remove(_ mediaLabel: String) {
        if let timer = list[mediaLabel]?.timer {
            if timer.isValid {
                list[mediaLabel]!.sendStop()
            }
        }
        self.list.removeValue(forKey: mediaLabel)
    }
    
    /// Remove all live media
    @objc public func removeAll() {
        for (_, value) in self.list {
            if let timer = value.timer {
                if timer.isValid {
                    value.sendStop()
                }
            }
        }
        self.list.removeAll(keepingCapacity: false)
    }
    
}
