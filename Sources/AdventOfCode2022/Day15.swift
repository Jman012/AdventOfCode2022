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
//		let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", qos: .userInteractive, attributes: .concurrent)
		var result: String = ""
		for targetY in 0...boundingBox {
//			concurrentQueue.async {
//							print("Trying y=\(targetY)")
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
//			}
		}
		
//		while result == "" { }
		
		return result
	}
	
}
