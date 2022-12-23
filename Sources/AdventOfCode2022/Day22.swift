import Foundation

public struct Day22: Challenge {
	
	public init() {}
	
	enum Direction {
		case right
		case down
		case up
		case left
		
		var oppositeDir: Direction {
			switch self {
			case .right: return .left
			case .down: return .up
			case .left: return .right
			case .up: return .down
			}
		}
		
		var score: Int {
			switch self {
			case .right: return 0
			case .down: return 1
			case .left: return 2
			case .up: return 3
			}
		}
		
		func rotatingRight() -> Direction {
			switch self {
			case .right: return .down
			case .down: return .left
			case .left: return .up
			case .up: return .right
			}
		}
		
		func rotatingLeft() -> Direction {
			switch self {
			case .right: return .up
			case .up: return .left
			case .left: return .down
			case .down: return .right
			}
		}
	}
	
	enum Cell: Character {
		case empty = " "
		case walkable = "."
		case wall = "#"
	}
	
	enum Step {
		case forward(Int)
		case rotateRight
		case rotateLeft
	}
	
	struct Coord {
		let row: Int
		let col: Int
		
		func advancedOne(facing dir: Direction) -> Coord {
			switch dir {
			case .right: return Coord(row: self.row, col: self.col + 1)
			case .left: return Coord(row: self.row, col: self.col - 1)
			case .up: return Coord(row: self.row - 1, col: self.col)
			case .down: return Coord(row: self.row + 1, col: self.col)
			}
		}
		
		func `is`(in board: [[Cell]]) -> Bool {
			if self.row < 0 {
				return false
			} else if self.row >= board.count {
				return false
			} else if self.col < 0 {
				return false
			} else if self.col >= board[0].count {
				return false
			}
			
			return true
		}
		
		func advancedOne(facing dir: Direction, wrapping board: [[Cell]]) -> Coord {
			let next = self.advancedOne(facing: dir)
			if next.row < 0 {
				return Coord(row: board.count - 1, col: next.col)
			} else if next.row >= board.count {
				return Coord(row: 0, col: next.col)
			} else if next.col < 0 {
				return Coord(row: next.row, col: board[0].count - 1)
			} else if next.col >= board[0].count {
				return Coord(row: next.row, col: 0)
			}
			
			return next
		}
		
		func advancedBy(_ num: Int, facing dir: Direction, in board: [[Cell]]) -> Coord {
			print("advance by \(num) facing \(dir)")
			var current = self
			print("starting at \(current)")
			for _ in 0..<num {
				let next = current.advancedOne(facing: dir)
				if !next.is(in: board) {
					print("next is off the board. backtracking.")
					// Find next proper cell
					var nextValidCell = current
					repeat {
						nextValidCell = nextValidCell.advancedOne(facing: dir.oppositeDir)
					} while nextValidCell.is(in: board) && board[nextValidCell.row][nextValidCell.col] != .empty;
					nextValidCell = nextValidCell.advancedOne(facing: dir)
					
					switch board[nextValidCell.row][nextValidCell.col] {
					case .empty:
						exit(1)
					case .wall:
						print("backtrack goes to a wall. ending at \(current)")
						return current
					case .walkable:
						current = nextValidCell
						print("backtracked to \(current)")
					}
				} else {
					let nextCell = board[next.row][next.col]
					
					switch nextCell {
					case .walkable:
						current = next
						print("next space is walkable. now at \(current)")
					case .wall:
						print("next space is a wall. ending at \(current)")
						return current
					case .empty:
						print("next is empty space. backtracking.")
						// Find next proper cell
						var nextValidCell = current
						repeat {
							nextValidCell = nextValidCell.advancedOne(facing: dir.oppositeDir)
						} while nextValidCell.is(in: board) && board[nextValidCell.row][nextValidCell.col] != .empty;
						nextValidCell = nextValidCell.advancedOne(facing: dir)
						
						switch board[nextValidCell.row][nextValidCell.col] {
						case .empty:
							exit(1)
						case .wall:
							print("backtrack goes to a wall. ending at \(current)")
							return current
						case .walkable:
							current = nextValidCell
							print("backtracked to \(current)")
						}
					}
				}
			}
			
			return current
		}
	}
	
	func parseSteps(input: String) -> [Step] {
		var begin = input.startIndex
//		var end = input.startIndex
		var steps: [Step] = []
		
		while begin != input.endIndex {
			if input[begin] == "L" {
				steps.append(.rotateLeft)
				begin = input.index(after: begin)
//				end = begin
			} else if input[begin] == "R" {
				steps.append(.rotateRight)
				begin = input.index(after: begin)
//				end = begin
			} else {
				let end = input.index(after: begin)
				if end != input.endIndex {
					if let num = Int(input[begin...end]) {
						steps.append(.forward(num))
						begin = input.index(after: end)
					} else {
						steps.append(.forward(Int(String(input[begin]))!))
						begin = input.index(after: begin)
					}
				} else {
					steps.append(.forward(Int(String(input[begin]))!))
					begin = input.index(after: begin)
				}
			}
		}
		
		return steps
	}
	
	public func solvePart1(input: String) -> String {
		let split = input.components(separatedBy: "\n\n")
		let longest = split[0].components(separatedBy: "\n").map({ $0.count }).max()!
		let board: [[Cell]] = split[0]
			.split(separator: "\n")
			.map({ ($0 + String(repeating: " ", count: longest - $0.count)).map({ Cell(rawValue: $0)! }) })
		let steps = parseSteps(input: split[1].trimmingCharacters(in: .newlines))
		
		var currentCoord = Coord(row: 0, col: 0)
		var currentDir: Direction = .right
		
		// Find start coord
		while board[currentCoord.row][currentCoord.col] != .walkable {
			currentCoord = Coord(row: currentCoord.row, col: currentCoord.col + 1)
		}
		
		print("starting at \(currentCoord), \(currentDir)")
		
		for step in steps {
			switch step {
			case let .forward(num):
				currentCoord = currentCoord.advancedBy(num, facing: currentDir, in: board)
			case .rotateRight:
				print("rotate right")
				currentDir = currentDir.rotatingRight()
			case .rotateLeft:
				print("rotate left")
				currentDir = currentDir.rotatingLeft()
			}
		}
		
		return "\(((currentCoord.row + 1) * 1000) + ((currentCoord.col + 1) * 4) + currentDir.score)"
	}
	
	public func solvePart2(input: String) -> String {
		return ""
	}
	
}
