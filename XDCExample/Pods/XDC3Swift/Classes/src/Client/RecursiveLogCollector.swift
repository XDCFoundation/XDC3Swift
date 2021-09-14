//
//  RecursiveLogCollector.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

enum Topics: Encodable {
    case plain([String?])
    case composed([[String]?])

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        switch self {
        case .plain(let values):
            try container.encode(contentsOf: values)
        case .composed(let values):
            try container.encode(contentsOf: values)
        }
    }
}

struct RecursiveLogCollector {
    let ethClient: XDCClient

    func getAllLogs(
        addresses: [XDCAddress]?,
        topics: Topics?,
        from: XDCBlock,
        to: XDCBlock
    ) -> Result<[XDCLog], XDCClientError> {

        switch getLogs(addresses: addresses, topics: topics, from: from, to: to) {
        case .success(let logs):
            return .success(logs)
        case.failure(.tooManyResults):
            guard let middleBlock = getMiddleBlock(from: from, to: to)
                else { return .failure(.unexpectedReturnValue) }

            guard
                case let .success(lhs) = getAllLogs(
                    addresses: addresses,
                    topics: topics,
                    from: from,
                    to: middleBlock
                ),
                case let .success(rhs) = getAllLogs(
                    addresses: addresses,
                    topics: topics,
                    from: middleBlock,
                    to: to
                )
            else { return .failure(.unexpectedReturnValue) }

            return .success(lhs + rhs)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func getLogs(
        addresses: [XDCAddress]?,
        topics: Topics? = nil,
        from: XDCBlock,
        to: XDCBlock
    ) -> Result<[XDCLog], XDCClientError> {

        let sem = DispatchSemaphore(value: 0)

        var response: Result<[XDCLog], XDCClientError>!

        ethClient.getLogs(addresses: addresses, topics: topics, fromBlock: from, toBlock: to) { result in
            response = result
            sem.signal()
        }

        sem.wait()

        return response
    }

    private func getMiddleBlock(
        from: XDCBlock,
        to: XDCBlock
    ) -> XDCBlock? {

        func toBlockNumber() -> Int? {
            if let toBlockNumber = to.intValue {
                return toBlockNumber
            } else if case let .success(currentBlock) = getCurrentBlock(), let currentBlockNumber = currentBlock.intValue {
                return currentBlockNumber
            } else {
                return nil
            }
        }

        guard
            let fromBlockNumber = from.intValue,
            let toBlockNumber = toBlockNumber()
        else { return nil }

        return XDCBlock(rawValue: fromBlockNumber + (toBlockNumber - fromBlockNumber) / 2)
    }

    private func getCurrentBlock() -> Result<XDCBlock, XDCClientError> {
        let sem = DispatchSemaphore(value: 0)
        var responseValue: XDCBlock?

        self.ethClient.eth_blockNumber { (error, blockInt) in
            if let blockInt = blockInt {
                responseValue = XDCBlock(rawValue: blockInt)
            }
            sem.signal()
        }
        sem.wait()

        return responseValue.map(Result.success) ?? .failure(.unexpectedReturnValue)
    }
}
