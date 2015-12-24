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

func stdio_test() {
	while(true) {
		let c = getc(stdin)
		if c == EOF { break }
		if putc(c, stdout) == EOF {
			print("output error: \(errorMessage(errno))")
		}
	}
	if Int(ferror(stdin)) != 0 {
		print("input error: \(errorMessage(errno))")
	}
	exit(0)
}

stdio_test()