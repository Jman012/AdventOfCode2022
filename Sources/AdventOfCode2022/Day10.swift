import Foundation

public struct Day10: Challenge {
	
	public init() {}
	
	enum Instr {
		case noop
		case addx(Int)
		
		var num: Int? {
			switch self {
			case let .addx(x): return x
			default: return nil
			}
		}
		
		init(input: String) {
			let split = input.split(separator: " ")
			switch split[0] {
			case "noop": self = .noop
			case "addx": self = .addx(Int(split[1])!)
			default: exit(1)
			}
		}
		
		static func explodedInstrs(input: String) -> [Instr] {
			let instr = Instr(input: input)
			switch instr {
			case .addx: return [.noop, instr]
			default: return [instr]
			}
		}
	}
	
	public func solvePart1(input: String) -> String {
		let instrs = input
			.split(separator: "\n")
			.flatMap({ Instr.explodedInstrs(input: String($0)) })
		let nums = instrs
			.map({ $0.num })
		let splits = [20, 60, 100, 140, 180, 220]
			.map({ $0 * nums[0..<($0-1)].reduce(1, { $1 == nil ? $0 : $0 + $1! }) })
		return "\(splits.reduce(0, +))"
	}
	
	public func solvePart2(input: String) -> String {
		let instrs = input
			.split(separator: "\n")
			.flatMap({ Instr.explodedInstrs(input: String($0)) })
		let nums = instrs
			.map({ $0.num })
		
		var pixels: [Character] = .init(repeating: ".", count: nums.count)
		var x = 1
		for (index, num) in nums.enumerated() {
			let indexInRow = index - (40 * (index / 40))
			if indexInRow-1 <= x && x <= indexInRow+1 {
				pixels[index] = "#"
			}
			
			if let num = num {
				x += num
			}
		}
		
		let results: [String] = (0..<6)
			.map({ String(pixels[($0*40)..<(($0+1)*40)]) })
			
		let result = results.joined(separator: "\n")
		
//		print(result)
		
		return result
	}
	
}
