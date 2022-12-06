import Foundation

public struct Day06Optimized: Challenge {
	
	public init() {}
	
	func solve(input: [Character], lookback: Int) -> String {
		var slidingWindow: [Character: Int] = [:]
		for (index, char) in input.enumerated() {
			// Increment the new char for the sliding window
			slidingWindow[char] = (slidingWindow[char] ?? 0) + 1
			
			if index >= lookback {
				// Decrement the popped char
				let oldChar = input[index - lookback]
				let oldCharCount = slidingWindow[oldChar]! - 1
				
				// If it goes to 0, remove from the sliding window, else decrement
				if oldCharCount == 0 {
					slidingWindow.removeValue(forKey: oldChar)
				} else {
					slidingWindow[oldChar] = oldCharCount
				}
				
				// If the sliding window count equals the lookback length, there's
				// one of each.
				if slidingWindow.count == lookback {
					return "\(index+1)"
				}
			}
		}
		return "error"
	}
	
	public func solvePart1(input: String) -> String {
		return solve(input: [Character](input), lookback: 4)
	}
	
	public func solvePart2(input: String) -> String {
		return solve(input: [Character](input), lookback: 14)
	}
	
}
