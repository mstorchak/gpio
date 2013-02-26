module GPIO
	module RaspberryPi
		extend Device

		VALIDATE_FILE = "/sys/class/gpio/gpiochip0/label"
		VALIDATE_VALUE = "bcm2708_gpio"
		PIN_MAP = {
			:hardware => :software,
			3  => 0,
			5  => 1,
			7  => 4,
			8  => 14,
			10 => 15,
			11 => 17,
			12 => 18,
			13 => 21,
			15 => 22,
			16 => 23,
			18 => 24,
			19 => 10,
			21 => 9,
			22 => 25,
			23 => 11,
			24 => 8,
			26 => 7
		}
		BASE_PATH = '/sys/class/gpio/'
		EXPORT_PATH = "#{BASE_PATH}export"
		UNEXPORT_PATH = "#{BASE_PATH}unexport"
		PIN_PREFIX = "gpio"
		DIRECTION_FILE = "direction"
		VALUE_FILE = "value"
	end
end
