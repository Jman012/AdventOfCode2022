import Foundation
import Algorithms

public struct Day14: Challenge {
	
	public init() {}
	
	struct Coord: Hashable {
		let x: Int
		let y: Int
	}
	
	enum Cell: String {
		case empty = "."
		case wall = "#"
		case restingSand = "o"
	}
	
	public func solvePart1(input: String) -> String {
		let lines = input
			.split(separator: "\n")
			.map({ line in
				return line
					.components(separatedBy: " -> ")
					.map({ Coord(x: Int($0.split(separator: ",")[0])!, y: Int($0.split(separator: ",")[1])!) })
			})
		
		let minX = lines.flatMap({ $0 }).map({ $0.x }).min()!
		let maxX = lines.flatMap({ $0 }).map({ $0.x }).max()!
		let maxY = lines.flatMap({ $0 }).map({ $0.y }).max()!
		
		var board: [[Cell]] = Array<Array<Cell>>(repeating: Array<Cell>(repeating: .empty, count: maxX - minX + 1), count: maxY + 1)
		
		for line in lines {
			for pairs in line.windows(ofCount: 2) {
				var start = pairs.first!
				let end = pairs.last!
				var stepX = end.x - start.x
				if stepX != 0 {
					stepX /= abs(stepX)
				}
				var stepY = end.y - start.y
				if stepY != 0 {
					stepY /= abs(stepY)
				}
				while start != end {
					board[start.y][start.x - minX] = .wall
					start = Coord(x: start.x + stepX, y: start.y + stepY)
				}
				board[start.y][start.x - minX] = .wall
			}
		}
		
//		print(board.map({ String($0.map({ $0.rawValue }).joined()) }).joined(separator: "\n"))
//		print()
		
		let pour = Coord(x: 500 - minX, y: 0)
		let options: [Coord] = [Coord(x: 0, y: 1), Coord(x: -1, y: 1), Coord(x: 1, y: 1)]
		mainLoop: while true {
			var fallingSandCoord = pour
			
			fallLoop: while true {
				for option in options {
					let newCoord = Coord(x: fallingSandCoord.x + option.x, y: fallingSandCoord.y + option.y)
					if !(0 <= newCoord.x && newCoord.x < board[0].count) {
						break mainLoop
					} else if board[newCoord.y][newCoord.x] == .empty {
						fallingSandCoord = newCoord
						continue fallLoop
					}
				}
				
				board[fallingSandCoord.y][fallingSandCoord.x] = .restingSand
				break fallLoop
			}
			
//			print(board.map({ String($0.map({ $0.rawValue }).joined()) }).joined(separator: "\n"))
//			print()
		}
		
		let count = board.flatMap({ $0 }).filter({ $0 == .restingSand }).count
		return "\(count)"
	}
	
	public func solvePart2(input: String) -> String {
		var lines = input
			.split(separator: "\n")
			.map({ line in
				return line
					.components(separatedBy: " -> ")
					.map({ Coord(x: Int($0.split(separator: ",")[0])!, y: Int($0.split(separator: ",")[1])!) })
			})
		
		let minX = lines.flatMap({ $0 }).map({ $0.x }).min()!
		let maxX = lines.flatMap({ $0 }).map({ $0.x }).max()!
		let maxY = lines.flatMap({ $0 }).map({ $0.y }).max()!
		
		let xExtension = 200
		lines = lines + [[Coord(x: minX - xExtension, y: maxY + 2), Coord(x: maxX + xExtension, y: maxY + 2)]]
		
		var board: [[Cell]] = Array<Array<Cell>>(repeating: Array<Cell>(repeating: .empty, count: maxX - minX + 1 + (xExtension * 2)), count: maxY + 1 + 2)
		
		for line in lines {
			for pairs in line.windows(ofCount: 2) {
				var start = pairs.first!
				let end = pairs.last!
				var stepX = end.x - start.x
				if stepX != 0 {
					stepX /= abs(stepX)
				}
				var stepY = end.y - start.y
				if stepY != 0 {
					stepY /= abs(stepY)
				}
				while start != end {
					board[start.y][start.x - minX + xExtension] = .wall
					start = Coord(x: start.x + stepX, y: start.y + stepY)
				}
				board[start.y][start.x - minX + xExtension] = .wall
			}
		}
		
//		print(board.map({ String($0.map({ $0.rawValue }).joined()) }).joined(separator: "\n"))
//		print()
		
		let pour = Coord(x: 500 - minX + xExtension, y: 0)
		let options: [Coord] = [Coord(x: 0, y: 1), Coord(x: -1, y: 1), Coord(x: 1, y: 1)]
		mainLoop: while true {
			if board[pour.y][pour.x] == .restingSand {
				break mainLoop
			}
			
			var fallingSandCoord = pour
			
			fallLoop: while true {
				for option in options {
					let newCoord = Coord(x: fallingSandCoord.x + option.x, y: fallingSandCoord.y + option.y)
					if !(0 <= newCoord.x && newCoord.x < board[0].count) {
						exit(1)
					} else if board[newCoord.y][newCoord.x] == .empty {
						fallingSandCoord = newCoord
						continue fallLoop
					}
				}
				
				board[fallingSandCoord.y][fallingSandCoord.x] = .restingSand
				break fallLoop
			}
			
//			print(board.map({ String($0.map({ $0.rawValue }).joined()) }).joined(separator: "\n"))
//			print()
		}
		
		let count = board.flatMap({ $0 }).filter({ $0 == .restingSand }).count
		return "\(count)"
	}
	
}
