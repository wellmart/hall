//
//  Hall
//
//  Copyright (c) 2020 Wellington Marthas
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import Adrenaline

public struct Query {
    let query: String
    let values: [SQLiteValue?]?
    
    public init(query: String, values: [SQLiteValue?]?) {
        self.query = query
        self.values = values
    }
}

extension Query: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.query = value
        self.values = nil
    }
}

extension Query: ExpressibleByStringInterpolation {
    public struct StringInterpolation: StringInterpolationProtocol {
        @usableFromInline
        var query: String
        
        @usableFromInline
        var values: [SQLiteValue?]
        
        public init(literalCapacity: Int, interpolationCount: Int) {
            self.query = String(reserveCapacity: literalCapacity + interpolationCount)
            self.values = [SQLiteValue?](reserveCapacity: interpolationCount)
        }
        
        @inlinable
        public mutating func appendLiteral(_ literal: String) {
            query.append(literal)
        }
        
        @inlinable
        public mutating func appendInterpolation<T: SQLiteValue>(_ value: T?) {
            query.append("?")
            values.append(value)
        }
        
        @inlinable
        public mutating func appendInterpolation<T: RawRepresentable>(_ value: T?) where T.RawValue == Int {
            appendInterpolation(value?.rawValue)
        }
        
        @inlinable
        public mutating func appendInterpolation(join elements: [Character], separator: String = "") {
            appendJoin(elements: elements) {
                return String($0)
            }
        }
        
        @inlinable
        public mutating func appendInterpolation(join elements: [Date], separator: String = "") {
            appendJoin(elements: elements) {
                return String(Int64($0.timeIntervalSinceReferenceDate))
            }
        }
        
        @inlinable
        public mutating func appendInterpolation(join elements: [Double], separator: String = "") {
            appendJoin(elements: elements) {
                return String($0)
            }
        }
        
        @inlinable
        public mutating func appendInterpolation(join elements: [Int], separator: String = "") {
            appendJoin(elements: elements) {
                return String($0)
            }
        }
        
        @inlinable
        public mutating func appendInterpolation(join elements: [String], separator: String = "") {
            appendJoin(elements: elements) {
                return $0
            }
        }
        
        @usableFromInline
        mutating func appendJoin<T>(elements: [T], separator: String = "", adaptee: (_ element: T) -> String) {
            var value = String(reserveCapacity: elements.count + (separator.count * elements.count))
            
            for element in elements {
                value.append(adaptee(element))
            }
            
            query.append("?")
            values.append(value)
        }
    }
    
    public init(stringInterpolation interpolation: StringInterpolation) {
        self.query = interpolation.query
        self.values = interpolation.values
    }
}
