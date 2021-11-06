
//
//  Date+Extensions.swift
//  Date+Extensions
//
//  Created by 李昊堃 on 2021/9/28.
//


import Foundation
import SwiftUI

extension Date {

    public func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    public func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    public func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    public func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    public func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
    public func startOfDay() -> Date{
        Calendar.current.startOfDay(for: Date())
    }
    public var isInThisYear:  Bool { isInSameYear(as: Date()) }
    public var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    public var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    public var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    public var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    public var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    public var isInTheFuture: Bool { self > Date() }
    public var isInThePast:   Bool { self < Date() }
}

extension Date {
    /// 根据提供的参数将date转为相应的格式
    /// - Parameter format: 例如"dd MMM hh.mm" 1月20日 上午11:10
    /// - Returns: 相应的string类型
    public func toString(format: String = "yy dd MMM HH.mm") -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(format)
        formatter.locale = Locale.current

        return formatter.string(from: self)
    }
    
    ///生成一个可以用作文件名的String
    public func toFileNameString () -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYMMMdHHmmssSSSSSSZZZZZ"
        return formatter.string(from: self)
    }

    
    public func toStringAutoHideYear() -> String {
        var format: String
        if self.isInThisYear{
        format = "dd MMM HH.mm"
        }else{
            format = "yy dd MMM HH.mm"
        }
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(format)
        formatter.locale = Locale.current

        return formatter.string(from: self)
    
    }
    
    ///本地化返回 与今日的关系
    public func dateString() -> LocalizedStringKey{
        var formatter: String = "dd"
        if self.isInToday{
            return LocalizedStringKey("今天")
        }else if self.isInYesterday{
            return LocalizedStringKey("昨天")
        }else if self.isInTomorrow{
            return LocalizedStringKey("明天")
        }else{
         
            if !self.isInThisMonth{
                formatter = "MM" + formatter
            }
            if !self.isInThisYear{
                formatter = "yy" + formatter
            }
            
            return LocalizedStringKey(self.toString(format: formatter))
        }
    }
}

//让date支持appstorage
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

extension Date:ExpressibleByNilLiteral{
    public init(nilLiteral: ()) {
        self = Date()
    }
    
}

extension String{
    ///Date().tofilename 的逆函数
    public func fileNameToDate() -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYMMMdHHmmssSSSSSSZZZZZ"
        guard let dateData = self.components(separatedBy: ".png").first else {return nil}
        return formatter.date(from: dateData)
    }
}
