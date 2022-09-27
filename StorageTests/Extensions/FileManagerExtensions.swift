//
//  FileManagerExtensions.swift
//  StorageTests
//
//  Created by Kakeru Fukuda on 2022/09/27.
//

import Foundation

extension FileManager {
    internal var documentDirectory: URL {
        self.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
