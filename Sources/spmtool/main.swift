import ArgumentParser

// MARK: - spmtool

struct spmtool: ParsableCommand {

    // MARK: Internal

    static let configuration = CommandConfiguration(
        abstract: "Versioning tool for Swift packages.",
        subcommands: [NextVersion.self])
}

spmtool.main()
