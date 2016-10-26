//
//  Posts.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 26/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import Foundation

struct Post {
    let title: String
    let text: String
    var photo: String?
    var latitude: Double?
    var longitude: Double?
    let author: String
    var published: Bool
    var rate: Double?
    var wantPublish: Bool
    var containerName: String?
    var numberRates: Int
    
    init(_ author: String, text: String, title: String){
        self.title = title
        self.author = author
        self.text  = text
        self.photo=nil
        self.latitude=nil
        self.longitude=nil
        self.published=false
        self.rate = 0
        self.containerName=nil
        self.wantPublish=false
        self.numberRates = 0
    }
    
    init (_let title: String,
          text: String,
          photo: String,
          latitude: Double,
          longitude: Double,
          author: String,
          published: Bool,
          rate: Double,
          wantPublish: Bool,
          containerName: String,
          numberRates: Int
        ){
        self.title = title
        self.text = text
        self.photo = photo
        self.latitude = latitude
        self.longitude = longitude
        self.author = author
        self.published = published
        self.rate = rate
        self.wantPublish = wantPublish
        self.containerName = containerName
        self.numberRates = numberRates

    }
}
