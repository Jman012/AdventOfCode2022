import Foundation

public struct Day16: Challenge {
	
	public init() {}
	
	struct Valve {
		let name: String
		let rate: Int
		let tunnels: [String]
	}
	
	func stepsToTraverse(from: String, to: String, valves: [String: Valve], visited: Set<String>) -> Int {
		if from == to {
			return 0
		}
		
		var visited: Set<String> = [from]
		var toProcess: [(String, Int)] = [(from, 1)]
		while !toProcess.isEmpty {
			let process = toProcess.removeFirst()
			let valve = valves[process.0]!
			if valve.tunnels.contains(to) {
				return process.1
			} else {
				let tunnelSet = Set<String>(valve.tunnels)
				toProcess.append(contentsOf: tunnelSet.subtracting(visited).map({ ($0, process.1 + 1) }))
				visited.formUnion(tunnelSet)
			}
		}
		
		return Int.max
	}
	
	func nextHighestValves(valves: [String: Valve], currentValveName: String, distances: [String: Int], turnedOn: Set<String>) -> [(String, Int)] {
		let weights = valves
			.filter({ $0.key != currentValveName && $0.value.rate > 0 && !turnedOn.contains($0.key) })
			.map({ ($0.key, distances[currentValveName + "->" + $0.key]!) })
		return weights
	}
	
	func solve(current: String, minute: Int, valves: [String: Valve], distances: [String: Int], turnedOn: Set<String>) -> Int {
		if minute > 30 {
			return 0
		}
		let nextHighest = nextHighestValves(valves: valves, currentValveName: current, distances: distances, turnedOn: turnedOn)
		if nextHighest.isEmpty {
			return 0
		}
		
		return nextHighest
			.map({ next in
				let nextValveName = next.0
				let minutesToNextValve = next.1
				let minutesAfterTraversalAndTurnOn = minute + minutesToNextValve + 1
				let additionalScore = ((30 - minutesAfterTraversalAndTurnOn + 1) * valves[nextValveName]!.rate)
				if additionalScore < 0 {
					return 0
				}
//				print("\(String(repeating: " ", count: minute))Minute \(minute): Currently at = \(current), moving to = \(next), taking \(minutesToNextValve) minutes, plus 1 minute to open valve. +score = \(additionalScore)")
				let path = solve(current: nextValveName,
								 minute: minutesAfterTraversalAndTurnOn,
								 valves: valves,
								 distances: distances,
								 turnedOn: turnedOn.union([nextValveName]))
//				print("\(String(repeating: " ", count: minute))Minute \(minute): path = \(path), result = \(path + ((30 - minutesAfterTraversalAndTurnOn) * valves[nextValveName]!.rate))")
				return path + additionalScore
			})
			.max()!
	}
	
	public func solvePart1(input: String) -> String {
		let valves = input
			.split(separator: "\n")
			.map({ line in
				let line = String(line.dropFirst("Valve ".count))
				let split1 = line.components(separatedBy: " has flow rate=")
				let name = String(split1[0])
				var split2 = split1[1].components(separatedBy: "; tunnels lead to valves ")
				if split2.count == 1 {
					split2 = split1[1].components(separatedBy: "; tunnel leads to valve ")
				}
				let rate = Int(split2[0])!
				let tunnels = split2[1].components(separatedBy: ", ")
				return Valve(name: name, rate: rate, tunnels: tunnels)
			})
		
		var valvesDict: [String: Valve] = [:]
		for valve in valves {
			valvesDict[valve.name] = valve
		}
		
		var distances: [String: Int] = [:]
		for valve1 in valves {
			for valve2 in valves {
				distances[valve1.name + "->" + valve2.name] = stepsToTraverse(from: valve1.name,
																			  to: valve2.name,
																			  valves: valvesDict,
																			  visited: [])
			}
		}
		
		let result = solve(current: "AA", minute: 1, valves: valvesDict, distances: distances, turnedOn: [])
		return "\(result)"
	}
	
	public func solvePart2(input: String) -> String {
		return ""
	}
	
}
