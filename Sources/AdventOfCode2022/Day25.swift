import Foundation

public struct Day25: Challenge {
	
	public init() {}
	
	enum SnafuDigit: Character, CustomStringConvertible {
		var description: String {
			return String(self.rawValue)
		}
		
		case two = "2"
		case one = "1"
		case zero = "0"
		case minus = "-"
		case doubleMinus = "="
		
		init?(value: Int64) {
			switch value {
			case 2: self = .two
			case 1: self = .one
			case 0: self = .zero
			case -1: self = .minus
			case -2: self = .doubleMinus
			default: return nil
			}
		}
		
		var value: Int64 {
			switch self {
			case .two: return 2
			case .one: return 1
			case .zero: return 0
			case .minus: return -1
			case .doubleMinus: return -2
			}
		}
		
		var opposite: SnafuDigit {
			switch self {
			case .two: return .doubleMinus
			case .one: return .minus
			case .zero: return .zero
			case .minus: return .one
			case .doubleMinus: return .two
			}
		}
	}
	
	enum Base5SnafuUnionDigit: Character {
		case four = "4"
		case three = "3"
		case two = "2"
		case one = "1"
		case zero = "0"
		case minus = "-"
		case doubleMinus = "="
		
		var next: Base5SnafuUnionDigit? {
			switch self {
			case .four: return nil
			case .three: return .four
			case .two: return .three
			case .one: return .two
			case .zero: return .one
			default: exit(1)
			}
		}
		
		init?(value: Int64) {
			switch value {
			case 4: self = .four
			case 3: self = .three
			case 2: self = .two
			case 1: self = .one
			case 0: self = .zero
			case -1: self = .minus
			case -2: self = .doubleMinus
			default: return nil
			}
		}
	}
	
	func parseSnafuNumber(input: String) -> Int64 {
		var result: Int64 = 0
		for (digit, char) in input.reversed().enumerated() {
			let snafuDigit = SnafuDigit(rawValue: char)!
			result += snafuDigit.value * NSDecimalNumber(decimal: pow(5, digit)).int64Value
		}
		return result
	}
	
	func constructSnafuNumber2(input: Int64) -> [Base5SnafuUnionDigit] {
		var minExponentInputIsLessThan: Int64 = 1
		var i = 0
		while input >= minExponentInputIsLessThan {
			i += 1
			minExponentInputIsLessThan = NSDecimalNumber(decimal: pow(5, i)).int64Value
		}
		let exceptionI = i
		i -= 1
		
		var remainingInput = input
		var currentPlace = NSDecimalNumber(decimal: pow(5, i)).int64Value
		var result: [Base5SnafuUnionDigit] = []
		while i >= 0 {
			
			let partial = remainingInput / currentPlace
			remainingInput -= partial * currentPlace
			if let unionDigit = Base5SnafuUnionDigit(value: partial) {
				result.append(unionDigit)
			} else {
				exit(1)
			}
			
			i -= 1
			currentPlace = NSDecimalNumber(decimal: pow(5, i)).int64Value
		}
		
		// We should now have valid base 5 number. Now to convert to snafu.
		result = result.reversed() + [.zero]
		for i in 0..<result.count {
			var percolate = false
			if result[i] == .three {
				result[i] = .doubleMinus
				percolate = true
			} else if result[i] == .four {
				result[i] = .minus
				percolate = true
			}
			
			if percolate {
				for j in (i+1)..<result.count {
					if let next = result[j].next {
						result[j] = next
						break
					} else {
						result[j] = .zero
					}
				}
			}
		}
		
		if result.last! == .zero {
			return result.dropLast().reversed()
		} else {
			return result.reversed()
		}
	}
	
	/*func constructSnafuNumber(input: Int64) -> [SnafuDigit] {
		if input < 0 {
			let positive = constructSnafuNumber(input: -input)
			return positive.map({ $0.opposite })
		} else if input == 0 {
			return [.zero]
		} else if input == 1 {
			return [.one]
		} else if input == 2 {
			return [.two]
		}
		
		var minExponentInputIsLessThan: Int64 = 1
		var i = 0
		while input > minExponentInputIsLessThan {
			i += 1
			minExponentInputIsLessThan = NSDecimalNumber(decimal: pow(5, i)).int64Value
		}
		let exceptionI = i
		i -= 1
		
		var remainingInput = input
		var currentPlace = NSDecimalNumber(decimal: pow(5, i)).int64Value
		var result: [SnafuDigit] = []
		while i >= 0 {
			
			let partial = remainingInput / currentPlace
			remainingInput -= partial * currentPlace
			if let snafuDigit = SnafuDigit(value: partial) {
				result.append(snafuDigit)
			} else if result.isEmpty || result.first == .two {
				let right = constructSnafuNumber(input: input - NSDecimalNumber(decimal: pow(5, exceptionI)).int64Value)
				let prefix = [SnafuDigit](repeating: .zero, count: exceptionI - right.count)
				return result.dropLast() + [.one] + prefix + right
			} else {
				let right = constructSnafuNumber(input: input - (2 * NSDecimalNumber(decimal: pow(5, exceptionI-1)).int64Value))
//				let prefix = [SnafuDigit](repeating: .zero, count: exceptionI - right.count)
				return result.dropLast() + [.two] + right
			}
			
			i -= 1
			currentPlace = NSDecimalNumber(decimal: pow(5, i)).int64Value
		}
		
		return result
	}*/
	
	public func solvePart1(input: String) -> String {
//		for i in 0...100 {
//			print("Decimal: \(i), snafu: \(String(constructSnafuNumber2(input: Int64(i)).map({ $0.rawValue })))")
//		}
		let nums = input.split(separator: "\n").map({ parseSnafuNumber(input: String($0)) })
		let sum = nums.reduce(0, +)
		return "\(sum) \(String(constructSnafuNumber2(input: sum).map({ $0.rawValue })))"
	}
	
	public func solvePart2(input: String) -> String {
		return ""
	}
	
}
