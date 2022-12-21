import Foundation

public struct Day20: Challenge {
	
	public init() {}
	
	public func solvePart1(input: String) -> String {
		var numbers = input.split(separator: "\n").enumerated().map({ ($0.0, Int64(String($0.1))!) })
		
		var currentVirtualIndex = 0
//		print(numbers)
		
		for _ in 0..<numbers.count {
			let currentIndex = numbers.firstIndex(where: { $0.0 == currentVirtualIndex })!
			let (numIndex, num) = numbers[currentIndex]
			let oldIndex = currentIndex
			var newIndex = Int64(currentIndex) + num
			if newIndex > 0 {
				newIndex = newIndex + (newIndex / Int64(numbers.count))
//				if newIndex > numbers.count * 2 {
//					newIndex += 2
//				} else if newIndex > numbers.count {
//					newIndex += 1
//				}
			} else {
				newIndex = newIndex - (abs(newIndex) / Int64(numbers.count)) - 1
//				if newIndex > numbers.count {
//					newIndex -= 2
//				} else {
//					newIndex -= 1
//				}
			}
			if newIndex < 0 {
				newIndex += Int64(numbers.count) * ((abs(newIndex) / Int64(numbers.count)) + 1)
			}
			newIndex = newIndex % Int64(numbers.count)
//			if oldIndex + 1 == newIndex {
//				let after = numbers[newIndex]
//				numbers = [(Int, Int)](numbers[0..<oldIndex] + [after] + [(numIndex, num)] + numbers[(newIndex+1)...])
//			} else
			if oldIndex < newIndex {
				let before = numbers[0..<oldIndex]
				let middle = numbers[(oldIndex + 1)...Int(newIndex)]
				let after = numbers[(Int(newIndex)+1)...]
				numbers = before + middle + [(numIndex, num)] + after
//				numbers = [(Int, Int64)](numbers[0..<oldIndex] + numbers[(oldIndex + 1)...Int64(newIndex)] + [(numIndex, num)] + numbers[(Int64(newIndex)+1)...])
			} else if newIndex < oldIndex {
				let before = numbers[0..<Int(newIndex)]
				let middle = numbers[Int(newIndex)..<oldIndex]
				let after = numbers[(oldIndex+1)...]
				numbers = before + [(numIndex, num)] + middle + after
//				numbers = [(Int, Int64)](numbers[0..<Int64(newIndex)] + [(numIndex, num)] + numbers[Int64(newIndex)..<oldIndex] + numbers[(oldIndex+1)...])
			} // else no change
			
			currentVirtualIndex += 1
//			print(numbers)
		}
		
		let zeroIdx = numbers.firstIndex(where: { $0.1 == 0 })!
		let _1000 = (zeroIdx + 1000) % numbers.count
		let _2000 = (zeroIdx + 2000) % numbers.count
		let _3000 = (zeroIdx + 3000) % numbers.count
		
		let result = numbers[_1000].1 + numbers[_2000].1 + numbers[_3000].1
		
		return "\(result)"
	}
	
	public func solvePart2(input: String) -> String {
		var numbers = input.split(separator: "\n").enumerated().map({ ($0.0, Int64(String($0.1))! * 811589153) })
		
		var currentVirtualIndex = 0
		print(numbers)
		
		for _ in 0..<10 {
			for _ in 0..<numbers.count {
				let currentIndex = numbers.firstIndex(where: { $0.0 == currentVirtualIndex })!
				let (numIndex, num) = numbers[currentIndex]
				let oldIndex = currentIndex
				var newIndex = Int64(currentIndex) + num
				if newIndex > 0 {
					newIndex = newIndex + (newIndex / Int64(numbers.count))
				} else {
					newIndex = newIndex - (abs(newIndex) / Int64(numbers.count)) - 1
				}
				if newIndex < 0 {
					newIndex += Int64(numbers.count) * ((abs(newIndex) / Int64(numbers.count)) + 1)
				}
				newIndex = newIndex % Int64(numbers.count)
				if oldIndex < newIndex {
					let before = numbers[0..<oldIndex]
					let middle = numbers[(oldIndex + 1)...Int(newIndex)]
					let after = numbers[(Int(newIndex)+1)...]
					numbers = before + middle + [(numIndex, num)] + after
					//				numbers = [(Int, Int64)](numbers[0..<oldIndex] + numbers[(oldIndex + 1)...Int64(newIndex)] + [(numIndex, num)] + numbers[(Int64(newIndex)+1)...])
				} else if newIndex < oldIndex {
					let before = numbers[0..<Int(newIndex)]
					let middle = numbers[Int(newIndex)..<oldIndex]
					let after = numbers[(oldIndex+1)...]
					numbers = before + [(numIndex, num)] + middle + after
					//				numbers = [(Int, Int64)](numbers[0..<Int64(newIndex)] + [(numIndex, num)] + numbers[Int64(newIndex)..<oldIndex] + numbers[(oldIndex+1)...])
				} // else no change
				
				currentVirtualIndex = (currentVirtualIndex + 1) % numbers.count
				//			print(numbers)
			}
			print(numbers)
		}
		
		let zeroIdx = numbers.firstIndex(where: { $0.1 == 0 })!
		let _1000 = (zeroIdx + 1000) % numbers.count
		let _2000 = (zeroIdx + 2000) % numbers.count
		let _3000 = (zeroIdx + 3000) % numbers.count
		
		let result = numbers[_1000].1 + numbers[_2000].1 + numbers[_3000].1
		
		return "\(result)"
	}
	
}
