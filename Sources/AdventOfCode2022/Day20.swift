import Foundation

public struct Day20: Challenge {
	
	public init() {}
	
//	func solve(input: String, multiplier: Int64, rounds: Int) -> Int64 {
//		var numbers = input.split(separator: "\n").enumerated().map({ (Int64($0.0), Int64(String($0.1))! * multiplier) })
//		let numbersCount = Int64(numbers.count)
//
//		var currentVirtualIndex: Int64 = 0
//		print("Initial:")
//		print(numbers)
//
//		for i in 0..<(numbers.count * rounds) {
//			let currentIndex = numbers.firstIndex(where: { $0.0 == currentVirtualIndex })!
//			let (numIndex, num) = numbers[currentIndex]
//			var newIndexTemp: Int64 = Int64(currentIndex) + num
//			newIndexTemp += num / numbersCount // for wrap-around handling
//			let newIndex = Int(((newIndexTemp % numbersCount) + numbersCount) % numbersCount)
//
//			if currentIndex < newIndex && num > 0 {
//				// Strat: forward & after newIndex
//				let before = numbers[0..<currentIndex]
//				let middle = numbers[(currentIndex + 1)...newIndex]
//				let after = numbers[(newIndex+1)...]
//				numbers = before + middle + [(numIndex, num)] + after
//			} else if currentIndex < newIndex && num < 0 {
//				// Strat: forward & before newIndex
//				let before = numbers[0..<currentIndex]
//				let middle = numbers[(currentIndex + 1)..<newIndex]
//				let after = numbers[newIndex...]
//				numbers = before + middle + [(numIndex, num)] + after
//			} else if newIndex < currentIndex && num > 0 {
//				// Strat: backwards & after
//				let before = numbers[0...newIndex]
//				let middle = numbers[(newIndex+1)..<currentIndex]
//				let after = numbers[(currentIndex+1)...]
//				numbers = before + [(numIndex, num)] + middle + after
//			} else if newIndex < currentIndex && num < 0 {
//				// Strat: backwards & before
//				let before = numbers[0..<newIndex]
//				let middle = numbers[newIndex..<currentIndex]
//				let after = numbers[(currentIndex+1)...]
//				numbers = before + [(numIndex, num)] + middle + after
//			} // else no change
//
//			currentVirtualIndex += 1
//			currentVirtualIndex %= numbersCount
//
//			if (i+1) % Int(numbersCount) == 0 {
//				print("After \(i / Int(numbersCount)) round(s) of mixing:")
//				print(numbers)
//			}
//		}
//
//		let zeroIdx = numbers.firstIndex(where: { $0.1 == 0 })!
//		let _1000 = (zeroIdx + 1000) % numbers.count
//		let _2000 = (zeroIdx + 2000) % numbers.count
//		let _3000 = (zeroIdx + 3000) % numbers.count
//
//		let result = numbers[_1000].1 + numbers[_2000].1 + numbers[_3000].1
//		return result
//	}
	
	func solve(input: String, multiplier: Int64, rounds: Int) -> Int64 {
		var numbers = input.split(separator: "\n").enumerated().map({ (Int64($0.0), Int64(String($0.1))! * multiplier) })
		
		var currentVirtualIndex: Int64 = 0
//		print("Initial:")
//		print(numbers)
		
		for _ in 0..<(numbers.count * rounds) {
			let currentIndex = numbers.firstIndex(where: { $0.0 == currentVirtualIndex })!
			let (numIndex, num) = numbers[currentIndex]
			
			_ = numbers.remove(at: currentIndex)
			
			let newIndexTemp: Int64 = Int64(currentIndex) + num
//			newIndexTemp += num / numbersCount // for wrap-around handling
			let newIndex = Int(((newIndexTemp % Int64(numbers.count)) + Int64(numbers.count)) % Int64(numbers.count))
			
			numbers.insert((numIndex, num), at: newIndex)
			
			currentVirtualIndex += 1
			currentVirtualIndex %= Int64(numbers.count)
			
//			if (i+1) % numbers.count == 0 {
//				print("After \(i / numbers.count) round(s) of mixing:")
//				print(numbers)
//			}
		}
		
		let zeroIdx = numbers.firstIndex(where: { $0.1 == 0 })!
		let _1000 = (zeroIdx + 1000) % numbers.count
		let _2000 = (zeroIdx + 2000) % numbers.count
		let _3000 = (zeroIdx + 3000) % numbers.count
		
		let result = numbers[_1000].1 + numbers[_2000].1 + numbers[_3000].1
		return result
	}
	
	public func solvePart1(input: String) -> String {
		return "\(solve(input: input, multiplier: 1, rounds: 1))"
	}
	
	public func solvePart2(input: String) -> String {
		return "\(solve(input: input, multiplier: 811589153, rounds: 10))"
	}
	
}
