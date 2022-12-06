import Foundation

public struct Day06: Challenge {
	
	public init() {}
	
	public func solvePart1(input: String) -> String {
		let lookback = 4
		for (index, _) in input.enumerated() {
			guard index >= lookback else {
				continue
			}
			
			let i = input.index(input.startIndex, offsetBy: index - lookback)
			let j = input.index(input.startIndex, offsetBy: index)
			if Set(input[i..<j]).count == lookback {
				return "\(index)"
			}
		}
		return "error"
	}
	
	public func solvePart2(input: String) -> String {
		let lookback = 14
		for (index, _) in input.enumerated() {
			guard index >= lookback else {
				continue
			}
			
			let i = input.index(input.startIndex, offsetBy: index - lookback)
			let j = input.index(input.startIndex, offsetBy: index)
			if Set(input[i..<j]).count == lookback {
				return "\(index)"
			}
		}
		return "error"
	}
	
}
