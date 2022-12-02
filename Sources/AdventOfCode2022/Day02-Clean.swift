import Foundation

public struct Day02Clean: Challenge {
	
	public init() {}
	
	enum Play {
		case rock
		case paper
		case scissors
		
		init(from: String.SubSequence) {
			switch from {
			case "A", "X": self = .rock
			case "B", "Y": self = .paper
			case "C", "Z": self = .scissors
			default: exit(1)
			}
		}
		
		var score: Int {
			switch self {
			case .rock: return 1
			case .paper: return 2
			case .scissors: return 3
			}
		}
		
		var beats: Play {
			switch self {
			case .rock: return .scissors
			case .paper: return .rock
			case .scissors: return .paper
			}
		}
		
		var isBeatBy: Play {
			switch self {
			case .rock: return .paper
			case .paper: return .scissors
			case .scissors: return .rock
			}
		}
		
		func playAgainst(_ play: Play) -> Scenario {
			if self.beats == play {
				return .win
			} else if self.isBeatBy == play {
				return .lose
			} else { // self == play
				return .tie
			}
		}
		
		func reverse(scenario: Scenario) -> Play {
			switch scenario {
			case .lose: return self.beats
			case .tie: return self
			case .win: return self.isBeatBy
			}
		}
	}
	
	enum Scenario {
		case lose
		case tie
		case win
		
		init(from: String.SubSequence) {
			switch from {
			case "X": self = .lose
			case "Y": self = .tie
			case "Z": self = .win
			default: exit(1)
			}
		}
		
		var score: Int {
			switch self {
			case .lose: return 0
			case .tie: return 3
			case .win: return 6
			}
		}
	}
	
	public func solvePart1(input: String) -> String {
		let games = input.split(separator: "\n")
		let scores = games.map({ game in
			let plays = game.split(separator: " ")
			let theirPlay = Play(from: plays[0])
			let ourPlay = Play(from: plays[1])
			let score = ourPlay.score + ourPlay.playAgainst(theirPlay).score
			return score
		})
		return "\(scores.reduce(0, +))"
	}
	
	public func solvePart2(input: String) -> String {
		let games = input.split(separator: "\n")
		let scores = games.map({ game in
			let plays = game.split(separator: " ")
			let theirPlay = Play(from: plays[0])
			let scenario = Scenario(from: plays[1])
			let ourPlay = theirPlay.reverse(scenario: scenario)
			let score = ourPlay.score + scenario.score
			return score
		})
		return "\(scores.reduce(0, +))"
	}
	
}
