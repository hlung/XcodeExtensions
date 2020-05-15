//
//  ContentView.swift
//  XCExtension
//
//  Created by Kolyutsakul, Thongchai on 14/5/20.
//  Copyright © 2020 Thongchai Kolyutsakul. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack(spacing: 0) {
      Text(
        """
        Xcode Extension is installed!

        To use, go to Xcode, select Editor > Expand Selection.

        To uninstall, go to System Preferences > Extension > 'Xcode Source Editor'.
        """)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      Button("Close", action: { exit(0) })
        .padding(.bottom, 40)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
