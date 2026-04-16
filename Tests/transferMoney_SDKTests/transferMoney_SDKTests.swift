import Testing
import XCTest
@testable import transferMoney_SDK

final class transferMoney_SDKTests: XCTestCase {
    var converter: TransferMoney_core!

    override func setUp() {
        super.setUp()
        converter = TransferMoney_core()
    }

    // MARK: - Version
    func testSDKVersion() {
        XCTAssertEqual(TransferMoneySDK.version, "0.0.1")
    }

    // MARK: - VND → USD (.standard)
    func testVNDToUSD_2MillionVND() throws {
        let result = try converter.convert(amount: 2_000_000, from: .VND, to: .USD, choose: .standard)
        XCTAssertEqual(result.sourceCurrency, .VND)
        XCTAssertEqual(result.targetCurrency, .USD)
        XCTAssertGreaterThan(result.targetAmount, 39.0)
        XCTAssertLessThan(result.targetAmount, 79.0)
    }

    func testVNDToUSD_zeroVND() throws {
        let result = try converter.convert(amount: 0, from: .VND, to: .USD, choose: .standard)
        XCTAssertEqual(result.targetAmount, 0.0)
    }

    func testVNDToUSD_shorthand() throws {
        let usd = try converter.vndToUsd(2_000_000)
        XCTAssertEqual(usd, 78.58, accuracy: 0.01)
    }

    // MARK: - VND → USD (.customRate)
    func testVNDToUSD_customRate() throws {
        let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .customRate(25_000))
        XCTAssertEqual(result.exchangeRate, 25_000)
        XCTAssertEqual(result.targetAmount, 40.0, accuracy: 0.01)
    }

    // MARK: - USD → VND
    func testUSDToVND_20USD() throws {
        let result = try converter.convert(amount: 20, from: .USD, to: .VND, choose: .standard)
        XCTAssertEqual(result.sourceCurrency, .USD)
        XCTAssertGreaterThan(result.targetAmount, 500_000.0)
    }

    func testUSDToVND_shorthand() throws {
        let vnd = try converter.usdToVnd(5)
        XCTAssertEqual(vnd, 127_250, accuracy: 1)
    }

    // MARK: - Error Cases
    func testNegativeAmountThrows() {
        XCTAssertThrowsError(try converter.convert(amount: -100, from: .VND, to: .USD, choose: .standard))
    }

    func testCustomRateInvalidThrows() {
        XCTAssertThrowsError(try converter.convert(amount: 100, from: .VND, to: .USD, choose: .customRate(-1)))
        XCTAssertThrowsError(try converter.convert(amount: 100, from: .VND, to: .USD, choose: .customRate(0)))
    }

    func testInvalidRateThrows() {
        XCTAssertThrowsError(try converter.updateExchangeRates(-1))
        XCTAssertThrowsError(try converter.updateExchangeRates(0))
    }

    // MARK: - Result Fields
    func testResultContainsSDKVersion() throws {
        let result = try converter.convert(amount: 500_000, from: .VND, to: .USD, choose: .standard)
        XCTAssertEqual(result.sdkVersion, "0.0.1")
    }

    func testResultTimestampIsRecent() throws {
        let result = try converter.convert(amount: 100_000, from: .VND, to: .USD, choose: .standard)
        XCTAssertLessThan(Date().timeIntervalSince(result.timeStamp), 5)
    }
}
