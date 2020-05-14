//
//  SourceEditorCommand.swift
//  ExpandSelection
//
//  Created by Kolyutsakul, Thongchai on 14/5/20.
//  Copyright © 2020 Thongchai Kolyutsakul. All rights reserved.
//

import Foundation
import XcodeKit

// First thing first. Shorten these long names...
typealias Range = XCSourceTextRange
typealias Position = XCSourceTextPosition
typealias Buffer = XCSourceTextBuffer

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

  func perform(with invocation: XCSourceEditorCommandInvocation,
               completionHandler: @escaping (Error?) -> Void ) -> Void {

    defer { completionHandler(nil) }

    // At least something is selected
    guard let selection = invocation.buffer.selections.firstObject as? Range else { return }
//    print(invocation.buffer.string(in: firstSelection))

    // Discard other selections in the buffer
    invocation.buffer.selections.removeAllObjects()
//    invocation.buffer.selections.add(Range(start: Position(0, 0), end: Position(0, 1)))
//    invocation.buffer.selections.add(Range(start: Position(1, 0), end: Position(1, 1)))

    // Get selectedString
    let selectedString = invocation.buffer.string(in: selection)
    guard !selectedString.isEmpty else { return }

    print("selectedString:", selectedString)

    // Find next selection of the same string
    if let nextRange = invocation.buffer.range(of: selectedString, after: selection.end) {
      // Add that next selection
      print("nextRange:", nextRange)
      invocation.buffer.selections.add(nextRange)
    }
    else {
      print("nextRange: not found")
    }

    // Done!

    // expr in Range(start: Position(line: 0, column: 0), end: Position(line: 0, column: 1))
//    sort(invocation.buffer.lines, in: firstSelection.start.line...lastSelection.end.line, by: <)
//    sort(invocation.buffer.lines, in: firstSelection.start.line...lastSelection.end.line, by: isLessThanIgnoringLeadingWhitespacesAndTabs)
  }

//  func sort(_ inputLines: NSMutableArray, in range: CountableClosedRange<Int>, by comparator: (String, String) -> Bool) {
//    guard range.upperBound < inputLines.count, range.lowerBound >= 0 else { return }
//    let lines = inputLines.compactMap { $0 as? String }
//    let sorted = Array(lines[range]).sorted(by: comparator)
//    for lineIndex in range {
//      inputLines[lineIndex] = sorted[lineIndex - range.lowerBound]
//    }
//  }

//  func isLessThanIgnoringLeadingWhitespacesAndTabs(_ lhs: String, _ rhs: String) -> Bool {
//    return lhs.trimmingCharacters(in: .whitespaces) < rhs.trimmingCharacters(in: .whitespaces)
//  }

}

extension Position {
  init(_ line: Int, _ column: Int) {
    self.init()
    self.line = line
    self.column = column
  }
}

extension Buffer {
  func string(in range: Range) -> String {
    // Only support one line for now
    let string = lines[range.start.line] as! String
    let begin = string.index(string.startIndex, offsetBy: range.start.column)
    let end = string.index(string.startIndex, offsetBy: range.end.column)
    return String(string[begin..<end])
  }

  func range(of string: String, after startPosition: Position) -> Range? {
    for line in startPosition.line...linesLastPosition.line {
      let string = lines[line] as? String ?? ""
      if let range = string.range(of: string) {
        return Range(start: Position(line, range.lowerBound.utf16Offset(in: string)),
                     end: Position(line, range.upperBound.utf16Offset(in: string)))
      }
    }
    return nil
  }

  var linesLastPosition: Position {
    Position(max(0, lines.count - 1), (lines.lastObject as? String)?.count ?? 0)
  }
}
