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

@frozen
public struct DateOnly {
    public let timeIntervalReference: TimeInterval
    
    @inlinable
    public init?(_ date: Date?) {
        guard let date = date else {
            return nil
        }
        
        self.init(date)
    }
    
    public init(_ timeIntervalReference: TimeInterval) {
        self.timeIntervalReference = timeIntervalReference
    }
    
    public init(_ date: Date, calendar: Calendar = .current) {
        self.timeIntervalReference = (date.timeIntervalSinceReferenceDate - TimeInterval(calendar.timeZone.secondsFromGMT())) / 86400
    }
    
    public func dateValue(calendar: Calendar = .current) -> Date {
        return Date(timeIntervalSinceReferenceDate: (timeIntervalReference + TimeInterval(calendar.timeZone.secondsFromGMT())) * 86400)
    }
}

extension DateOnly: SQLiteValue {
}