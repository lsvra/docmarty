//
//  ListViewModelTests.swift
//  docmartyTests
//
//  Created by Luís Vieira on 08/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import XCTest
@testable import Doc_Marty

class ListViewModelTests: XCTestCase {
    
    var viewModel: ListViewModel!
    
    let onLoadingFake = { }
    let onTitleLoadedFake = { (_ title: String) in }
    let onDataLoadedFake = { }
    let onErrorFake = { (_ error: ServiceError) in }
    let onNetworkStatusDidChangeFake = { (_ inOnline: Bool) in }
    
    override func setUp() {
        super.setUp()
        
        
        let adapter = FakeListRequestAdapter()
        let reachability = try? Reachability()
        let dependencies = ListViewModel.Dependencies(adapter: adapter,
                                                      reachability: reachability,
                                                      coordinator: nil)
        
        viewModel = ListViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        
        viewModel = nil
        super.tearDown()
    }
    
    // Example of properties check
    func testItStoresAllDependencies() {
        XCTAssertNotNil(viewModel.dependencies)
    }
    
    // Example of logic test (using the accessible viewModel methods)
    func testNumberOfItemsEquals20() {
        viewModel.loadData()
        
        let numberOfItemsInSection = viewModel.numberOfItems(inSection: 0)
        XCTAssertEqual(numberOfItemsInSection, 20)
    }
    
    //Example of binding test
    func testOnTitleLoadedPathExists() {
        
        let expectation = XCTestExpectation(description: "OnTitleLoaded")
        
        let onTitleLoaded = { (title: String) in

            XCTAssertTrue(true)
            expectation.fulfill()
        }
        
        viewModel.bindings = ListViewModel.Bindings(onLoading: onLoadingFake,
                                                    onTitleLoaded: onTitleLoaded,
                                                    onDataLoaded: onDataLoadedFake,
                                                    onError: onErrorFake,
                                                    onNetworkStatusDidChange: onNetworkStatusDidChangeFake)
        viewModel.loadData()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
