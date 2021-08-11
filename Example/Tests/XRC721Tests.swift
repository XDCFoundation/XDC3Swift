//
//  XRC721Tests.swift
//  XDC3Swift_Tests
//
//  Created by Developer on 05/08/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import XDC3Swift

let nftURL = URL(string: "https://remix.xinfin.network/")!

class XRC721Tests: XCTestCase {
    
    var client: XDCClient!
    var xrc721: XRC721!
    var xrc721Metadata: XRC721Metadata!
    var xrc721Enumerable: XRC721Enumerable!
    var account1: XDCAccount!
    var account2: XDCAccount!
    let testTokenAddress = XDCAddress(testConfig.XRC721)
    let testAccount1 = XDCAddress(testConfig.account1)
    let testAccount2 = XDCAddress(testConfig.account2)
    let testAccount3 = XDCAddress(testConfig.account3)
    
    override func setUp() {
        super.setUp()
        self.client = XDCClient(url: URL(string: testConfig.clientUrl)!)
        self.xrc721 = XRC721(client: client)
        self.account1 = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: testConfig.account1_privateKey))
        self.account2 = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: testConfig.account2_privateKey))
        self.xrc721Metadata = XRC721Metadata(client: client, metadataSession: URLSession.shared)
        self.xrc721Enumerable = XRC721Enumerable(client: client)
        
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_Name() {
        let expect = expectation(description: "name")
        xrc721Metadata.name(contract: self.testTokenAddress) { (error, name) in
            XCTAssertNil(error)
            XCTAssertEqual(name, "XFToken")
            expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_Symbol() {
        let expect = expectation(description: "symbol")
        xrc721Metadata.symbol(contract: self.testTokenAddress) { (error, symbol) in
            XCTAssertNil(error)
            XCTAssertEqual(symbol, "XF")
            expect.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_MetatadaURI() {
        let expect = expectation(description: "tokenURI")
        xrc721Metadata.tokenURI(contract: self.testTokenAddress, tokenID: 23) { (error, url) in
            XCTAssertNil(error)
            XCTAssertEqual(url, nftURL)
            expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_GivenAccountWithNFT_ThenBalanceCorrect() {
        let expect = expectation(description: "BalanceOf")
        
        xrc721.balanceOf(contract: self.testTokenAddress, address: self.testAccount1) { (error, balance) in
            XCTAssertNil(error)
            print(balance!)
            XCTAssertGreaterThan(balance!, 0)
            expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    
    func test_GivenAccountWithNFT_ThenOwnerOfNFTIsAccount() {
        let expect = expectation(description: "OwnerOf")
        xrc721.ownerOf(contract: self.testTokenAddress, tokenId: 23) { (error, owner) in
            XCTAssertNil(error)
            XCTAssertEqual(owner,self.testAccount1)
            expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_returnsTotalSupply() {
        let expect = expectation(description: "totalSupply")
        xrc721Enumerable.totalSupply(contract: self.testTokenAddress) { (error, supply) in
            XCTAssertNil(error)
            XCTAssertEqual(supply ?? 0, 1)
            expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_returnsTokenByIndex() {
        let expect = expectation(description: "tokenByIndex")
        xrc721Enumerable.tokenByIndex(contract: self.testTokenAddress, index: 0) { (error, index) in
            XCTAssertNil(error)
            XCTAssertEqual(index, 23)
            expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_GivenAddressWithNFT_returnsTokenOfOwnerByIndex() {
        let expect = expectation(description: "tokenByIndex")
        xrc721Enumerable.tokenOfOwnerByIndex(contract: self.testTokenAddress, owner: self.testAccount1, index: 0) { error, tokenID in
            XCTAssertNil(error)
            XCTAssertEqual(tokenID, 23)
            expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_suportInterface(){
        let expect = expectation(description: "Support Interface")
        xrc721Enumerable.supportsInterface(contract: self.testTokenAddress, id: XRC721Functions.interfaceId) { (err, val) in
            XCTAssertTrue(val == true)
            expect.fulfill()
        }
        waitForExpectations(timeout:10)
    }
    
    func test_isApprovalForAll() {
        let expect = expectation(description: "isApprovedForAll")
        xrc721.isApprovedForAll(contract: self.testTokenAddress, opearator: self.testAccount2, owner: self.testAccount1) { (error, val) in
            XCTAssert((val != nil))
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    func test_getApproved(){
        let expect = expectation(description: "get approved")
        xrc721.getApproved(contract: self.testTokenAddress, tokenId: 23) { (err, addr) in
            XCTAssertEqual(addr, XDCAddress("0xccfe36cf0d40b7f50f3c64f8cb3903e254d3e465"))
            expect.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_approve() {
        let expect = expectation(description: "approve")
        
        let function = XRC721Functions.approve(contract: self.testTokenAddress, to: self.testAccount2, tokenId: 23)
        let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account1) { (error, txhash) in
            XCTAssertNotNil(txhash!, "No tx hash, ensure key is valid in TestConfig.swift")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func test_setApprovalForAll() {
        let expect = expectation(description: "setApprovalForAll")
        
        let function = XRC721Functions.setApprovalForAll(contract: self.testTokenAddress, to: self.testAccount2, approved: true)
        let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account1) { (err, txhash) in
            XCTAssertNotNil(txhash!, "No tx hash, ensure key is valid in TestConfig.swift")
            expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_safeTransferFrom() {
        let expect = expectation(description: "safeTransferFrom")
        
        let function = XRC721Functions.safeTransferFrom(contract: self.testTokenAddress, sender: self.testAccount1, to: self.testAccount2, tokenId: 23)
        let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account1) { (err, txhash) in
            XCTAssertNotNil(txhash!, "No tx hash, ensure key is valid in TestConfig.swift")
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    func test_TransferFrom() {
        let expect = expectation(description: "OwnerOf")
        let function = XRC721Functions.transferFrom(contract: self.testTokenAddress, sender: self.testAccount1, to: self.testAccount3, tokenId: 23)
        let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account2) { (err, txhash) in
            XCTAssertNotNil(txhash!, "No tx hash, ensure key is valid in TestConfig.swift")
            expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
