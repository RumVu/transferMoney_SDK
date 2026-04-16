import Testing
import XCTest
@testable import transferMoney_SDK

final class transferMoney_SDKTests: XCTestCase {
    var converter: TransferMoney_core!
    
    override func setUp()
    {
        super.setUp()
        converter = TransferMoney_core()
    }
    
    //MARK: version
    func testSDKVersion(){
        XCTAssertEqual(transferMoney_SDK.version, "0.0.1")
    }
    
    //MARK: VND -> USD
    
    func testVNDToUSD_2MillionVND() throws {
        let results = try converter.convert(amount: 2_000_000, from: .VND, to: .USD)
        XCTAssertEqual(results.sourceCurrency, .VND)
        XCTAssertEqual(results.targetCurrency, .USD)
        XCTAssertGreaterThan(results.targetAmount, 39.0)
        XCTAssertLessThan(results.targetAmount, 79.0)
    }
    
    func testVNDToUSD_zeroVND() throws {
        let results = try converter.convert(amount: 0, from: .VND, to: .USD)
        XCTAssertEqual(results.sourceCurrency, .VND)
        XCTAssertEqual(results.targetCurrency, .USD)
        XCTAssertEqual(results.targetAmount, 0.0)
    }
    
    func testVNDToUSD_shorthand() throws {
        let usd = try converter.vndToUsd(2_000_000)
        XCTAssertEqual(usd,78.58, accuracy: 0.01)
    }
    
    //MARK: USD -> VND
    func testUSDToVND_20USD() throws {
        let results = try converter.convert(amount: 20, from: .USD, to: .VND)
        XCTAssertEqual(results.sourceCurrency, .USD)
        XCTAssertEqual(results.targetCurrency, .VND)
        XCTAssertGreaterThan(results.targetAmount, 500_000.0)
    }
    func testUSDToVND_shorthand() throws{
        let vnd = try converter.usdToVnd(5)
        XCTAssertEqual(vnd,127_250, accuracy: 1)
    }
    // MARK: - Error Cases
    
    func testNegativeAmountThrows() {
        XCTAssertThrowsError(try converter.convert(amount: -100, from: .VND, to: .USD))
    }
    
    func testInvalidRateThrows() {
        XCTAssertThrowsError(try converter.updateExchangeRates(-1))
        XCTAssertThrowsError(try converter.updateExchangeRates(0))
    }
    
    // MARK: - Result Fields
    
    func testResultContainsSDKVersion() throws {
        let result = try converter.convert(amount: 500_000, from: .VND, to: .USD)
        XCTAssertEqual(result.sdkVersion, "0.0.1")
    }
    
    func testResultTimestampIsRecent() throws {
        let result = try converter.convert(amount: 100_000, from: .VND, to: .USD)
        XCTAssertLessThan(Date().timeIntervalSince(result.timeStamp), 5)
    }
}
