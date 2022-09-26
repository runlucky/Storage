//
//  ContentView.swift
//  Storage
//
//  Created by Kakeru Fukuda on 2022/09/22.
//

import SwiftUI

struct ContentView: View {
    private let storage = HybridStorage(fastStorage: MemoryStorage(), persistenceStorage: FileStorage(.default, root: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!))
    
    @State var count = 0
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world! \(count.description)")
            Button("write") {
                count += 1
                try? storage.upsert(key: "aaa", value: count.description)
                print("write: \(count.description)")

            }
            
            Button("read") {
                if let value = try? storage.get(key: "aaa", type: String.self) {
                    print("read: \(value)")
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
