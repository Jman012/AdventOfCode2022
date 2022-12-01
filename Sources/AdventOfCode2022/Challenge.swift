import Foundation

public protocol Challenge {
	func solvePart1(input: String) -> String
	func solvePart2(input: String) -> String
}

extension String {
	func parseLinesToInts() -> [Int] {
		return self
			.split(separator: "\n")
			.map({ Int($0)! })
	}
}

