import Foundation

public struct Day11: Challenge {
	
	public init() {}
	
	enum Operator {
		case add
		case mult
		
		init(_ input: String) {
			switch input {
			case "+": self = .add
			case "*": self = .mult
			default: exit(1)
			}
		}
		
		func process(item: Int64, operand: Operand) -> Int64 {
			switch self {
			case .add:
				return item + operand.value(old: item)
			case .mult:
				return item * operand.value(old: item)
			}
		}
	}
	
	enum Operand {
		case const(Int64)
		case ourself
		
		init(_ input: String) {
			if let num = Int64(input) {
				self = .const(num)
			} else {
				self = .ourself
			}
		}
		
		func value(old: Int64) -> Int64 {
			switch self {
			case let .const(num): return num
			case .ourself: return old
			}
		}
	}
	
	class Monkey {
		var items: [Int64]
		let operation: Operator
		let operand: Operand
		let testDivisibleBy: Int64
		let testTrueToMonkey: Int
		let testFalseToMonkey: Int
		
		init(items: [Int64], operation: Operator, operand: Operand, testDivisibleBy: Int64, testTrueToMonkey: Int, testFalseToMonkey: Int) {
			self.items = items
			self.operation = operation
			self.operand = operand
			self.testDivisibleBy = testDivisibleBy
			self.testTrueToMonkey = testTrueToMonkey
			self.testFalseToMonkey = testFalseToMonkey
		}
		
		func add(item: Int64) {
			items.append(item)
		}
		
		func popItem() -> Int64? {
			return items.isEmpty ? nil : items.removeFirst()
		}
		
		func takeTurn(index: Int, monkeys: inout [Monkey]) -> Int64 {
			let count = Int64(items.count)
			
			while var item = popItem() {
				// Inspect
				item = operation.process(item: item, operand: operand)
				
				// Bored
				item = item / 3
				
				// Test
				if item % testDivisibleBy == 0 {
					monkeys[testTrueToMonkey].add(item: item)
				} else {
					monkeys[testFalseToMonkey].add(item: item)
				}
			}
			
			return count
		}
		
		func takeTurn2(index: Int, monkeys: inout [Monkey], factor: Int64) -> Int64 {
			let count = Int64(items.count)
			
			while var item = popItem() {
				// Inspect
				item = operation.process(item: item, operand: operand)
				
				// Bored
				item %= factor
				
				// Test
				if item % testDivisibleBy == 0 {
					monkeys[testTrueToMonkey].add(item: item)
				} else {
					monkeys[testFalseToMonkey].add(item: item)
				}
			}
			
			return count
		}
		
	}
	
	func parseMonkeys(input: String) -> [Monkey] {
		let monkeys = input
			.components(separatedBy: "\n\n")
			.map({ monkeyInput in
				let lines = monkeyInput.components(separatedBy: "\n")
				let items = String(lines[1].dropFirst("  Starting items: ".count)).components(separatedBy: ", ").map({ Int64($0)! })
				let op = String(lines[2].dropFirst("  Operation: new = old ".count)).components(separatedBy: " ")
				let operation = Operator(op[0])
				let operand = Operand(op[1])
				let testDivBy = Int64(lines[3].dropFirst("  Test: divisible by ".count))!
				let trueTo = Int(lines[4].dropFirst("    If true: throw to monkey ".count))!
				let falseTo = Int(lines[5].dropFirst("    If false: throw to monkey ".count))!
				return Monkey(items: items,
							  operation: operation,
							  operand: operand,
							  testDivisibleBy: testDivBy,
							  testTrueToMonkey: trueTo,
							  testFalseToMonkey: falseTo)
			})
		return monkeys
	}
	
	public func solvePart1(input: String) -> String {
		var monkeys = parseMonkeys(input: input)
		var monkeyInspections: [Int64] = .init(repeating: 0, count: monkeys.count)
		for _ in 0..<20 {
			for i in 0..<monkeys.count {
				let inspections = monkeys[i].takeTurn(index: i, monkeys: &monkeys)
				monkeyInspections[i] += Int64(inspections)
			}
		}
		
		return "\(monkeyInspections.sorted().reversed()[0..<2].reduce(1, *))"
	}
	
	public func solvePart2(input: String) -> String {
		var monkeys = parseMonkeys(input: input)
		let factor = monkeys.map({ $0.testDivisibleBy }).reduce(1, *)
		var monkeyInspections: [Int64] = .init(repeating: 0, count: monkeys.count)
		for _ in 0..<10_000 {
			for i in 0..<monkeys.count {
				let inspections = monkeys[i].takeTurn2(index: i, monkeys: &monkeys, factor: factor)
				monkeyInspections[i] += Int64(inspections)
			}
		}
		
		return "\(monkeyInspections.sorted().reversed()[0..<2].reduce(1, *))"
	}
	
}
