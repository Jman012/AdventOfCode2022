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
		
		func rotatingCw(times: Int) -> Direction {
			var result = self
			for _ in 0..<times {
				result = result.rotatingRight()
			}
			return result
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
		
		func advancedOne(facing dir: Direction, wrappingRows: Int, wrappingCols: Int) -> Coord {
			let next = self.advancedOne(facing: dir)
			if next.row < 0 {
				return Coord(row: wrappingRows - 1, col: next.col)
			} else if next.row >= wrappingRows {
				return Coord(row: 0, col: next.col)
			} else if next.col < 0 {
				return Coord(row: next.row, col: wrappingCols - 1)
			} else if next.col >= wrappingCols {
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
		
		func advancedOne(facing dir: Direction, in board: [[Cell]], withFaces faces: [[Face?]]) -> (Coord, Direction) {
			// Calculate how many rows/cols of the board overall, of the faces in the board, and the cells in each face
			let (boardRows, boardCols) = (board.count, board.first!.count)
			let (faceRows, faceCols) = (faces.count, faces.first!.count)
			let (localRows, localCols) = (boardRows / faceRows, boardCols / faceCols)
			
			let faceCoord = Coord(row: self.row / localRows, col: self.col / localCols)
			let face = faces[faceCoord.row][faceCoord.col]!
			
			let nextCoord = self.advancedOne(facing: dir)
			let nextCoordFaceCoord = Coord(row: Int(floor(Double(nextCoord.row) / Double(localRows))), col: Int(floor(Double(nextCoord.col) / Double(localCols))))
			let nextCoordFace = nextCoordFaceCoord.is(in: faces) ? faces[nextCoordFaceCoord.row][nextCoordFaceCoord.col] : nil
			
			if face != nextCoordFace && nextCoordFace != nil {
				// Moved from one face to another face directly. No need to do anything, since the direction shouldn't change.
				return (nextCoord, dir)
			} else if nextCoordFace == nil {
				// Moved from one face to off the board. Need to wrap around to the correct face.
				// This is just the type of face we expect to move to. Ignore its rotations.
				let expected = face.newFace(toThe: dir)
				// Get the actual face we're jumping to, including its rotation and its face coordinate
				let actual = faces.enumerated()
					.flatMap({ original in original.element.enumerated().map({ (original.offset, $0.offset, $0.element) }) })
					.first(where: { $0.2 != nil && expected.caseEqual(to: $0.2!) })!
				
				// We need to rotate by the difference of the expected rotation and the actual rotation
				var rotations = actual.2!.cwRotations - expected.cwRotations
				rotations %= 4
				rotations += 4
				rotations %= 4
				
				// Find the new location:
				var actualNextCoord = self
				// Convert the current coord to its local coords in its face
				actualNextCoord = actualNextCoord.toLocal(localRows: localRows, localCols: localCols)
				// Move to the direction, but wrapping around back to the other side of the local face
				actualNextCoord = actualNextCoord.advancedOne(facing: dir, wrappingRows: localRows, wrappingCols: localCols)
				// Rotate as many times as the actual face is rotated
				actualNextCoord = actualNextCoord.rotateCW(times: rotations, rows: localRows, cols: localCols)
				// Convert back to global coordinates, but for the new face we should be on. Done!
				actualNextCoord = actualNextCoord.toGlobal(boardRows: boardRows, boardCols: boardCols, localRows: localRows, localCols: localCols, faceCoord: Coord(row: actual.0, col: actual.1))
				
				return (actualNextCoord, dir.rotatingCw(times: rotations))
			} else {
				// Moved within the current face. No need to do anything.
				return (nextCoord, dir)
			}
		}
		
		func toLocal(localRows: Int, localCols: Int) -> Coord {
			return Coord(row: self.row % localRows, col: self.col % localCols)
		}
		
		func toGlobal(boardRows: Int, boardCols: Int, localRows: Int, localCols: Int, faceCoord: Coord) -> Coord {
			return Coord(row: self.row + (faceCoord.row * localRows), col: self.col + (faceCoord.col * localCols))
		}
		
		func rotateCW(times: Int, rows _: Int, cols: Int) -> Coord {
			var result = self
			for _ in 0..<times {
				result = Coord(row: result.col, col: cols - result.row - 1)
			}
			return result
		}
		
		func advancedBy(_ num: Int, facing dir: Direction, in board: [[Cell]], withFaces faces: [[Face?]]) -> (Coord, Direction) {
			print("advance by \(num) facing \(dir)")
			var dir = dir
			var current = self
			print("starting at \(current)")
			for _ in 0..<num {
				let (next, newDir) = current.advancedOne(facing: dir, in: board, withFaces: faces)
				let nextCell = board[next.row][next.col]
				
				switch nextCell {
				case .walkable:
					current = next
					dir = newDir
					print("next space is walkable. now at \(current) and facing \(dir)")
				case .wall:
					print("next space is a wall. ending at \(current)  and facing \(dir)")
					return (current, dir)
				case .empty:
					// shouldn't reach
					exit(1)
				}
			}
			
			return (current, dir)
		}
	}
	
	enum Face: Equatable {
		case front(Int)
		case top(Int)
		case left(Int)
		case right(Int)
		case bottom(Int)
		case back(Int)
		
		var cwRotations: Int {
			switch self {
			case let .front(cwRotations): return cwRotations
			case let .top(cwRotations): return cwRotations
			case let .left(cwRotations): return cwRotations
			case let .right(cwRotations): return cwRotations
			case let .bottom(cwRotations): return cwRotations
			case let .back(cwRotations): return cwRotations
			}
		}
		
		func newFace(toThe dir: Direction) -> Face {
			switch self {
			case let .front(cwRotations):
				switch dir {
				case .up: return [.top(0), .left(1), .bottom(2), .right(3)][cwRotations % 4]
				case .down: return [.bottom(0), .right(1), .top(2), .left(3)][cwRotations % 4]
				case .left: return [.left(0), .bottom(1), .right(2), .top(3)][cwRotations % 4]
				case .right: return [.right(0), .top(1), .left(2), .bottom(3)][cwRotations % 4]
				}
			case let .top(cwRotations):
				switch dir {
				case .up: return [.back(2), .left(2), .front(2), .right(2)][cwRotations % 4]
				case .down: return [.front(0), .right(0), .back(0), .left(0)][cwRotations % 4]
				case .left: return [.left(1), .front(1), .right(1), .back(1)][cwRotations % 4]
				case .right: return [.right(3), .back(3), .left(3), .front(3)][cwRotations % 4]
				}
			case let .left(cwRotations):
				switch dir {
				case .up: return [.top(3), .back(1), .bottom(3), .front(3)][cwRotations % 4]
				case .down: return [.bottom(1), .front(1), .top(1), .back(3)][cwRotations % 4]
				case .left: return [.back(0), .bottom(2), .front(2), .top(2)][cwRotations % 4]
				case .right: return [.front(0), .top(0), .back(2), .bottom(0)][cwRotations % 4]
				}
			case let .right(cwRotations):
				switch dir {
				case .up: return [.top(1), .front(1), .bottom(1), .back(3)][cwRotations % 4]
				case .down: return [.bottom(3), .back(1), .top(3), .front(3)][cwRotations % 4]
				case .left: return [.front(0), .bottom(0), .back(2), .top(0)][cwRotations % 4]
				case .right: return [.back(0), .top(2), .front(2), .bottom(2)][cwRotations % 4]
				}
			case let .bottom(cwRotations):
				switch dir {
				case .up: return [.front(0), .left(0), .back(0), .right(0)][cwRotations % 4]
				case .down: return [.back(2), .right(2), .front(2), .left(2)][cwRotations % 4]
				case .left: return [.left(3), .back(3), .right(3), .front(3)][cwRotations % 4]
				case .right: return [.right(1), .front(1), .left(1), .back(1)][cwRotations % 4]
				}
			case let .back(cwRotations):
				switch dir {
				case .up: return [.top(2), .right(1), .bottom(0), .left(3)][cwRotations % 4]
				case .down: return [.bottom(2), .left(1), .top(0), .right(3)][cwRotations % 4]
				case .left: return [.right(0), .bottom(3), .left(2), .top(1)][cwRotations % 4]
				case .right: return [.left(0), .top(3), .right(2), .bottom(1)][cwRotations % 4]
				}
			}
		}
		
		func caseEqual(to face: Face) -> Bool {
			if case .front = self, case .front = face {
				return true
			} else if case .top = self, case .top = face {
				return true
			} else if case .left = self, case .left = face {
				return true
			} else if case .right = self, case .right = face {
				return true
			} else if case .bottom = self, case .bottom = face {
				return true
			} else if case .back = self, case .back = face {
				return true
			} else {
				return false
			}
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
	
	func walkAndPopulateFaces(faces: inout [[Face?]], facesPresent: [[Bool]], coord: Coord) {
		let dirs: [Direction] = [.up, .down, .left, .right]
		for dir in dirs {
			let dirCoord = coord.advancedOne(facing: dir)
			if dirCoord.is(in: faces) {
				if faces[dirCoord.row][dirCoord.col] == nil && facesPresent[dirCoord.row][dirCoord.col] == true {
					faces[dirCoord.row][dirCoord.col] = faces[coord.row][coord.col]?.newFace(toThe: dir)
					walkAndPopulateFaces(faces: &faces, facesPresent: facesPresent, coord: dirCoord)
				}
			}
		}
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
		let split = input.components(separatedBy: "\n\n")
		let longest = split[0].components(separatedBy: "\n").map({ $0.count }).max()!
		let board: [[Cell]] = split[0]
			.split(separator: "\n")
			.map({ ($0 + String(repeating: " ", count: longest - $0.count)).map({ Cell(rawValue: $0)! }) })
		let steps = parseSteps(input: split[1].trimmingCharacters(in: .newlines))
		
		// Assumption: faces are either 3:4 or 4:3
		let faceLength: Int
		let boardFacesRows: Int
		let boardFacesCols: Int
		if board.count > board[0].count {
			// Taller than wide
			faceLength = board.count / 4
			boardFacesRows = 4
			boardFacesCols = 3
		} else {
			// Wider than tall
			faceLength = board.count / 3
			boardFacesRows = 3
			boardFacesCols = 4
		}
		
		// See which faces are where, and the first found
		var firstFaceCoord: Coord! = nil
		var facesPresent: [[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: boardFacesCols), count: boardFacesRows)
		for row in 0..<boardFacesRows {
			for col in 0..<boardFacesCols {
				if board[row * faceLength][col * faceLength] != .empty {
					facesPresent[row][col] = true
					
					if firstFaceCoord == nil {
						firstFaceCoord = Coord(row: row, col: col)
					}
				}
			}
		}
		
		// Calculate face types and rotations
		var faces: [[Face?]] = [[Face?]](repeating: [Face?](repeating: nil, count: boardFacesCols), count: boardFacesRows)
		faces[firstFaceCoord.row][firstFaceCoord.col] = .front(0)
		walkAndPopulateFaces(faces: &faces, facesPresent: facesPresent, coord: firstFaceCoord)
		
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
				(currentCoord, currentDir) = currentCoord.advancedBy(num, facing: currentDir, in: board, withFaces: faces)
			case .rotateRight:
				print("rotate right")
				currentDir = currentDir.rotatingRight()
			case .rotateLeft:
				print("rotate left")
				currentDir = currentDir.rotatingLeft()
			}
		}
		
		return "\(((currentCoord.row + 1) * 1000) + ((currentCoord.col + 1) * 4) + currentDir.score)"
//		return "\(((currentCoord.row) * 1000) + ((currentCoord.col) * 4) + currentDir.score)"
	}
	
}
