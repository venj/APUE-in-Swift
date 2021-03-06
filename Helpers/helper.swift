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

func errorMessage(errorNumber: Int32) -> String {
	return String.fromCString(strerror(errorNumber)) ?? "Unknown error"
}
