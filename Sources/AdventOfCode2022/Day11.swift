import Foundation

public struct Day11: Challenge {
	
	public init() {}
	
	struct Worry {
		let value: Int64
		let factors: [Int64]
		let factorsCounts: [Int64: Int64]
		
		func add(operand: Int64) -> Worry {
			let newValue = value + operand
			return optimize(newValue: newValue, factorsCounts: factorsCounts)
		}
		
		func mult(operand: Int64) -> Worry {
			let newValue = value * operand
			return optimize(newValue: newValue, factorsCounts: factorsCounts)
		}
		
		func optimize(newValue: Int64, factorsCounts: [Int64: Int64]) -> Worry {
			var newNewValue = newValue
			var newFactorCounts = factorsCounts
			for factor in factors {
				if newNewValue % factor == 0 {
					newNewValue /= factor
					newFactorCounts[factor] = (newFactorCounts[factor] ?? 0) + Int64(1)
				}
			}
			return Worry(value: newNewValue, factors: factors, factorsCounts: newFactorCounts)
		}
		
		func mult(operand: Worry) -> Worry {
			let newValue = value * operand.value
			return optimize(newValue: newValue, factorsCounts: factorsCounts.merging(operand.factorsCounts, uniquingKeysWith: +))
		}
		
		func isDivisible(by: Int64) -> Bool {
			return factorsCounts[by]! > 0
		}
		
	}
	
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
		
		func process(item: Int64, operand: Operand, factors: [Int64]) -> Int64 {
			switch self {
			case .add:
				return item + operand.value(old: item)
			case .mult:
				return item * operand.value(old: item)
			}
		}
		
		func process(item: Worry, operand: Operand) -> Worry {
			switch self {
			case .add:
				switch operand {
				case let .const(num): return item.add(operand: num)
				case .ourself: exit(1)
				}
			case .mult:
				switch operand {
				case let .const(num): return item.mult(operand: num)
				case .ourself: return item.mult(operand: item)
				}
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
	
	struct Monkey {
		var items: [Int64]
		let operation: Operator
		let operand: Operand
		let testDivisibleBy: Int64
		let testTrueToMonkey: Int
		let testFalseToMonkey: Int
		
		mutating func add(item: Int64) {
			items.append(item)
		}
		
		mutating func popItem() -> Int64? {
			if let first = items.first {
				items = [Int64](items.dropFirst())
				return first
			} else {
				return nil
			}
		}
		
		mutating func takeTurn(index: Int, monkeys: inout [Monkey]) -> Int64 {
			let count = Int64(items.count)
			
			while var item = popItem() {
				// Inspect
				let factors = monkeys.map({ $0.testDivisibleBy })
				let originalItem = item
				item = operation.process(item: item, operand: operand, factors: factors)
				let inspectedItem = item
				
				// Bored
//				item = Worry(value: item.value / 3, factors: item.factors, factorsCounts: item.factorsCounts)
				item = item / 3
				let boredItem = item
				
				// Test
				var test = false
				var toMonkey: Int64
				if item % testDivisibleBy == 0 {
					monkeys[testTrueToMonkey].add(item: item)
					test = true
					toMonkey = item
				} else {
					monkeys[testFalseToMonkey].add(item: item)
					toMonkey = item
				}
				
//				print("""
//Monkey \(index):
//  Monkey inspects an item with a worry level of \(originalItem).
//	Worry level is multiplied by 19 to \(inspectedItem).
//	Monkey gets bored with item. Worry level is divided by 3 to \(boredItem).
//	Current worry level is \(test ? "" : "out ")divisible by .
//	Item with worry level \(boredItem) is thrown to monkey \(toMonkey).
//
//""")
			}
			
			return count
		}
		
		mutating func takeTurn2(index: Int, monkeys: inout [Monkey]) -> Int64 {
			let count = Int64(items.count)
			
			while var item = popItem() {
				// Inspect
				let factors = monkeys.map({ $0.testDivisibleBy })
				let originalItem = item
				item = operation.process(item: item, operand: operand, factors: factors)
				let inspectedItem = item
				
				// Bored
//				item = item / 3
				item %= monkeys.map({ $0.testDivisibleBy }).reduce(1, *)
				let boredItem = item
				
				// Test
				var test = false
				var toMonkey: Int64
				if item % testDivisibleBy == 0 {
					monkeys[testTrueToMonkey].add(item: item)
					test = true
					toMonkey = item
				} else {
					monkeys[testFalseToMonkey].add(item: item)
					toMonkey = item
				}
				
//				print("""
//Monkey \(index):
//  Monkey inspects an item with a worry level of \(originalItem).
//	Worry level is multiplied by 19 to \(inspectedItem).
//	Monkey gets bored with item. Worry level is divided by 3 to \(boredItem).
//	Current worry level is \(test ? "" : "out ")divisible by .
//	Item with worry level \(boredItem) is thrown to monkey \(toMonkey).
//
//""")
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
//		let factors = Array(Set(monkeys.map({ $0.testDivisibleBy })))
//		var factorCounts: [Int64: Int64] = [:]
//		return monkeys.map { monkey in
//			var monkey = monkey
//			monkey.items = monkey.items.map({ Worry(value: $0.value, factors: factors, factorsCounts: factorCounts)})
//			return monkey
//		}
	}
	
	public func solvePart1(input: String) -> String {
		var monkeys = parseMonkeys(input: input)
		var monkeyInspections: [Int64] = .init(repeating: 0, count: monkeys.count)
		for _ in 0..<20 {
			for i in 0..<monkeys.count {
				var monkey = monkeys[i]
				let inspections = monkey.takeTurn(index: i, monkeys: &monkeys)
				monkeyInspections[i] += Int64(inspections)
				monkeys[i] = monkey
			}
		}
		
		return "\(monkeyInspections.sorted().reversed()[0..<2].reduce(1, *))"
	}
	
	public func solvePart2(input: String) -> String {
		var monkeys = parseMonkeys(input: input)
		var monkeyInspections: [Int64] = .init(repeating: 0, count: monkeys.count)
		for round in 0..<10_000 {
			for i in 0..<monkeys.count {
				var monkey = monkeys[i]
				let inspections = monkey.takeTurn2(index: i, monkeys: &monkeys)
				monkeyInspections[i] += inspections
				monkeys[i] = monkey
			}
		}
		
		return "\(monkeyInspections.sorted().reversed()[0..<2].reduce(1, *))"
	}
	
}
