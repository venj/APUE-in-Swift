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

func id_test() {
	print("UID: \(Int(getuid())), GID: \(Int(getgid()))")
	exit(0)
}

id_test()