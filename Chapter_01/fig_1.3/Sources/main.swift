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

import Foundation

func ls() {
    let arguments = Process.arguments

    guard arguments.count == 2 else {
        print("Usage: ls directory_name")
        exit(255)
    }

    let directory = arguments[1]
    let dp = opendir(directory)
    if dp == nil {
        print("can not open \(directory)")
        exit(255)
    }

    while (true) {
        let dirp = readdir(dp)
        if dirp == nil {
            break
        }
        //TODO: dirent structure's d_name member is imported as a Tuple with
        //       1024 members! Why not import it as UnsafePointer<CChar>?
        //
        //      I don't know how to convert it to a String yet. So leave the
        //      problem here.
        //
        //print(dirp.memory.d_name)
    }
    
    closedir(dp)
    exit(0)
}

ls()
