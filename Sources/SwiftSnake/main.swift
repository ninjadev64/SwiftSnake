import Foundation
import Rainbow

let boardSize = 20
let boardArraySize = boardSize - 1

enum CellType {
	case g // ground
	case s // snake
	case f // fruit
}

// create a blank board template
var blankBoard: [[CellType]] = []
for _ in 0...boardArraySize {
	var row: [CellType] = []
	for _ in 0...boardArraySize {
		row.append(.g)
	}
	blankBoard.append(row)
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
var fruit = Position(x: boardArraySize - 1, y: boardArraySize - 1)

// see input.swift
startInput()

// game loop
while true {
	snake.advance()
	snake.hasTurned = false
	var board: [[CellType]] = blankBoard

	board[fruit.y][fruit.x] = .f
	for position in snake.positions {
		if (position.x > boardArraySize || position.y > boardArraySize) || (position.x < 0 || position.y < 0) {
			continue
		}
		board[position.y][position.x] = .s
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
		fruit = Position(x: Int.random(in: 0...boardArraySize), y: Int.random(in: 0...boardArraySize))
	}
	
	var toPrint = ""
	for row in board {
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
	Thread.sleep(forTimeInterval: 0.25)

	// clear the terminal
	print("\u{001B}[H\u{001B}[2J")
}