module GPIO
	module Other
		extend Device

		VALIDATE_FILE = "/sys/class/gpio/gpiochip0/label"
		VALIDATE_VALUE = "chipset_gpio"

		PIN_MAP = {
			:hardware => :software,
			0 => 2,
			1 => 1,
			2 => 0
		}
		BASE_PATH = '/sys/class/gpio/'
		EXPORT_PATH = "#{BASE_PATH}export"
		UNEXPORT_PATH = "#{BASE_PATH}unexport"
		PIN_PREFIX = "gpio"
		DIRECTION_FILE = "mode"
		VALUE_FILE = "value"
	end
end
