//
//  SearchPageUnitTests.swift
//  HeadlightTests
//
//  Created by iosdev on 06/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest
@testable import Headlight

class SearchPageUnitTests : XCTestCase {
    
    let dataFetcher : DataFetcher = DataFetcher()
    let searchCont : SearchViewController = SearchViewController()
    
    override func setUp() {
        dataFetcher.FetchInitialData()
    }
    
    override func tearDown() {
      
    }
    
    func testSearchAlgorithm() {
        searchCont.appendToSearchString("Unity")
        print(searchCont.searchResultData?[0]?.name ?? "")
    }
    
}
