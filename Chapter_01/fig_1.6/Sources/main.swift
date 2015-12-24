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

func pid() {
	print("The pid of the current program is: \(Int(getpid()))")
	exit(0)
}

pid()