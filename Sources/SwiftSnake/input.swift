import Foundation

extension FileHandle {
    func enableRawMode() -> termios {
        var raw = termios()
        tcgetattr(self.fileDescriptor, &raw)

        let original = raw
        raw.c_lflag &= ~UInt32(ECHO | ICANON)
        tcsetattr(self.fileDescriptor, TCSADRAIN, &raw)
        return original
    }
}

class InputThread: Thread {
	override func main() {
		while true {
			var byte: UInt8 = 0
			read(FileHandle.standardInput.fileDescriptor, &byte, 1)
			
			switch byte {
				case 119: snake.turn(.up)
				case 97: snake.turn(.left)
				case 115: snake.turn(.down)
				case 100: snake.turn(.right)
				default: break
			}
		}
	}
}

func startInput() {
	_ = FileHandle.standardInput.enableRawMode()
	InputThread().start()
}