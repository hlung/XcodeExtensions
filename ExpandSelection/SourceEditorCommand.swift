//
//  SourceEditorCommand.swift
//  ExpandSelection
//
//  Created by Kolyutsakul, Thongchai on 14/5/20.
//  Copyright © 2020 Thongchai Kolyutsakul. All rights reserved.
//

import Foundation
import XcodeKit
import AppKit

enum CommandError: Error {
  case noSelection
  case noMoreMatch
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

  func perform(with invocation: XCSourceEditorCommandInvocation,
               completionHandler: @escaping (Error?) -> Void ) -> Void {

    NSSound.beep()

    defer { completionHandler(nil) }

    // At least something is selected
    guard let firstSelection = invocation.buffer.selections.firstObject as? XCSourceTextRange else { return }
//    print(invocation.buffer.string(in: firstSelection))

    // Get selectedString
    let selectedString = invocation.buffer.string(in: firstSelection)
    guard !selectedString.isEmpty else { return }
//    print("SourceEditorCommand", "selected:", selectedString)

    // Discard unmatched selections
    for i in (0..<invocation.buffer.selections.count).reversed() {
      let selection = invocation.buffer.selections[i] as! XCSourceTextRange
      let str = invocation.buffer.string(in: selection)
      if str != selectedString {
        invocation.buffer.selections.removeObject(at: i)
      }
    }

    guard let lastSelection = invocation.buffer.selections.lastObject as? XCSourceTextRange else { return }

    // Find next selection of the same string after lastSelection
    if let nextRange = invocation.buffer.range(of: selectedString, after: lastSelection.end) {
      // Add that next selection
      print("SourceEditorCommand", "nextRange:", nextRange)
      invocation.buffer.selections.add(nextRange)
    }
    else {
//      NSSound.beep()
      print("SourceEditorCommand", "nextRange:", "not found")
    }

    // Done!

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

private extension XCSourceTextPosition {
  init(_ line: Int, _ column: Int) {
    self.init()
    self.line = line
    self.column = column
  }
}

private extension XCSourceTextBuffer {
  var linesAsString: [String] { lines as! [String] }

  func string(in range: XCSourceTextRange) -> String {
    linesAsString.string(in: range)
  }

  func range(of string: String, after startPosition: XCSourceTextPosition) -> XCSourceTextRange? {
    linesAsString.range(of: string, after: startPosition)
  }

  var linesLastPosition: XCSourceTextPosition {
    linesAsString.linesLastPosition
  }
}

private extension Array where Element == String {
  func string(in range: XCSourceTextRange) -> String {
    // Only support one line for now
    let string = self[range.start.line]
    let begin = string.index(string.startIndex, offsetBy: range.start.column)
    let end = string.index(string.startIndex, offsetBy: range.end.column)
    return String(string[begin..<end])
  }

  func range(of string: String, after startPosition: XCSourceTextPosition) -> XCSourceTextRange? {
    var startOffset = startPosition.column
    for line in startPosition.line...linesLastPosition.line {
      let lineString = self[line]
      if let range = lineString.range(of: string,
                                      options: .caseInsensitive,
                                      range: lineString.index(lineString.startIndex, offsetBy: startOffset)..<lineString.endIndex,
                                      locale: nil) {
        return XCSourceTextRange(start: XCSourceTextPosition(line, range.lowerBound.utf16Offset(in: lineString)),
                     end: XCSourceTextPosition(line, range.upperBound.utf16Offset(in: lineString)))
      }
      startOffset = 0
    }
    return nil
  }

  var linesLastPosition: XCSourceTextPosition {
    let line = count > 0 ? count - 1 : 0
    return XCSourceTextPosition(line, last?.count ?? 0)
  }
}

