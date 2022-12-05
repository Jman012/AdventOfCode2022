import Foundation

public struct Day05: Challenge {
	
	public init() {}
	
	class Crane {
		var stacks: [[Character]]
		
		init(input: String) {
			stacks = []
			for line in input.split(separator: "\n").reversed() {
				for (index, char) in line.enumerated() {
					if index > 0 && (index - 1) % 4 == 0 {
						if char.isNumber {
							stacks.append([])
						} else if char != " " {
							let newIndex = (index - 1) / 4
							stacks[newIndex].append(char)
						}
					}
				}
			}
		}
		
		func move(count: Int, from: Int, to: Int) {
			for _ in 0..<count {
				let item = stacks[from].popLast()!
				stacks[to].append(item)
			}
		}
		
		func move2(count: Int, from: Int, to: Int) {
			// Old, quick version
//			var items: [Character] = []
//			for _ in 0..<count {
//				let item = stacks[from].popLast()!
//				items.append(item)
//			}
//			stacks[to].append(contentsOf: items.reversed())
			
			// Better version
			let newFrom = stacks[from].dropLast(count)
			let items = stacks[from].dropFirst(stacks[from].count - count)
			stacks[from] = Array<Character>(newFrom)
			stacks[to].append(contentsOf: items)
		}
		
		func getResult() -> String {
			return String(stacks.compactMap({ $0.last }))
		}
	}
	
	public func solvePart1(input: String) -> String {
		let split = input.components(separatedBy: "\n\n")
		let start = split[0]
		let moves = split[1]
		let crane = Crane(input: String(start))
		
		for move in moves.split(separator: "\n") {
			let items = move.split(separator: " ")
			let count = Int(items[1])!
			let source = Int(items[3])! - 1
			let dest = Int(items[5])! - 1
			crane.move(count: count, from: source, to: dest)
		}
		return "\(crane.getResult())"
	}
	
	public func solvePart2(input: String) -> String {
		let split = input.components(separatedBy: "\n\n")
		let start = split[0]
		let moves = split[1]
		let crane = Crane(input: String(start))
		
		for move in moves.split(separator: "\n") {
			let items = move.split(separator: " ")
			let count = Int(items[1])!
			let source = Int(items[3])! - 1
			let dest = Int(items[5])! - 1
			crane.move2(count: count, from: source, to: dest)
		}
		return "\(crane.getResult())"
	}
	
}
