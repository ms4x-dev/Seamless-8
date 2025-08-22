//
//  callc.swift
//  Seamless 8
//
//  Created by Richard on 13/8/2025.
//


@_silgen_name("rc_process_bytes")
func rc_process_bytes(_ inFmt: UInt32, _ outFmt: UInt32,
                      _ inPtr: UnsafePointer<UInt8>, _ inLen: Int,
                      _ outLen: inout UInt) -> UnsafeMutablePointer<UInt8>?

@_silgen_name("rc_free")
func rc_free(_ ptr: UnsafeMutablePointer<UInt8>?, _ len: UInt)

@_silgen_name("rc_process_file")
func rc_process_file(_ inFmt: UInt32, _ outFmt: UInt32,
                     _ inPath: UnsafePointer<CChar>?, _ outPath: UnsafePointer<CChar>?) -> Int32