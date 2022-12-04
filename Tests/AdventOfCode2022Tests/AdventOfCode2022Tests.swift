import XCTest
@testable import AdventOfCode2022

let doMeasure = false
let metrics: [XCTMetric] = [
	XCTClockMetric(),
//	XCTMemoryMetric(),
//	XCTCPUMetric(),
]

public struct Input {
	var inputExample1: String
	var inputExample2: String
	var inputPart1: String
	var inputPart2: String
	
	public init(day: Int) {
		let dayId = String(format: "%02d", day)
		
		let example1Path = Bundle.module.path(forResource: "Day\(dayId)-Example01", ofType: "txt", inDirectory: "Inputs")
		let example2Path = Bundle.module.path(forResource: "Day\(dayId)-Example02", ofType: "txt", inDirectory: "Inputs")
		let part1Path = Bundle.module.path(forResource: "Day\(dayId)-Part01", ofType: "txt", inDirectory: "Inputs")
		let part2Path = Bundle.module.path(forResource: "Day\(dayId)-Part02", ofType: "txt", inDirectory: "Inputs")
		
		guard let example1Path = example1Path, let part1Path = part1Path else {
			assert(false)
		}
		
		inputExample1 = try! String(contentsOfFile: example1Path)
		inputExample2 = example2Path != nil ? try! String(contentsOfFile: example2Path!) : try! String(contentsOfFile: example1Path)
		inputPart1 = try! String(contentsOfFile: part1Path)
		inputPart2 = part2Path != nil ? try! String(contentsOfFile: part2Path!) : try! String(contentsOfFile: part1Path)
	}
}

final class Day01Tests: XCTestCase {
	var day: Challenge { Day01() }
	var input: Input { Input(day: 1) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "24000")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "74394")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "45000")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "212836")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day02Tests: XCTestCase {
	var day: Challenge { Day02() }
	var input: Input { Input(day: 2) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "15")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "11767")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "12")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "13886")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day02CleanTests: XCTestCase {
	var day: Challenge { Day02Clean() }
	var input: Input { Input(day: 2) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "15")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "11767")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "12")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "13886")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day03Tests: XCTestCase {
	var day: Challenge { Day03() }
	var input: Input { Input(day: 3) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "157")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "7967")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "70")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "2716")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day04Tests: XCTestCase {
	var day: Challenge { Day04() }
	var input: Input { Input(day: 4) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "2")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "448")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "4")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "794")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}
