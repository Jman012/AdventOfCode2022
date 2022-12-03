import Foundation

fileprivate extension Character {
	var score: Int {
		if self.isLowercase {
			return Int(self.asciiValue! - Character("a").asciiValue! + 1)
		} else {
			return Int(self.asciiValue! - Character("A").asciiValue! + 27)
		}
	}
}

public struct Day03: Challenge {
	
	public init() {}
	
	public func solvePart1(input: String) -> String {
		let rucksacks = input.split(separator: "\n")
		let scores = rucksacks.map({ rucksack in
			let comp1 = Set<Character>(rucksack[rucksack.startIndex..<rucksack.index(rucksack.startIndex, offsetBy: rucksack.count/2)])
			let comp2 = Set<Character>(rucksack[rucksack.index(rucksack.startIndex, offsetBy: rucksack.count/2)..<rucksack.endIndex])
			let inCommon = comp1.intersection(comp2)
			let firstInCommon = inCommon.first!
			return firstInCommon.score
		})
		
		return "\(scores.reduce(0, +))"
	}
	
	public func solvePart2(input: String) -> String {
		let rucksacks = input.split(separator: "\n")
		var groupsOfThree: [[String.SubSequence]] = []
		for (index, rucksack) in rucksacks.enumerated() {
			if index % 3 == 0 {
				groupsOfThree.append([])
			}
			var new = groupsOfThree.last!
			new.append(rucksack)
			groupsOfThree[groupsOfThree.count-1] = new
		}
		
		let scores = groupsOfThree.map({ group in
			let comp1 = Set<Character>(group[0])
			let comp2 = Set<Character>(group[1])
			let comp3 = Set<Character>(group[2])
			let inCommon = comp1.intersection(comp2).intersection(comp3)
			let firstInCommon = inCommon.first!
			return firstInCommon.score
		})
		
		return "\(scores.reduce(0, +))"
	}
	
}
