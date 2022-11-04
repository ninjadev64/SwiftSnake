import Foundation
import Rainbow

print("Enter size of map (default: 20):", terminator: " ")
let mapSize = Int(readLine() ?? "20") ?? 20

print("Enter speed of snake (default: 0.2):", terminator: " ")
let snakeSpeed = Float(readLine() ?? "0.2") ?? 0.2

let mapArraySize = mapSize - 1

enum CellType {
	case g // ground
	case s // snake
	case f // fruit
}

// create a blank board template
var blankMap: [[CellType]] = []
for _ in 0...mapArraySize {
	var row: [CellType] = []
	for _ in 0...mapArraySize {
		row.append(.g)
	}
	blankMap.append(row)
}

/// Represents the coordinates of a cell.
struct Position: Equatable {
	var x: Int
	var y: Int
}

/// A controller struct with methods to manipulate a snake.
struct Snake {
	enum Direction {
		case up
		case left
		case down
		case right
	}
	
	var positions = [
		Position(x: 2, y: 2),
		Position(x: 3, y: 2),
		Position(x: 4, y: 2),
		Position(x: 5, y: 2)
	]

	var direction: Direction = .right
	var hasTurned = false

	/// Move the entire snake on the x and/or y axis.
	mutating func translate(x: Int = 0, y: Int = 0) {
		for (index, _) in positions.enumerated() {
			positions[index].x += x
			positions[index].y += y
		}
	}

	/// Switch the direction the snake is now travelling in.
	mutating func turn(_ direction: Direction) {
		if hasTurned {
			return
		}
		if ((self.direction == .left && direction == .right) || (self.direction == .right && direction == .left))
		|| ((self.direction == .up && direction == .down) || (self.direction == .down && direction == .up)) {
			return
		}
		self.direction = direction
		hasTurned = true
	}

	/// Move the snake one cell forward in the direction it's facing.
	mutating func advance() {
		let head = positions[positions.count - 1]
		switch direction {
			case .up: positions.append(Position(x: head.x, y: head.y - 1))
			case .left: positions.append(Position(x: head.x - 1, y: head.y))
			case .down: positions.append(Position(x: head.x, y: head.y + 1))
			case .right: positions.append(Position(x: head.x + 1, y: head.y))
		}
		positions.removeFirst()
	}
}

var snake = Snake()
var fruit = Position(x: mapArraySize - 1, y: mapArraySize - 1)

// see input.swift
startInput()

// game loop
while true {
	snake.advance()
	snake.hasTurned = false
	var map: [[CellType]] = blankMap

	map[fruit.y][fruit.x] = .f
	for position in snake.positions {
		if (position.x > mapArraySize || position.y > mapArraySize) || (position.x < 0 || position.y < 0) {
			continue
		}
		map[position.y][position.x] = .s
	}

	// check if the snake is eating a fruit, and grow the tail if so
	if snake.positions[snake.positions.count - 1] == fruit {
		let tail = snake.positions[0]
		switch snake.direction {
			case .up: snake.positions.insert(Position(x: tail.x, y: tail.y + 1), at: 0)
			case .left: snake.positions.insert(Position(x: tail.x + 1, y: tail.y), at: 0)
			case .down: snake.positions.insert(Position(x: tail.x, y: tail.y - 1), at: 0)
			case .right: snake.positions.insert(Position(x: tail.x - 1, y: tail.y), at: 0)
		}
		// re-randomise the fruit
		fruit = Position(x: Int.random(in: 0...mapArraySize), y: Int.random(in: 0...mapArraySize))
	}
	
	var toPrint = ""
	for row in map {
		for cell in row {
			switch cell {
				case .g: toPrint+=("  ".onGreen)
				case .s: toPrint+=("  ".onBlue)
				case .f: toPrint+=("  ".onRed)
			}
		}
		toPrint+="\n"
	}
	print(toPrint)
	Thread.sleep(forTimeInterval: TimeInterval(snakeSpeed))

	// clear the terminal
	print("\u{001B}[H\u{001B}[2J")
}