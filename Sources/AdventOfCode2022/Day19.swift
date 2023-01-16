import Foundation

public struct Day19: Challenge {
	
	public init() {}
	
	struct Blueprint: Hashable {
		let oreRobotOreCost: Int64
		let clayRobotOreCost: Int64
		let obsidianRobotOreCost: Int64
		let obsidianRobotClayCost: Int64
		let geodeRobotOreCost: Int64
		let geodeRobotObsidianCost: Int64
		
		let maxOreRobotsNeeded: Int64
		let maxClayRobotsNeeded: Int64
		let maxObisidianRobotsNeeded: Int64
		
		init(oreRobotOreCost: Int64, clayRobotOreCost: Int64, obsidianRobotOreCost: Int64, obsidianRobotClayCost: Int64, geodeRobotOreCost: Int64, geodeRobotObsidianCost: Int64) {
			self.oreRobotOreCost = oreRobotOreCost
			self.clayRobotOreCost = clayRobotOreCost
			self.obsidianRobotOreCost = obsidianRobotOreCost
			self.obsidianRobotClayCost = obsidianRobotClayCost
			self.geodeRobotOreCost = geodeRobotOreCost
			self.geodeRobotObsidianCost = geodeRobotObsidianCost
			
			maxOreRobotsNeeded = max(oreRobotOreCost, clayRobotOreCost, obsidianRobotOreCost, geodeRobotOreCost)
			maxClayRobotsNeeded = obsidianRobotClayCost
			maxObisidianRobotsNeeded = geodeRobotObsidianCost
		}
	}
	
	struct State: Hashable {
		let blueprint: Blueprint
		var minute: Int64
		
		var oreRobots: Int64 = 1
		var clayRobots: Int64 = 0
		var obsidianRobots: Int64 = 0
		var geodeRobots: Int64 = 0
		
		var ore: Int64 = 0
		var clay: Int64 = 0
		var obsidian: Int64 = 0
		var geodes: Int64 = 0
		
		var canConstructOreRobots: Int64 {
			return ore / blueprint.oreRobotOreCost
		}
		
		var canConstructClayRobots: Int64 {
			return ore / blueprint.clayRobotOreCost
		}
		
		var canConstructObsidianRobots: Int64 {
			return min(ore / blueprint.obsidianRobotOreCost, clay / blueprint.obsidianRobotClayCost)
		}
		
		var canConstructGeodeRobots: Int64 {
			return min(ore / blueprint.geodeRobotOreCost, obsidian / blueprint.geodeRobotObsidianCost)
		}
		
		init(blueprint: Blueprint) {
			self.blueprint = blueprint
			self.minute = 1
		}
		
		mutating func constructOreRobot() {
			ore -= blueprint.oreRobotOreCost
		}
		
		mutating func constructClayRobot() {
			ore -= blueprint.clayRobotOreCost
		}
		
		mutating func constructObsidianRobot() {
			ore -= blueprint.obsidianRobotOreCost
			clay -= blueprint.obsidianRobotClayCost
		}
		
		mutating func constructGeodeRobot() {
			ore -= blueprint.geodeRobotOreCost
			obsidian -= blueprint.geodeRobotObsidianCost
		}
		
		mutating func advance() {
			minute += 1
			ore += oreRobots
			clay += clayRobots
			obsidian += obsidianRobots
			geodes += geodeRobots
		}
	}
	
	func blueprintScore(minute: Int64, maxMinutes: Int64, states: Set<State>) -> Set<State> {
		if minute > maxMinutes {
			return states
		}
		
		let constructionCountRange = Set<Int64>(1...2)
		var newStates: Set<State> = []
		for state in states {
			var newNewStates: [State] = []
			
			if state.oreRobots < state.blueprint.maxOreRobotsNeeded && constructionCountRange.contains(state.canConstructOreRobots) {
				var newState = state
				newState.constructOreRobot()
				newState.advance()
				newState.oreRobots += 1
				newNewStates.append(newState)
			}
			
			if state.clayRobots < state.blueprint.maxClayRobotsNeeded && constructionCountRange.contains(state.canConstructClayRobots) {
				var newState = state
				newState.constructClayRobot()
				newState.advance()
				newState.clayRobots += 1
				newNewStates.append(newState)
			}
			
			if state.obsidianRobots < state.blueprint.maxObisidianRobotsNeeded && constructionCountRange.contains(state.canConstructObsidianRobots) {
				var newState = state
				newState.constructObsidianRobot()
				newState.advance()
				newState.obsidianRobots += 1
				newNewStates.append(newState)
			}
			
			// Geode robots do not get a max
			var didConstructGeodeRobot = false
			if state.canConstructGeodeRobots > 0 {
				var newState = state
				newState.constructGeodeRobot()
				newState.advance()
				newState.geodeRobots += 1
				newNewStates.append(newState)
				didConstructGeodeRobot = true
			}
			
			if !(state.oreRobots == state.blueprint.maxOreRobotsNeeded && state.clayRobots == state.blueprint.maxClayRobotsNeeded && state.obsidianRobots == state.blueprint.maxObisidianRobotsNeeded && didConstructGeodeRobot) {
				var newState = state
				newState.advance()
				newNewStates.append(newState)
			}
			
			newStates.formUnion(newNewStates)
		}

		let maxGeodes = newStates.map({ $0.geodes }).max()!
		let oldStatesCount = newStates.count
		newStates = newStates.filter({ ((maxGeodes-2)...maxGeodes).contains($0.geodes) })
		let newStatesCount = newStates.count
		if oldStatesCount != newStatesCount {
//			print("minute \(minute): filtering from \(oldStatesCount) to \(newStatesCount) new states count")
		}
		
//		print("minute \(minute) out of \(maxMinutes): newStates count is \(newStates.count), with \(newStates.map({ $0.geodes }).max()!) geodes")
		return blueprintScore(minute: minute + 1, maxMinutes: maxMinutes, states: newStates)
	}
	
	public func solvePart1(input: String) -> String {
		let blueprints = input.split(separator: "\n")
			.map({ line in
				let split1 = String(line).components(separatedBy: ": Each ore robot costs ")
				let split2 = split1[1].components(separatedBy: " ore. Each clay robot costs ")
				let split3 = split2[1].components(separatedBy: " ore. Each obsidian robot costs ")
				let split4 = split3[1].components(separatedBy: " ore and ")
//				let split4 = split3[1].split(separator: " ore and ", maxSplits: 1)
				let split5 = ([split4[1], split4[2]].joined(separator: " ore and ")).components(separatedBy: " clay. Each geode robot costs ")
				let split6 = split5[1].components(separatedBy: " ore and ")
				let split7 = split6[1].components(separatedBy: " obsidian.")
				return Blueprint(oreRobotOreCost: Int64(split2[0])!,
								 clayRobotOreCost: Int64(split3[0])!,
								 obsidianRobotOreCost: Int64(split4[0])!,
								 obsidianRobotClayCost: Int64(split5[0])!,
								 geodeRobotOreCost: Int64(split6[0])!,
								 geodeRobotObsidianCost: Int64(split7[0])!)
			})
		
		let blueprintScores = blueprints.map({ blueprintScore(minute: 1, maxMinutes: 24, states: [State(blueprint: $0)]) })
		let maxBlueprintScores = blueprintScores.map({ $0.map({ $0.geodes }).max()! })
		
		return "\(maxBlueprintScores.enumerated().map({ Int64($0.0 + 1) * $0.1 }).reduce(0, +))"
	}
	
	public func solvePart2(input: String) -> String {
		let blueprints = input.split(separator: "\n")
			.map({ line in
				let split1 = String(line).components(separatedBy: ": Each ore robot costs ")
				let split2 = split1[1].components(separatedBy: " ore. Each clay robot costs ")
				let split3 = split2[1].components(separatedBy: " ore. Each obsidian robot costs ")
				let split4 = split3[1].components(separatedBy: " ore and ")
//				let split4 = split3[1].split(separator: " ore and ", maxSplits: 1)
				let split5 = ([split4[1], split4[2]].joined(separator: " ore and ")).components(separatedBy: " clay. Each geode robot costs ")
				let split6 = split5[1].components(separatedBy: " ore and ")
				let split7 = split6[1].components(separatedBy: " obsidian.")
				return Blueprint(oreRobotOreCost: Int64(split2[0])!,
								 clayRobotOreCost: Int64(split3[0])!,
								 obsidianRobotOreCost: Int64(split4[0])!,
								 obsidianRobotClayCost: Int64(split5[0])!,
								 geodeRobotOreCost: Int64(split6[0])!,
								 geodeRobotObsidianCost: Int64(split7[0])!)
			})
		
		let blueprintScores = blueprints.prefix(3).map({ blueprintScore(minute: 1, maxMinutes: 32, states: [State(blueprint: $0)]) })
		let maxBlueprintScores = blueprintScores.map({ $0.map({ $0.geodes }).max()! })
		
		return "\(maxBlueprintScores.reduce(1, *))"
	}
	
}
