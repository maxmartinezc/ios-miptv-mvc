//
//  RegexHelpers.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 04-05-22.
//

import Foundation

struct RegularExpression {
  let regex: NSRegularExpression

  init(_ regex: NSRegularExpression) {
    self.regex = regex
  }

  func firstMatch(in source: String) -> String? {
    let sourceRange = NSRange(source.startIndex..<source.endIndex, in: source)
    guard
      let match = regex.firstMatch(in: source, range: sourceRange),
      let range = Range(match.range(at: 1), in: source)
    else {
      return nil
    }
    return String(source[range])
  }
}

extension RegularExpression: ExpressibleByStringLiteral {
  init(stringLiteral value: String) {
    let regex = try! NSRegularExpression(pattern: value, options: [])
    self.init(regex)
  }
}
