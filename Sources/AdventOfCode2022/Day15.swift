import Foundation

public struct Day15: Challenge {
	
	let targetY: Int
	
	public init(targetY: Int) {
		self.targetY = targetY
	}
	
	struct Coord: Hashable {
		let x: Int
		let y: Int
	}
	
	enum Cell: String {
		case unknown = "."
		case sensor = "S"
		case beacon = "B"
		case empty = "#"
	}
	
	public func solvePart1(input: String) -> String {
		let coords = input
			.split(separator: "\n")
			.map({ line in
				let cleaned = line.dropFirst("Sensor at x=".count)
				let split = cleaned.components(separatedBy: ": closest beacon is at x=")
				let sensorSplit = split[0].components(separatedBy: ", y=")
				let beaconSplit = split[1].components(separatedBy: ", y=")
				return (Coord(x: Int(sensorSplit[0])!, y: Int(sensorSplit[1])!), Coord(x: Int(beaconSplit[0])!, y: Int(beaconSplit[1])!))
			})
		
		var board: [Coord: Cell] = [:]
		for coord in coords {
			board[coord.0] = .sensor
			board[coord.1] = .beacon
		}
		
		let minX = coords.map({ [$0.0.x, $0.1.x] }).flatMap({ $0 }).min()!
		let maxX = coords.map({ [$0.0.x, $0.1.x] }).flatMap({ $0 }).max()!
		let minY = coords.map({ [$0.0.y, $0.1.y] }).flatMap({ $0 }).min()!
		let maxY = coords.map({ [$0.0.y, $0.1.y] }).flatMap({ $0 }).max()!
		
//		for y in minY...maxY {
//			for x in minX...maxX {
//				print((board[Coord(x: x, y: y)] ?? .unknown).rawValue, terminator: "")
//			}
//			print()
//		}
//		print()
		
		let targetY = self.targetY
		var targetYLinePairs: [(Coord, Coord)] = []
		for coord in coords {
			let sensorCoord = coord.0
			let beaconCoord = coord.1
			let manhattanDistance = abs(sensorCoord.x - beaconCoord.x) + abs(sensorCoord.y - beaconCoord.y)
			let distanceToTargetY = abs(targetY - sensorCoord.y)
			if distanceToTargetY > manhattanDistance {
				continue
			}
			let left = Coord(x: sensorCoord.x + (-1 * (manhattanDistance - distanceToTargetY)), y: targetY)
			let right = Coord(x: sensorCoord.x + (1 * (manhattanDistance - distanceToTargetY)), y: targetY)
			targetYLinePairs.append((left, right))
		}
		
		/*
		for coord in coords {
			let sensorCoord = coord.0
			let beaconCoord = coord.1
			
			let manhattanDistance = abs(sensorCoord.x - beaconCoord.x) + abs(sensorCoord.y - beaconCoord.y)
			let dirs = [Coord(x: 0, y: 1), Coord(x: 0, y: -1), Coord(x: 1, y: 0), Coord(x: -1, y: 0)]
			for (i, radius) in (1...manhattanDistance).reversed().enumerated() {
				let cells = dirs
					.map({ Coord(x: sensorCoord.x + $0.x * radius, y: sensorCoord.y + $0.y * radius) })
					+ (0...i).map({ Coord(x: sensorCoord.x + $0, y: sensorCoord.y + -1 * radius) })
					+ (0...i).map({ Coord(x: sensorCoord.x - $0, y: sensorCoord.y + 1 * radius) })
					+ (0...i).map({ Coord(x: sensorCoord.x + -1 * radius, y: sensorCoord.y - $0) })
					+ (0...i).map({ Coord(x: sensorCoord.x + 1 * radius, y: sensorCoord.y + $0) })
				for cell in cells {
					board[cell] = .empty
				}
			}
			
//			for y in minY...maxY {
//				for x in minX...maxX {
//					print((board[Coord(x: x, y: y)] ?? .unknown).rawValue, terminator: "")
//				}
//				print()
//			}
//			print()
		}
		*/
		
//		for coord in coords {
//			board[coord.0] = .sensor
//			board[coord.1] = .beacon
//		}
		
//		for y in minY...maxY {
//			for x in minX...maxX {
//				print((board[Coord(x: x, y: y)] ?? .unknown).rawValue, terminator: "")
//			}
//			print()
//		}
//		print()
		
//		let newMinX = coords.map({ [$0.0.x, $0.1.x] }).flatMap({ $0 }).min()!
//		let newMaxX = coords.map({ [$0.0.x, $0.1.x] }).flatMap({ $0 }).max()!
//		let newMinY = coords.map({ [$0.0.y, $0.1.y] }).flatMap({ $0 }).min()!
//		let newMaxY = coords.map({ [$0.0.y, $0.1.y] }).flatMap({ $0 }).max()!
		
//		let emptyOnY10 = (newMinX...newMaxX).map({ Coord(x: $0, y: 10) }).filter({ board[$0] == .empty }).count
//		let emptyOnY2000000 = (newMinX...newMaxX).map({ Coord(x: $0, y: 2000000) }).filter({ board[$0] == .empty }).count
		
		var board2: Set<Coord> = []
		for (left, right) in targetYLinePairs {
			board2.formUnion((left.x...right.x).map({ Coord(x: $0, y: targetY) }))
		}
		board2.subtract(coords.map({ $0.1 }))
		
		return "\(board2.count)"
	}
	
	public func solvePart2(input: String) -> String {
		let coords = input
			.split(separator: "\n")
			.map({ line in
				let cleaned = line.dropFirst("Sensor at x=".count)
				let split = cleaned.components(separatedBy: ": closest beacon is at x=")
				let sensorSplit = split[0].components(separatedBy: ", y=")
				let beaconSplit = split[1].components(separatedBy: ", y=")
				return (Coord(x: Int(sensorSplit[0])!, y: Int(sensorSplit[1])!), Coord(x: Int(beaconSplit[0])!, y: Int(beaconSplit[1])!))
			})
		
		let boundingBox = self.targetY
		let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", qos: .userInteractive, attributes: .concurrent)
		var result: String = ""
		for targetY in 0...boundingBox {
//			concurrentQueue.async {
//				print("Trying y=\(targetY)")
				var targetYLinePairs: [(Coord, Coord)] = []
				for coord in coords {
					let sensorCoord = coord.0
					let beaconCoord = coord.1
					let manhattanDistance = abs(sensorCoord.x - beaconCoord.x) + abs(sensorCoord.y - beaconCoord.y)
					let distanceToTargetY = abs(targetY - sensorCoord.y)
					if distanceToTargetY > manhattanDistance {
						continue
					}
					let left = Coord(x: sensorCoord.x + (-1 * (manhattanDistance - distanceToTargetY)), y: targetY)
					let right = Coord(x: sensorCoord.x + (1 * (manhattanDistance - distanceToTargetY)), y: targetY)
					targetYLinePairs.append((left, right))
				}
				
			targetYLinePairs.sort(by: { $0.0.x < $1.0.x })
			var leftX: Int = 0
			var rightX: Int = 0
			for (index, (left, right)) in targetYLinePairs.enumerated() {
				let newLeftX = left.x < 0 ? 0 : left.x
				let newRightX = right.x > boundingBox ? boundingBox : right.x
				if index == 0 {
					leftX = newLeftX
					rightX = newRightX
				} else {
					if newLeftX <= rightX && rightX < newRightX {
						rightX = newRightX
					} else if rightX < newLeftX {
						result = "\((rightX + 1) * 4_000_000 + targetY)"
						return result
					}
				}
			}
				
//				var board2: Set<Coord> = []
//				for (left, right) in targetYLinePairs {
//					let newLeftX = left.x < 0 ? 0 : left.x
//					let newRightX = right.x > boundingBox ? boundingBox : right.x
//					if newLeftX > newRightX {
//						continue
//					}
//					board2.formUnion((newLeftX...newRightX).map({ Coord(x: $0, y: targetY) }))
//				}
//	//			board2.subtract(coords.map({ $0.1 }))
//				if board2.count < boundingBox + 1 {
//					let coord = Set((0...boundingBox).map({ Coord(x: $0, y: targetY) })).subtracting(board2).first!
//					result = "\(coord.x * 4_000_000 + coord.y)"
//				}
//			}
		}
		
//		while result == "" { }
		
		return result
	}
	
}
