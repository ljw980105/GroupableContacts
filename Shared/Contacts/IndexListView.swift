//
//  IndexListView.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 1/28/22.
//

import SwiftUI
import UIKit
import Combine

fileprivate struct Styles {
    static var rowWidth: CGFloat { 20 }
    static var rowHeight: CGFloat { 15 }
    /// non zero opacity to not be considered empty by gesture
    static var fillerViewColor: Color {
        Color(red: 1, green: 0, blue: 0, opacity: 0.01)
    }
}

struct IndexListView: View {
    let indexList: [String]
    @Binding var selectedIndex: String
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(indexList, id: \.self) { str in
                ZStack {
                    Rectangle() // increasing tappable area
                        .frame(
                            width: Styles.rowWidth,
                            height: Styles.rowHeight
                        )
                        .foregroundColor(Styles.fillerViewColor)
                    Text(str)
                        .font(.footnote)
                        .foregroundColor(Color.blue)
                        .frame(
                            width: Styles.rowWidth,
                            height: Styles.rowHeight,
                            alignment: .center
                        )
                }
            }
        }
        .frame(width: Styles.rowWidth)
        .padding(0)
        .background(Color.clear)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { value in
                    self.processDrag(value: value)
                }
        )
    }
    
    private func processDrag(value: DragGesture.Value) {
        let translation = value.translation.height + value.startLocation.y
        if translation < 0 {
            return
        }
        let height = translation
        let index = Int(height / Styles.rowHeight)
        if index > indexList.count - 1 {
            return
        }
        selectedIndex = indexList[index]
    }
}

struct IndexListView_Previews: PreviewProvider {
    static var previews: some View {
        IndexListView(
            indexList: "abcdefghijklmnopqrstuvwxyz"
                        .uppercased()
                        .map { String($0) },
            selectedIndex: .constant("")
        )
    }
}
