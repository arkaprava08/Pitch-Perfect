//
//  RecordedAudioModel.swift
//  Pitch Perfect
//
//  Created by Arkaprava De on 19/09/15.
//  Copyright © 2015 Arkaprava De. All rights reserved.
//

import Foundation

class RecordedAudioModel {
    
    var url:NSURL!
    var lastComponent:String!
    
    init(url:NSURL, lastComponent:String!) {
        self.url = url
        self.lastComponent = lastComponent
    }
}
