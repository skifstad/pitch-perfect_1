//
//  RecordAudio.swift
//  Perfect Pitch
//
//  Created by Nathan Skifstad on 3/15/15.
//  Copyright (c) 2015 skifstad.com. All rights reserved.
//

import Foundation

class RecordAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(url: NSURL!, title: String!) {
        filePathUrl = url
        self.title = title
    }
}