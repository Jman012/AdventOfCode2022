import Foundation

public struct Day21: Challenge {
	
	public init() {}
	
	enum Op {
		case sum
		case subtract
		case multiply
		case divide
	}
	
	enum Monkey {
		case const(Int64)
		case op(String, Op, String)
	}
	
	func solve(monkeyName: String, monkeyLookup: [String: Monkey]) -> Int64 {
		let monkey = monkeyLookup[monkeyName]!
		
		switch monkey {
		case let .const(num):
			return num
		case let .op(m1, op, m2):
			let m1Value = solve(monkeyName: m1, monkeyLookup: monkeyLookup)
			let m2Value = solve(monkeyName: m2, monkeyLookup: monkeyLookup)
			switch op {
			case .sum: return m1Value + m2Value
			case .subtract: return m1Value - m2Value
			case .multiply: return m1Value * m2Value
			case .divide: return m1Value / m2Value
			}
		}
	}
	
	func trySolve2(monkeyName: String, monkeyLookup: inout [String: Monkey]) -> Int64? {
		if monkeyName == "humn" {
			return nil
		}
		let monkey = monkeyLookup[monkeyName]!
		
		switch monkey {
		case let .const(num):
			return num
		case let .op(m1, op, m2):
			let m1Value = trySolve2(monkeyName: m1, monkeyLookup: &monkeyLookup)
			if let m1Value = m1Value {
				monkeyLookup[m1] = .const(m1Value)
			}
			let m2Value = trySolve2(monkeyName: m2, monkeyLookup: &monkeyLookup)
			if let m2Value = m2Value {
				monkeyLookup[m2] = .const(m2Value)
			}
			if m1Value == nil || m2Value == nil {
				return nil
			}
			switch op {
			case .sum: return m1Value! + m2Value!
			case .subtract: return m1Value! - m2Value!
			case .multiply: return m1Value! * m2Value!
			case .divide: return m1Value! / m2Value!
			}
		}
	}
	
//	func solve2(left: String, op: Op, right: String, monkeyLookup: inout [String: Monkey]) -> Int64 {
//		
//	}
	
	public func solvePart1(input: String) -> String {
		let monkeys = input
			.split(separator: "\n")
			.map({ line in
				let split1 = line.components(separatedBy: ": ")
				let monkeyName = split1[0]
				let split: String
				let op: Op
				if split1[1].contains(" + ") {
					op = .sum
					split = " + "
				} else if split1[1].contains(" - ") {
					op = .subtract
					split = " - "
				} else
				if split1[1].contains(" * ") {
					op = .multiply
					split = " * "
				} else
				if split1[1].contains(" / ") {
					op = .divide
					split = " / "
				} else {
					return (monkeyName, Monkey.const(Int64(split1[1])!))
				}
				
				let split2 = split1[1].components(separatedBy: split)
				return (monkeyName, Monkey.op(split2[0], op, split2[1]))
			})
		
		let monkeyLookup = Dictionary(uniqueKeysWithValues: monkeys)
		
		let result = solve(monkeyName: "root", monkeyLookup: monkeyLookup)
		
		return "\(result)"
	}
	
	public func solvePart2(input: String) -> String {
		let monkeys = input
			.split(separator: "\n")
			.map({ line in
				let split1 = line.components(separatedBy: ": ")
				let monkeyName = split1[0]
				let split: String
				let op: Op
				if split1[1].contains(" + ") {
					op = .sum
					split = " + "
				} else if split1[1].contains(" - ") {
					op = .subtract
					split = " - "
				} else
				if split1[1].contains(" * ") {
					op = .multiply
					split = " * "
				} else
				if split1[1].contains(" / ") {
					op = .divide
					split = " / "
				} else {
					return (monkeyName, Monkey.const(Int64(split1[1])!))
				}
				
				let split2 = split1[1].components(separatedBy: split)
				return (monkeyName, Monkey.op(split2[0], op, split2[1]))
			})
		
		var monkeyLookup = Dictionary(uniqueKeysWithValues: monkeys)
		
		let root = monkeyLookup["root"]!
		guard case let .op(left, op, right) = root else {
			exit(1)
		}
		
		while true {
			let resultLeft = trySolve2(monkeyName: left, monkeyLookup: &monkeyLookup)
			let resultRight = trySolve2(monkeyName: right, monkeyLookup: &monkeyLookup)
			
			let resultNilName = resultLeft == nil ? left : right
//			let resultNilValue = resultLeft == nil ? resultLeft! : resultRight!
			let resultConstName = resultLeft == nil ? right : left
			let resultConstValue = resultLeft == nil ? resultRight! : resultLeft!
			
			switch monkeyLookup[resultNilName]! {
			case let .const(val):
				return "\(val)"
			case let .op(newLeft, op, newRight):
				let newResultLeft = trySolve2(monkeyName: newLeft, monkeyLookup: &monkeyLookup)
				let newResultRight = trySolve2(monkeyName: newRight, monkeyLookup: &monkeyLookup)
				let newResultNilName = newResultLeft == nil ? newLeft : newRight
//				let newResultNilValue = newResultLeft == nil ? newResultLeft! : newResultRight!
				let newResultConstName = newResultLeft == nil ? newRight : newLeft
				let newResultConstValue = newResultLeft == nil ? newResultRight! : newResultLeft!
				
				switch op {
				case .sum:
					monkeyLookup[resultConstName] = .const(resultConstValue - newResultConstValue)
					monkeyLookup[resultNilName] = monkeyLookup[newResultNilName]
				case .subtract:
					if newResultConstName == newRight {
						monkeyLookup[resultConstName] = .const(resultConstValue + newResultConstValue)
						monkeyLookup[resultNilName] = monkeyLookup[newResultNilName]
					} else {
						monkeyLookup[resultConstName] = .const(newResultConstValue - resultConstValue)
						monkeyLookup[resultNilName] = monkeyLookup[newResultNilName]
					}
				case .multiply:
					monkeyLookup[resultConstName] = .const(resultConstValue / newResultConstValue)
					monkeyLookup[resultNilName] = monkeyLookup[newResultNilName]
				case .divide:
					if newResultConstName == newRight {
						monkeyLookup[resultConstName] = .const(resultConstValue * newResultConstValue)
						monkeyLookup[resultNilName] = monkeyLookup[newResultNilName]
					} else {
						monkeyLookup[resultConstName] = .const(newResultConstValue / resultConstValue)
						monkeyLookup[resultNilName] = monkeyLookup[newResultNilName]
					}
				}
			}
		}
		
		/*
		 while true {
			 let root = monkeyLookup["root"]!
			 switch root {
			 case let .const(result):
				 return "\(result)"
			 case let .op(left, op, right):
				 let resultLeft = trySolve2(monkeyName: left, monkeyLookup: &monkeyLookup)
				 let resultRight = trySolve2(monkeyName: right, monkeyLookup: &monkeyLookup)
				 
				 let resultNilName = resultLeft == nil ? left : right
				 let resultNilValue = resultLeft == nil ? resultLeft! : resultRight!
				 let resultConstName = resultLeft == nil ? right : left
				 let resultConstValue = resultLeft == nil ? resultRight! : resultLeft!
				 
				 switch monkeyLookup[resultNilName]! {
				 case .const: exit(1)
				 case let .op(left, op, right):
					 switch op {
					 case .sum:
						 monkeyLookup[resultConstName] = .const(resultConstValue - )
					 case .subtract:
					 case .multiply:
					 case .divide:
					 }
				 }
			 }
		 }
		 */
		
		return ""
	}
	
}
