//
//  Structs.swift
//  Headlight
//
//  Created by iosdev on 20/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation

// a file that holds the fetched data structures as structs

struct FakeData: Codable{
    var skills : [String];
    var courses : [Course];
}

struct Course : Codable {
    var id : String?;
    var name : String?;
    var description : String?;
    var location : Location;
    var time : Time;
    var organization : String?;
    var rating : Double?;
    var skills : Skills?;
    
}

struct Time : Codable {
    var start : String?
    var end : String?
}

struct Location : Codable {
    var lgn : Double?
    var ltd : Double?
}

struct Skills : Codable {
    var gained : [String]?;
    var required : [String]?;
}
