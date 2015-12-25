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
/**

Note for this example:

This example is very much different to the C version of the example in the APUE book. Because fork() and execlp() is not available in swift.
So I copied many code from the swift package manager that deals with posix_spawn*(). 

Since I'm not quite familiar with process calls in Unix, this example is problmetic and I changed some part of the error-catch codes to simplify
this example. At last, it works, but with much limitation and bug. I will improve this example later on when I get to know more about Unix.

*/

// <--------- Start of code copied from Swift Package Manager
private func _getenv(key: String) -> String? {
    let out = getenv(key)
    return out == nil ? nil : String.fromCString(out)  //FIXME locale may not be UTF8
}

/// Convenience wrapper for posix_spawn.
func posix_spawnp(path: String, args: [String], environment: [String: String] = [:], fileActions: posix_spawn_file_actions_t? = nil) -> pid_t {
    var environment = environment
    let argv = args.map{ $0.withCString(strdup) }
    defer { for arg in argv { free(arg) } }

    /* for key in ["PATH", "SDKROOT", "HOME", "SWIFTC"] {
        if let value = _getenv(key) {
            environment[key] = value
        }
    } */

    let env = environment.map{ "\($0.0)=\($0.1)".withCString(strdup) }
    defer { env.forEach{ free($0) } }

    var pid = pid_t()
    let rv: Int32
    if let fileActions = fileActions {
        // required for the `&fileActions` inout parameter
        var fileActions = fileActions
        rv = posix_spawnp(&pid, argv[0], &fileActions, nil, argv + [nil], env + [nil])
    } else {
        rv = posix_spawnp(&pid, argv[0], nil, nil, argv + [nil], env + [nil])
    }
    guard rv == 0 else {
        perror("posix_spawn")
        exit(255)
    }

    return pid
}

private func _WSTATUS(status: CInt) -> CInt {
    return status & 0x7f
}

private func WIFEXITED(status: CInt) -> Bool {
    return _WSTATUS(status) == 0
}

private func WEXITSTATUS(status: CInt) -> CInt {
    return (status >> 8) & 0xff
}

/// convenience wrapper for waitpid
func _waitpid(pid: pid_t) -> Int32 {
    while true {
        var exitStatus: Int32 = 0
        let rv = waitpid(pid, &exitStatus, 0)

        if rv != -1 {
            if WIFEXITED(exitStatus) {
                return WEXITSTATUS(exitStatus)
            } else {
                errorMessage(errno)
                exit(255)
            }
        } else if errno == EINTR {
            continue  // see: man waitpid
        } else {
            errorMessage(errno)
            exit(255)
        }
    }
}

// ---------> End of code copied from Swift Package Manager

func split_command(command:String) -> [String] {
    var comps = [String]()
    var tempChars = [Character]()
    command.characters.forEach {
        if String($0) != " " {
            tempChars.append($0)
        }
        else {
            if tempChars.count > 0 {
                comps.append(String(tempChars))
            }
            tempChars = []
        }
    }
    comps.append(String(tempChars))

    return comps
}

func tiny_shell() {
    let buffSize = 4096 // ?
    let buff = UnsafeMutablePointer<CChar>.alloc(buffSize)
    defer { if buff != nil { free(buff) } }
    print("% ", terminator:"")
    while fgets(buff, Int32(buffSize), stdin) != nil {
        var command = String.fromCString(buff)!
        if command.characters.last == "\n" {
            command = command[command.startIndex..<(command.endIndex.advancedBy(-1))]
        }

        let argv = split_command(command)
        var pid = posix_spawnp(argv[0], args: argv)
        
        pid = _waitpid(pid)
        if pid != 0 {
            print("wait error: \(errorMessage(errno))")
            exit(255)
        }
        print("% ", terminator:"")
    }
    
    exit(0)
}

tiny_shell()
