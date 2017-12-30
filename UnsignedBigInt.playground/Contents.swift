import PlaygroundSupport
import UIKit

struct UnsignedBigInt {
  init(_ value: UInt) {
    let lower = value % UnsignedBigInt.maxGroupValue
    let upper = value / UnsignedBigInt.maxGroupValue
    digitGroups = upper > 0 ? [lower, upper] : [lower]
  }

  private init(_ groups: [UInt]) {
    digitGroups = groups
  }

  private var digitGroups: [UInt] = []
  private static let maxGroupValue: UInt = 100000000000000000

  func add(value: UnsignedBigInt) -> UnsignedBigInt {
    var carry: UInt = 0
    var result: [UInt] = []
    for index in (0 ..< max(digitGroups.count, value.digitGroups.count)) {
      let left: UInt = index < digitGroups.count ? digitGroups[index] : 0
      let right: UInt = index < value.digitGroups.count ? value.digitGroups[index] : 0
      var group = left + right + carry
      carry = group / UnsignedBigInt.maxGroupValue
      group %= UnsignedBigInt.maxGroupValue
      result.append(group)
    }
    if carry > 0 {
      result.append(carry)
    }
    return UnsignedBigInt(result)
  }

  static func fibonacci(index: UInt) -> UnsignedBigInt {
    guard index > 1 else {
      return UnsignedBigInt(index)
    }
    var previous: UnsignedBigInt = 1
    var current: UnsignedBigInt = 1
    for _ in 2 ..< index {
      let temp = current
      current = current + previous
      previous = temp
    }
    return current
  }
}

extension UnsignedBigInt: ExpressibleByIntegerLiteral {
  typealias IntegerLiteralType = UInt
  init(integerLiteral value: UInt) {
    self.init(value)
  }
}

extension UnsignedBigInt: CustomStringConvertible {
  var description: String {
    return digitGroups.reversed().reduce("", { $0 + $1.description})
  }
}

func + (lhs: UnsignedBigInt, rhs: UnsignedBigInt) -> UnsignedBigInt {
  return lhs.add(value: rhs)
}

let formatter = NumberFormatter()
formatter.numberStyle = .ordinal
let numbers = [0,46,88,200]
print("Check answers here: http://www.maths.surrey.ac.uk/hosted-sites/R.Knott/Fibonacci/fibtable.html")
numbers.forEach { index in
  let ordinal = formatter.string(for: index) ?? ""
  let fib = UnsignedBigInt.fibonacci(index: UInt(index))
  print("The \(ordinal) Fibonacci number is \(fib)")
}


