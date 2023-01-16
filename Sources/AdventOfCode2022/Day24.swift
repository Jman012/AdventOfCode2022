import Foundation

public struct Day24: Challenge {
	
	public init() {}
	
	enum Direction: String, Hashable {
		case up = "^"
		case down = "v"
		case left = "<"
		case right = ">"
	}
	
	struct Coord: Hashable, CustomDebugStringConvertible {
		let row: Int
		let col: Int
		
		var debugDescription: String {
			return "(\(row), \(col))"
		}
		
		func advancedOne(facing dir: Direction) -> Coord {
			switch dir {
			case .right: return Coord(row: self.row, col: self.col + 1)
			case .left: return Coord(row: self.row, col: self.col - 1)
			case .up: return Coord(row: self.row - 1, col: self.col)
			case .down: return Coord(row: self.row + 1, col: self.col)
			}
		}
		
		func `is`<T>(in board: [[T]]) -> Bool {
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
	}
	
	enum Cell: Hashable, CustomStringConvertible {
		case wall
		case empty
		case blizzard([Direction])
		
		var description: String {
			switch self {
			case .wall: return "#"
			case .empty: return "."
			case let .blizzard(blizzards):
				if blizzards.count == 1 {
					return blizzards.first!.rawValue
				} else {
					return "\(blizzards.count)"
				}
			}
		}
		
		init(value: Character) {
			switch value {
			case "#": self = .wall
			case ".": self = .empty
			default: self = .blizzard([Direction(rawValue: String(value))!])
			}
		}
	}
	
	func printBoard(board: [[Cell]]) {
		let s = board.map({ $0.map({ $0.description }).joined() }).joined(separator: "\n")
		print(s + "\n")
	}
	
	func iterate(board: [[Cell]]) -> [[Cell]] {
		let rows = board.count
		let cols = board.first!.count
		var newBoard: [[Cell]] = .init(repeating: .init(repeating: .empty, count: cols), count: rows)
		
//		print("Empty board:")
//		printBoard(board: newBoard)
		
		// Fill walls first
		for row in 0..<rows {
			if board[row][0] == .wall {
				newBoard[row][0] = .wall
			}
			if board[row][cols-1] == .wall {
				newBoard[row][cols-1] = .wall
			}
		}
		for col in 0..<cols {
			if board[0][col] == .wall {
				newBoard[0][col] = .wall
			}
			if board[rows-1][col] == .wall {
				newBoard[rows-1][col] = .wall
			}
		}
		
//		print("With walls:")
//		printBoard(board: newBoard)
		
		// Calculate within the walls
		for row in 1..<rows-1 {
			for col in 1..<cols-1 {
				switch board[row][col] {
				case .wall:
					newBoard[row][col] = .wall
				case .empty:
					continue
				case let .blizzard(blizzards):
					for blizzard in blizzards {
						var newRow, newCol: Int
						switch blizzard {
						case .up:
							newRow = row - 1
							newCol = col
						case .down:
							newRow = row + 1
							newCol = col
						case .left:
							newRow = row
							newCol = col - 1
						case .right:
							newRow = row
							newCol = col + 1
						}
						
						if board[newRow][newCol] == .wall {
							switch blizzard {
							case .up:
								newRow = rows - 2
							case .down:
								newRow = 1
							case .left:
								newCol = cols - 2
							case .right:
								newCol = 1
							}
						}
						
						switch newBoard[newRow][newCol] {
						case .wall:
							exit(1)
						case .empty:
							newBoard[newRow][newCol] = .blizzard([blizzard])
						case let .blizzard(blizzards):
							newBoard[newRow][newCol] = .blizzard(blizzards + [blizzard])
						}
					}
				}
				
//				print("after processing (\(row), \(col):")
//				printBoard(board: newBoard)
			}
		}
		
		return newBoard
	}
	
	func possiblePositions(initialPositions: Set<Coord>, boardsSequence: [[[Cell]]], fromIteration iteration: Int) -> Set<Coord> {
		var newPositions: Set<Coord> = []
		let nextBoard = boardsSequence[(iteration) % boardsSequence.count]
		
		for initialPosition in initialPositions {
			// If it's still empty, we can wait in place
			if nextBoard[initialPosition.row][initialPosition.col] == .empty {
				newPositions.formUnion([initialPosition])
			}
			
			let dirs: [Direction] = [.up, .down, .left, .right]
			for dir in dirs {
				let newCoord = initialPosition.advancedOne(facing: dir)
				if newCoord.is(in: nextBoard) && nextBoard[newCoord.row][newCoord.col] == .empty {
					newPositions.formUnion([newCoord])
				}
			}
		}
		
		return newPositions
	}
	
	public func solvePart1(input: String) -> String {
		var board: [[Cell]] = input
			.split(separator: "\n")
			.map({ $0.map({ Cell(value: $0) }) })
		
//		printBoard(board: board)
//		for _ in 0..<10 {
//			board = iterate(board: board)
//			printBoard(board: board)
//		}
		
		var boardsSequence: [[[Cell]]] = [board]
		var boardSet: Set<[[Cell]]> = [board]
		while true {
			board = iterate(board: board)
			
			if boardSet.contains(board) {
				break
			}
			
			boardSet.formUnion([board])
			boardsSequence.append(board)
		}
		
//		print("there are \(boardsSequence.count) number of board states")
		
		var positions: Set<Coord> = [Coord(row: 0, col: 1)]
		var i = 1
		let finalCoord = Coord(row: board.count - 1, col: board.first!.count - 2)
		while !positions.contains(finalCoord) {
			positions = possiblePositions(initialPositions: positions, boardsSequence: boardsSequence, fromIteration: i)
//			print("Minute \(i):")
//			print(positions)
//			printBoard(board: boardsSequence[(i+1) % boardsSequence.count])
			i += 1
		}
		
		return "\(i-1)"
	}
	
	public func solvePart2(input: String) -> String {
		var board: [[Cell]] = input
			.split(separator: "\n")
			.map({ $0.map({ Cell(value: $0) }) })
		
		var boardsSequence: [[[Cell]]] = [board]
		var boardSet: Set<[[Cell]]> = [board]
		while true {
			board = iterate(board: board)
			
			if boardSet.contains(board) {
				break
			}
			
			boardSet.formUnion([board])
			boardsSequence.append(board)
		}
		
//		print("there are \(boardsSequence.count) number of board states")
		
		let startCoord = Coord(row: 0, col: 1)
		var positions: Set<Coord> = [startCoord]
		var i = 1
		let finalCoord = Coord(row: board.count - 1, col: board.first!.count - 2)
		while !positions.contains(finalCoord) {
			positions = possiblePositions(initialPositions: positions, boardsSequence: boardsSequence, fromIteration: i)
//			print("Minute \(i):")
//			print(positions)
//			printBoard(board: boardsSequence[(i+1) % boardsSequence.count])
			i += 1
		}
		
		positions = [finalCoord]
		while !positions.contains(startCoord) {
			positions = possiblePositions(initialPositions: positions, boardsSequence: boardsSequence, fromIteration: i)
			i += 1
		}
		
		positions = [startCoord]
		while !positions.contains(finalCoord) {
			positions = possiblePositions(initialPositions: positions, boardsSequence: boardsSequence, fromIteration: i)
			i += 1
		}
		
		return "\(i-1)"
	}
	
}
