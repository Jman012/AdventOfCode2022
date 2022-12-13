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
			exit(1)
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

final class Day05Tests: XCTestCase {
	var day: Challenge { Day05() }
	var input: Input { Input(day: 5) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "CMZ")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "JRVNHHCSJ")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "MCD")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "GNFBSBJLH")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day06Tests: XCTestCase {
	var day: Challenge { Day06() }
	var input: Input { Input(day: 6) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "7")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "1723")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "19")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "3708")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day06OptimizedTests: XCTestCase {
	var day: Challenge { Day06Optimized() }
	var input: Input { Input(day: 6) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "7")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "1723")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "19")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "3708")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day07Tests: XCTestCase {
	var day: Challenge { Day07() }
	var input: Input { Input(day: 7) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "95437")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "1428881")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "24933642")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "10475598")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day07OptimizedTests: XCTestCase {
	var day: Challenge { Day07Optimized() }
	var input: Input { Input(day: 7) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "95437")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "1428881")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "24933642")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "10475598")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day08Tests: XCTestCase {
	var day: Challenge { Day08() }
	var input: Input { Input(day: 8) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "21")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "1787")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "8")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "440640")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day09Tests: XCTestCase {
	var day: Challenge { Day09() }
	var input: Input { Input(day: 9) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "13")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "5981")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "36")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "2352")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day10Tests: XCTestCase {
	var day: Challenge { Day10() }
	var input: Input { Input(day: 10) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "13140")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "14720")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), #"""
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....
"""#)
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), #"""
####.####.###..###..###..####.####.####.
#.......#.#..#.#..#.#..#.#.......#.#....
###....#..###..#..#.###..###....#..###..
#.....#...#..#.###..#..#.#.....#...#....
#....#....#..#.#....#..#.#....#....#....
#....####.###..#....###..#....####.#....
"""#)
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day11Tests: XCTestCase {
	var day: Challenge { Day11() }
	var input: Input { Input(day: 11) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "10605")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "120384")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "2713310158")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "32059801242")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day12Tests: XCTestCase {
	var day: Challenge { Day12() }
	var input: Input { Input(day: 12) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "31")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "497")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputExample2), "29")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "492")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}

final class Day13Tests: XCTestCase {
	var day: Challenge { Day13() }
	var input: Input { Input(day: 13) }
	func testPart1Example() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputExample1), "13")
	}
	func testPart1Real() throws {
		XCTAssertEqual(day.solvePart1(input: input.inputPart1), "5252")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart1(input: input.inputPart1)
			})
		}
	}
	func testPart2Example() throws {
			XCTAssertEqual(day.solvePart2(input: input.inputExample2), "140")
	}
	func testPart2Real() throws {
		XCTAssertEqual(day.solvePart2(input: input.inputPart2), "20592")
		if doMeasure {
			measure(metrics: metrics, block: {
				_ = day.solvePart2(input: input.inputPart2)
			})
		}
	}
}
