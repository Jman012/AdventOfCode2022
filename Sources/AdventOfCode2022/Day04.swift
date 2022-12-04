import Foundation

public struct Day04: Challenge {
	
	public init() {}
	
	public func solvePart1(input: String) -> String {
		let pairs = input.split(separator: "\n")
		let scores = pairs.map({ pair in
			let elves = pair.split(separator: ",")
			let range1 = elves[0].split(separator: "-").map { Int($0)! }
			let range2 = elves[1].split(separator: "-").map { Int($0)! }
			let rangea = range1[0]...range1[1]
			let rangeb = range2[0]...range2[1]
			
			if rangea.lowerBound >= rangeb.lowerBound && rangea.upperBound <= rangeb.upperBound {
				return 1
			} else if rangeb.lowerBound >= rangea.lowerBound && rangeb.upperBound <= rangea.upperBound {
				return 1
			} else {
				return 0
			}
		})
		return "\(scores.reduce(0, +))"
	}
	
	public func solvePart2(input: String) -> String {
		let pairs = input.split(separator: "\n")
		let scores = pairs.map({ pair in
			let elves = pair.split(separator: ",")
			let range1 = elves[0].split(separator: "-").map { Int($0)! }
			let range2 = elves[1].split(separator: "-").map { Int($0)! }
			let rangea = range1[0]...range1[1]
			let rangeb = range2[0]...range2[1]
			
			if !Set(rangea).intersection(Set(rangeb)).isEmpty {
				return 1
			} else {
				return 0
			}
		})
		return "\(scores.reduce(0, +))"
	}
	
}
