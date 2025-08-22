//
//  ViewController.swift
//  Seamless 8
//
//  Created by Richard on 22/8/2025.
//

import Cocoa
import RustCore // make sure RustCore.xcframework is linked in your project

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Test rc_version() from Rust
        if let versionCString = rc_version() {
            let versionString = String(cString: versionCString)
            print("RustCore version: \(versionString)")
        } else {
            print("Failed to get RustCore version")
        }

        // Optional: test rc_process_bytes with JSON input -> JSON output
        let jsonInput = """
        {"fields": {"example": "value"}, "values": [1, 2, 3]}
        """
        if let inputData = jsonInput.data(using: .utf8) {
            var outputLength: Int = 0
            let outputPointer = inputData.withUnsafeBytes { ptr -> UnsafeMutablePointer<UInt8>? in
                return rc_process_bytes(0, 0, ptr.baseAddress?.assumingMemoryBound(to: UInt8.self), inputData.count, &outputLength)
            }
            if let outputPointer = outputPointer, outputLength > 0 {
                let outputData = Data(bytes: outputPointer, count: outputLength)
                // Free Rust-allocated memory
                rc_free(outputPointer, outputLength)
                if let outputString = String(data: outputData, encoding: .utf8) {
                    print("Rust processed JSON -> JSON output: \(outputString)")
                }
            } else {
                print("Rust failed to process bytes")
            }
        }
    }
}
