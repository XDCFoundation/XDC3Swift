//
//  XRC20Tests.swift
//  XDC3Swift_Tests
//
//  Created by Developer on 05/08/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import BigInt
@testable import XDC3Swift
class XRC20Tests: XCTestCase {
    var client: XDCClient?
    var xrc20: XRC20?
    var account1: XDCAccount?
    var account2: XDCAccount?
    let timeout = 10.0
    let testContractAddress = XDCAddress(testConfig.XRC20)
    let testAccount1 = XDCAddress(testConfig.account1)
    let testAccount2 = XDCAddress(testConfig.account2)
    let testAccount3 = XDCAddress(testConfig.account3)
    
    override func setUp() {
        super.setUp()
        self.client = XDCClient(url: URL(string: testConfig.clientUrl)!)
        self.account1 = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: testConfig.account1_privateKey))
        self.account2 = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: testConfig.account2_privateKey))
        self.xrc20 = XRC20(client: client!)
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
    func testName(){
        let expect = expectation(description: "Get token name")
        xrc20?.name(tokenContract: self.testContractAddress, completion: { (error, name) in
            XCTAssertNil(error)
            XCTAssertEqual(name, "XFToken")
            expect.fulfill()
        })
        waitForExpectations(timeout: timeout)
    }
    
    func testDecimal(){
        let expect = expectation(description: "Get token decimals")
        xrc20?.decimals(tokenContract: self.testContractAddress, completion: { (error, decimals) in
            XCTAssertNil(error)
            XCTAssertEqual(decimals, 18)
            expect.fulfill()
        })
        waitForExpectations(timeout: timeout)
    }
    
    
    func testSymbol(){
        let expect = expectation(description: "Get token symbol")
        xrc20?.symbol(tokenContract: self.testContractAddress, completion: { (error, symbol) in
            XCTAssertNil(error)
            XCTAssertEqual(symbol, "TKN")
            expect.fulfill()
        })
        waitForExpectations(timeout: timeout)
    }
    
    func test_totalSupply() {
        let expect = expectation(description: "Get supply")
        xrc20?.totalSupply(contract: self.testContractAddress, completion: { (error, abcd) in
            XCTAssertNil(error)
            XCTAssert(abcd! > 0)
            expect.fulfill()
        })
        waitForExpectations(timeout: timeout)
    }
    
    func test_balanceOf(){
        let expect = expectation(description: "balanceOf")
        xrc20?.balanceOf(tokenContract: self.testContractAddress, account: self.account1!.address, completion: { (error, balance) in
            print(balance!)
            XCTAssert(balance! > 0)
            expect.fulfill()
        })
        waitForExpectations(timeout: timeout)
    }
    
    
    func testAllowance(){
        let expect = expectation(description: "allowance")
        xrc20?.allowance(tokenContract: self.testContractAddress, address: self.testAccount1, spender: self.testAccount2, completion: { (error, allowance) in
            print(allowance!)
            XCTAssert(allowance! >= 0)
            expect.fulfill()
        })
        waitForExpectations(timeout: timeout)
    }
    
    func test_transferToken(){
        let expect = expectation(description: "transfer")
       
        let function = XRC20Functions.transfer(contract: self.testContractAddress, to: self.testAccount2, value: BigUInt(10000000000000000000))
        let transaction = (try? function.transaction(gasPrice: 350000, gasLimit: 300000))!
        client!.eth_sendRawTransaction(transaction, withAccount: self.account1!) { (error, txHash) in
            print("TX Hash: \(txHash ?? "")")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_approve(){
        let expect = expectation(description: "approve")
        
        let function = XRC20Functions.approve(contract: self.testContractAddress, spender: self.testAccount2, value: 10000000000000000000)
        let transaction = (try? function.transaction(gasPrice: 3500000, gasLimit: 3000000))!
        client!.eth_sendRawTransaction(transaction, withAccount: self.account1!) { (error, txHash) in
            print("TX Hash: \(txHash ?? "")")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
        
    }
    
    func test_transferFrom(){
        let expect = expectation(description: "transferFrom")
        let function = XRC20Functions.transferFrom(contract: self.testContractAddress, sender: self.testAccount1, to: self.testAccount3, value: BigUInt(450000000000000000))
        let transaction = try? function.transaction(gasPrice: 3000000, gasLimit: 3000000)
        
        self.client?.eth_sendRawTransaction(transaction!, withAccount: self.account2!, completion: { (error, txhash) in
            print(txhash!)
            expect.fulfill()
        })
       waitForExpectations(timeout: 10, handler: nil)
    }


    func test_decreaseAllowance(){
        let expect = expectation(description: "decreaseAllowance")
        xrc20?.decreaseAllowance(account: self.account1!, tokenAddress: self.testContractAddress, owner: self.testAccount1, spender: self.testAccount2, value: 500000000000000000, completion: { (allowance) in
            print(allowance!)
            expect.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_increaseAllowance(){
        let expect = expectation(description: "increaseAllowance")
        xrc20?.increaseAllowance(account: self.account1!, tokenAddress: self.testContractAddress, owner: self.testAccount1, spender: self.testAccount2, value: 5000000000000000000, completion: { (allowance) in
            print(allowance!)
            expect.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
