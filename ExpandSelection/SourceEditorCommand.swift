//
//  SourceEditorCommand.swift
//  ExpandSelection
//
//  Created by Kolyutsakul, Thongchai on 14/5/20.
//  Copyright © 2020 Thongchai Kolyutsakul. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

  func perform(with invocation: XCSourceEditorCommandInvocation,
               completionHandler: @escaping (Error?) -> Void ) -> Void {

    defer { completionHandler(nil) }

    // At least something is selected
    guard let firstSelection = invocation.buffer.selections.firstObject as? XCSourceTextRange,
      let lastSelection = invocation.buffer.selections.lastObject as? XCSourceTextRange else {
        return
    }

    // More than one line is selected
    guard firstSelection.start.line < lastSelection.end.line else { return }

    // sort(invocation.buffer.lines, in: firstSelection.start.line...lastSelection.end.line, by: <)
    sort(invocation.buffer.lines, in: firstSelection.start.line...lastSelection.end.line, by: isLessThanIgnoringLeadingWhitespacesAndTabs)
  }


  func sort(_ inputLines: NSMutableArray, in range: CountableClosedRange<Int>, by comparator: (String, String) -> Bool) {
    guard range.upperBound < inputLines.count, range.lowerBound >= 0 else { return }
    let lines = inputLines.compactMap { $0 as? String }
    let sorted = Array(lines[range]).sorted(by: comparator)
    for lineIndex in range {
      inputLines[lineIndex] = sorted[lineIndex - range.lowerBound]
    }
  }

  func isLessThanIgnoringLeadingWhitespacesAndTabs(_ lhs: String, _ rhs: String) -> Bool {
    return lhs.trimmingCharacters(in: .whitespaces) < rhs.trimmingCharacters(in: .whitespaces)
  }

}
