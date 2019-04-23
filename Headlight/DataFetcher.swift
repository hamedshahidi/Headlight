//
//  DataFetcher.swift
//  Headlight
//
//  Created by iosdev on 22/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation


// just a simple class, that fetches the data from the given url
// and parses it as well
class DataFetcher {
    
    func FetchInitialData () {
        
        guard let url = URL(string: "https://fast-springs-15846.herokuapp.com/courses")else{
            print("url muodostui väärin")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){data, response, error in
            if let error = error{
                print("Error with fetching \(error)")
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("haku epäonnistui ")
                return
            }
            
            guard let dataToBeParsed = data else{return}
            do{
                let decoder = JSONDecoder()
                let parsedData = try decoder.decode(Array<CourseStruct.Course>.self, from: dataToBeParsed)
                
                // data is now parsed into parsedData -variable.
                // call the coredata saving from here
                
                DispatchQueue.main.async {
                      CoreDataHelper.saveCourseData(courseList: parsedData)
                }
                
              
                
            }catch let err{
                print("someting went wrong decoding the fetched data \(err)")
            }
            
        }
        task.resume()
    }
}
