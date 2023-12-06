//
//  TimeHandler.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/06.
//

import Foundation

import Foundation


extension String {
    func parsingToDate() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = dateFormatter.date(from: self) else { return "날짜를 불러오지 못했습니다." }
        
        return date.compareNow()
    }
}

extension Date {
    func compareNow() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}


