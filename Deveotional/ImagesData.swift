//
//  ImagesData.swift
//  Deveotional
//
//  Created by Kuramsetty Harish on 21/07/18.
//  Copyright © 2018 iDreams. All rights reserved.
//

import Foundation
struct  ImageDta:Codable
{
    var totalHits:Int?
    var hits:[Hits]
}

struct Hits: Codable{
    var previewURL:String?
}
