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

func error_test() {
	print("EACCES: \(String.fromCString(strerror(EACCES))!)")
	errno = ENOENT
	perror(Process.arguments[0])
	exit(0)
}

error_test()