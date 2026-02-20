import Foundation

struct BoltStrikeEntropyMixer {
    private var boltStrikeSeed: UInt64

    init(seed: UInt64) {
        self.boltStrikeSeed = seed
    }

    mutating func boltStrikeNextValue() -> UInt64 {
        boltStrikeSeed ^= boltStrikeSeed << 13
        boltStrikeSeed ^= boltStrikeSeed >> 7
        boltStrikeSeed ^= boltStrikeSeed << 17
        return boltStrikeSeed
    }

    mutating func boltStrikeGenerateSeries(count: Int) -> [UInt64] {
        guard count > 0 else { return [] }
        return (0..<count).map { _ in boltStrikeNextValue() }
    }
}
