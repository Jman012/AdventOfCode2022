import Foundation

public struct Day13: Challenge {
	
	public init() {}
	
	func solve(leftArray: NSArray, rightArray: NSArray) -> Bool? {
		if leftArray.count == 0 && rightArray.count > 0 {
			return true
		} else if leftArray.count > 0 && rightArray.count == 0 {
			return false
		} else if leftArray.count == 0 && rightArray.count == 0 {
			return nil
		}
		
		for i in 0..<min(leftArray.count, rightArray.count) {
			let left = leftArray[i]
			let right = rightArray[i]
			
			if let left = left as? Int, let right = right as? Int {
				if left == right {
					continue
				} else if left < right {
					return true
				} else {
					// left > right
					return false
				}
			} else if let left = left as? NSArray, let right = right as? NSArray {
				if let solution = solve(leftArray: left, rightArray: right) {
					return solution
				}
			} else if let left = left as? Int, let right = right as? NSArray {
				if let solution = solve(leftArray: [left], rightArray: right) {
					return solution
				}
			} else if let left = left as? NSArray, let right = right as? Int {
				if let solution = solve(leftArray: left, rightArray: [right]) {
					return solution
				}
			}
		}
		
		if leftArray.count < rightArray.count {
			return true
		} else if leftArray.count > rightArray.count {
			return false
		} else {
			return nil
		}
	}
	
	public func solvePart1(input: String) -> String {
		let pairs = input.components(separatedBy: "\n\n")
		var indicesInOrder: [Int] = []
		for (i, pair) in pairs.enumerated() {
			let split = pair.split(separator: "\n")
			let left = String(split[0])
			let right = String(split[1])
			let jsonLeft = try! JSONSerialization.jsonObject(with: left.data(using: .utf8)!) as! NSArray
			let jsonRight = try! JSONSerialization.jsonObject(with: right.data(using: .utf8)!) as! NSArray
			
			if let solution = solve(leftArray: jsonLeft, rightArray: jsonRight), solution {
				indicesInOrder.append(i+1)
			}
		}
		return "\(indicesInOrder.reduce(0, +))"
	}
	
	public func solvePart2(input: String) -> String {
		let packets = input
			.replacingOccurrences(of: "\n\n", with: "\n")
			.split(separator: "\n")
			.map({ try! JSONSerialization.jsonObject(with: String($0).data(using: .utf8)!) as! NSArray })
			+ [[[2]]]
		+ [[[6]]]
		
		let packetsInOrder = packets.sorted(by: { solve(leftArray: $0, rightArray: $1) ?? false })
		let dividerIndex1 = packetsInOrder.enumerated().first(where: { String(data: try! JSONSerialization.data(withJSONObject: $0.1), encoding: .utf8) == "[[2]]" })!.0 + 1
		let dividerIndex2 = packetsInOrder.enumerated().first(where: { String(data: try! JSONSerialization.data(withJSONObject: $0.1), encoding: .utf8) == "[[6]]" })!.0 + 1
		
		return "\(dividerIndex1 * dividerIndex2)"
	}
	
}
