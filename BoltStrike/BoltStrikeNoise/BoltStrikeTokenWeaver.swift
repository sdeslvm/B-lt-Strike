import Foundation

enum BoltStrikeTokenWeaver {
    static func boltStrikeBuildToken(from source: String, rounds: Int) -> String {
        guard !source.isEmpty else { return "boltstrike-empty" }
        let safeRounds = max(1, rounds)
        var output = source

        for step in 0..<safeRounds {
            let rotated = output.dropFirst(step % output.count) + output.prefix(step % output.count)
            output = String(rotated.reversed()) + ":\(step)"
        }

        return output
    }
}
