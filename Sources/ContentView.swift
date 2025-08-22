//
//  ContentView.swift
//  Seamless 8
//

//  Created by Richard on 13/8/2025.
//

import SwiftUI

enum DataFormat: UInt32, CaseIterable, Identifiable {
    case json = 0, protobuf = 1, binary = 2, hex = 3, hdf5 = 4
    var id: UInt32 { rawValue }
    var label: String {
        switch self {
        case .json: return "JSON"
        case .protobuf: return "Protobuf"
        case .binary: return "Binary"
        case .hex: return "Hex"
        case .hdf5: return "HDF5 (file)"
        }
    }
}

struct ContentView: View {
    @State private var inputFormat: DataFormat = .json
    @State private var outputFormat: DataFormat = .protobuf
    @State private var inputText: String = ""
    @State private var outputText: String = ""
    @State private var inFileURL: URL?
    @State private var outFileURL: URL?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Picker("Input", selection: $inputFormat) {
                    ForEach(DataFormat.allCases) { f in Text(f.label).tag(f) }
                }.pickerStyle(.menu)
                Picker("Output", selection: $outputFormat) {
                    ForEach(DataFormat.allCases) { f in Text(f.label).tag(f) }
                }.pickerStyle(.menu)
                Spacer()
            }

            if inputFormat == .hdf5 || outputFormat == .hdf5 {
                HStack {
                    Button("Choose Input File") { inFileURL = openPanel() }
                    Text(inFileURL?.lastPathComponent ?? "No file").foregroundStyle(.secondary)
                    Spacer()
                    Button("Choose Output File") { outFileURL = savePanel(suggested: "output") }
                    Text(outFileURL?.lastPathComponent ?? "None").foregroundStyle(.secondary)
                }
            } else {
                Text("Input")
                TextEditor(text: $inputText).font(.system(.body, design: .monospaced)).frame(minHeight: 140)
                Text("Output")
                TextEditor(text: $outputText).font(.system(.body, design: .monospaced)).frame(minHeight: 140)
            }

            HStack {
                Button("Process") { process() }
                Spacer()
            }
        }
        .padding()
        .frame(minWidth: 820, minHeight: 520)
    }

    func process() {
        if inputFormat == .hdf5 || outputFormat == .hdf5 {
            guard let inURL = inFileURL, let outURL = outFileURL else { return }
            let rc = rc_process_file(inputFormat.rawValue, outputFormat.rawValue,
                                     inURL.path.cString(using: .utf8), outURL.path.cString(using: .utf8))
            outputText = "rc_process_file -> \(rc)  (\(inURL.lastPathComponent) -> \(outURL.lastPathComponent))"
        } else {
            let bytes = [UInt8](inputText.utf8)
            var outLen: UInt = 0
            if let ptr = rc_process_bytes(inputFormat.rawValue, outputFormat.rawValue, bytes, bytes.count, &outLen),
               outLen > 0 {
                let out = Data(bytes: ptr, count: Int(outLen))
                rc_free(ptr, outLen)
                if outputFormat == .binary {
                    outputText = "Binary (\(out.count) bytes)"
                } else {
                    outputText = String(decoding: out, as: UTF8.self)
                }
            } else {
                outputText = "Conversion failed."
            }
        }
    }

    func openPanel() -> URL? {
        let p = NSOpenPanel()
        p.canChooseFiles = true
        p.canChooseDirectories = false
        p.allowsMultipleSelection = false
        return p.runModal() == .OK ? p.url : nil
    }
    func savePanel(suggested: String) -> URL? {
        let p = NSSavePanel()
        p.nameFieldStringValue = suggested
        return p.runModal() == .OK ? p.url : nil
    }
}
