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
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        completionHandler(nil)
    }
    
}
