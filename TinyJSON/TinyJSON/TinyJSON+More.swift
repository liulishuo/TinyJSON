//
//  TinyJSON+More.swift
//  TinyJSON
//
//  Created by liulishuo on 2022/1/26.
//

import Foundation

//MARK: - Compatible with SwiftJSON

extension TinyJSON {

    public func rawData(options opt: JSONSerialization.WritingOptions = JSONSerialization.WritingOptions(rawValue: 0)) throws -> Data {

        guard let object = unwrap(self),
              JSONSerialization.isValidJSONObject(object) else {
                  throw TinyJSONError.invalidJSON
              }

        return try JSONSerialization.data(withJSONObject: object, options: opt)
    }

    /// 33.3 -> 33.299999999999997
    public func rawString(_ encoding: String.Encoding = .utf8, options opt: JSONSerialization.WritingOptions = .prettyPrinted) -> String {

        switch self {
        case .object, .array:
            return _rawString(encoding, options: opt)
        default:
            return self.description
        }

    }

    private func _rawString(_ encoding: String.Encoding = .utf8, options opt: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let data = try? rawData(options: opt) {
            return String(data: data, encoding: encoding) ?? TinyJSON.null.description
        }

        return TinyJSON.null.description
    }
}

extension TinyJSON {
    public mutating func merge(with other: TinyJSON) throws {
        try self.merge(with: other, typecheck: true)
    }

    public func merged(with other: TinyJSON) throws -> TinyJSON {
        var merged = self
        try merged.merge(with: other, typecheck: true)
        return merged
    }

    /**
     Private woker function which does the actual merging
     Typecheck is set to true for the first recursion level to prevent total override of the source JSON
     */
    fileprivate mutating func merge(with other: TinyJSON, typecheck: Bool = false) throws {

        switch other {
        case .array:
            self = TinyJSON(arrayValue + other.arrayValue)
        case .object:
            self = TinyJSON(dictionaryValue.merging(other.dictionaryValue, uniquingKeysWith: { _, new in
                new
            }))

        default:
            if typecheck {
                switch (other, self) {
                case (.string, .string),
                    (.bool, .bool),
                    (.number(.int), .number(.int)),
                    (.number(.double), .number(.double)),
                    (.null, _):
                    self = other
                default:
                    // assertionFailure(TinyJSONError.wrongType.rawValue)

                    throw TinyJSONError.wrongType
                }
            } else {
                self = other
            }
        }
    }

}
