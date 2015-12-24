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

func io_test() {
	let buffSize = 4096
	let buf = UnsafeMutablePointer<CChar>.alloc(buffSize)

	while(true) {
		let n = read(STDIN_FILENO, buf, buffSize)
		if n == 0 { break }
		if n < 0 {
			print("Read error: \(errorMessage(errno))")
			break
		}
		if write(STDOUT_FILENO, buf, n) != n {
			print("Write error: \(errorMessage(errno))")
		}
	}
	exit(0)
}

io_test()