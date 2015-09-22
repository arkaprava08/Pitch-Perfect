//
//  RecordedAudioModel.swift
//  Pitch Perfect
//
//  Created by Arkaprava De on 19/09/15.
//  Copyright © 2015 Arkaprava De. All rights reserved.
//

import Foundation

class RecordedAudioModel {
    
    var filePathURL:NSURL!
    var title:String!
    
    init(url:NSURL, lastComponent:String!) {
        self.filePathURL = url
        self.title = lastComponent
    }
}
