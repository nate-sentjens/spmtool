import ArgumentParser
import Foundation

extension spmtool {

    struct NextVersion: ParsableCommand {

        // MARK: Internal

        static let configuration = CommandConfiguration()

        func run() throws {
            guard let currentVersion = try execute("git tag --sort=-version:refname | head -n 1") else {
                throw NextVersionError.notFound
            }

            let versionNumbers = currentVersion
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: ".")

            guard let formattedBuildNumber = versionNumbers.last.flatMap({ String($0) }),
                let buildNumber = Int(formattedBuildNumber) else
            {
                throw NextVersionError.invalidVersionNumber
            }

            let today = Date()
            let year = Calendar.current.component(.year, from: today) % 2000
            let week = Calendar.current.component(.weekOfYear, from: today)
            let nextVersion = "\(year).\(String(format: "%02d", week)).\(buildNumber + 1)"

            if let data = nextVersion.data(using: .utf8) {
                FileHandle.standardOutput.write(data)
            }
        }

        // MARK: Private

        @discardableResult
        private func execute(_ command: String) throws -> String? {
            let process = Process()
            process.launchPath = "/bin/bash"
            process.arguments = ["-l", "-c", command]

            let pipe = Pipe()
            process.standardOutput = pipe

            process.launch()
            process.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()

            if process.terminationStatus == 0 {
                return String(data: data, encoding: .utf8)
            } else {
                throw ScriptError.badExit(code: process.terminationStatus)
            }
        }
    }
}

// MARK: - NextVersionError

enum NextVersionError: Error {
    case notFound
    case invalidVersionNumber
}

// MARK: - ScriptError

enum ScriptError: Error {
    case badExit(code: Int32)
}
