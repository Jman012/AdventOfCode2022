import Foundation

public struct Day19: Challenge {
	
	public init() {}
	
	struct Blueprint {
		let oreRobotOreCost: Int
		let clayRobotOreCost: Int
		let obsidianRobotOreCost: Int
		let obsidianRobotClayCost: Int
		let geodeRobotOreCost: Int
		let geodeRobotObsidianCost: Int
	}
	
	public func solvePart1(input: String) -> String {
		let blueprints = input.split(separator: "\n")
			.map({ line in
				let split1 = String(line).components(separatedBy: ": Each ore robot costs ")
				let split2 = split1[1].components(separatedBy: " ore. Each clay robot costs ")
				let split3 = split2[1].components(separatedBy: " ore. Each obsidian robot costs ")
				let split4 = split3[1].components(separatedBy: " ore and ")
				let split5 = split4[1].components(separatedBy: " clay. Each geode robot costs ")
				let split6 = split5[1].components(separatedBy: " ore and ")
				let split7 = split6[1].components(separatedBy: " obsidian.")
				return Blueprint(oreRobotOreCost: Int(split2[0])!, clayRobotOreCost: Int(split3[0])!, obsidianRobotOreCost: Int(split4[0])!, obsidianRobotClayCost: Int(split5[0])!, geodeRobotOreCost: Int(split6[0])!, geodeRobotObsidianCost: Int(split7[0])!)
			})
		
		let blueprintScores = blueprints
			.map({ blueprint in
				var oreRobots = 1
				var clayRobots = 0
				var obisidianRobots = 0
				var geodeRobots = 0
				
				var ore = 0
				var clay = 0
				var obsidian = 0
				var geodes = 0
				
				for _ in 1...24 {
//					if blueprint.geo
					ore += oreRobots
				}
			})
		
		return ""
	}
	
	public func solvePart2(input: String) -> String {
		return ""
	}
	
}
