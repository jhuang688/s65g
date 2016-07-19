//: Playground - noun: a place where people can play

import UIKit

func isLeap(year: Int) -> Bool {
    return year % 400 == 0 ? true : year % 100 == 0 ? false : year % 4 == 0 ? true : false
}

let baseYear = 1900
let months30Days = [4, 6, 9, 11]

func julianDate(year: Int, month: Int, day: Int) -> Int {
    let yearDays = (baseYear..<year).reduce(0) { return isLeap($1) ? $0 + 366 : $0 + 365 }
    let monthDays = (1..<month).reduce(0) { return $1 == 2 ? isLeap(year) ? $0 + 29 : $0 + 28 : months30Days.contains($1) ? $0 + 30 : $0 + 31 }
    return yearDays + monthDays + day
}


julianDate(1960, month: 9, day: 28)
julianDate(1900, month: 1, day: 1)
julianDate(1900, month: 12, day: 31)
julianDate(1901, month: 1, day: 1)
julianDate(1901, month: 1, day: 1) - julianDate(1900, month: 1, day: 1)
julianDate(2001, month: 1, day: 1) - julianDate(2000, month: 1, day: 1)
isLeap(1960)
isLeap(1900)
isLeap(2000)
isLeap(1975)
