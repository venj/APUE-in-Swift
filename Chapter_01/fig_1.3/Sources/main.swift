//
//  fig_1.3.swift
//  
//
//  Created by 朱文杰 on 15/12/23.
//
//
#if os(Linux)
import Glibc
#else
import Darwin
#endif

func ls() {
    let arguments = Process.arguments

    guard arguments.count == 2 else {
        print("Usage: ls directory_name")
        exit(255)
    }

    let directory = arguments[1]
    let dp = opendir(directory)
    if dp == nil {
        print("can not open \(directory): \(errorMessage(errno))")
        exit(255)
    }

    while true {
        let dirp = readdir(dp)
        if dirp == nil {
            break
        }
        // FIXME: Magic! Just leave a mark here.
        // Code copied from swift-package-manager/Sources/sys/walk.swift
        var dirName = dirp.memory.d_name
        let name = withUnsafePointer(&dirName) { (ptr) -> String in
            return String.fromCString(UnsafePointer<CChar>(ptr)) ?? ""
        }
        print(name)
    }

    closedir(dp)
    exit(0)
}

ls()
