import Foundation

public struct Day01: Challenge {
	
	public init() {}
	
	public func solvePart1(input: String) -> String {
		return "\(findElves(input: input).max()!)"
	}
	
	public func solvePart2(input: String) -> String {
		var elves = findElves(input: input)
		elves = elves.sorted().reversed()
		return "\(elves[0] + elves[1] + elves[2])"
	}
	
	func findElves(input: String) -> [Int] {
		let numbers = input.parseLinesToIntsOptional()
		var elves: [Int] = [0]
		
		for num in numbers {
			if let num = num {
				elves[elves.count-1] = elves[elves.count-1] + num
			} else {
				elves.append(0)
			}
		}
		
		return elves
	}
}
