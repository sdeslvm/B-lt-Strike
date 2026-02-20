import Foundation

final class BoltStrikeGridSynthesizer {
    private(set) var boltStrikeGrid: [[Int]]

    init(size: Int) {
        let safeSize = max(1, size)
        self.boltStrikeGrid = Array(
            repeating: Array(repeating: 0, count: safeSize),
            count: safeSize
        )
    }

    func boltStrikeStampDiagonal(value: Int) {
        for index in 0..<boltStrikeGrid.count {
            boltStrikeGrid[index][index] = value + index
        }
    }

    func boltStrikeChecksum() -> Int {
        boltStrikeGrid.flatMap { $0 }.reduce(0, +)
    }
}
