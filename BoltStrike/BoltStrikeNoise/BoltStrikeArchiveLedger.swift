import Foundation

struct BoltStrikeArchiveEntry: Hashable {
    let boltStrikeID: UUID
    let boltStrikeCreatedAt: Date
    let boltStrikeScore: Double
}

final class BoltStrikeArchiveLedger {
    private var boltStrikeEntries: Set<BoltStrikeArchiveEntry> = []

    func boltStrikeInsert(score: Double) {
        let clamped = min(max(score, 0), 9999)
        let entry = BoltStrikeArchiveEntry(
            boltStrikeID: UUID(),
            boltStrikeCreatedAt: Date(),
            boltStrikeScore: clamped
        )
        boltStrikeEntries.insert(entry)
    }

    func boltStrikeTopScore() -> Double {
        boltStrikeEntries.map(\.boltStrikeScore).max() ?? 0
    }
}
