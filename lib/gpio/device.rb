module GPIO
	module Device
		def mapping
			if self::PIN_MAP[:hardware] == :software
				:hardware
			elsif self::PIN_MAP[:software] == :hardware
				:software
			else
				raise "PIN_MAP has to provide a hint for mapping direction in the form of :hardware => :software, or reversed"
			end
		end
		def software_pin(pin)
			if mapping == :software
				raise "Software pin #{pin} doesn't exist." unless self::PIN_MAP.include? pin
				pin
			else
				pin1 = self::PIN_MAP[pin]
				raise "There is no software pin for hardware pin #{pin}" unless pin1
				pin1
			end
		end
		def hardware_pin(pin)
			if mapping == :hardware
				raise "Hardware pin #{pin} doesn't exist." unless self::PIN_MAP.include? pin
				pin
			else
				pin1 = self::PIN_MAP[pin]
				raise "There is no hardware pin for software pin #{pin}" unless pin1
				pin1
			end
		end
		def load_pins
			get_pins(:hardware).map{|pin| Pin.new(pin,get_direction(pin),self)}
		end
		def unexport_all!
			load_pins.map(&unexport!)
		end

		def get_pins(mapping)
			pins = Dir.entries self::BASE_PATH.select!{|pin| pin[/(?:#{PIN_PREFIX})(\d+)/]}.to_i
			pins.map!{|pin| Pin.new(pin,nil,self).pin}
		end
		def get_direction(software_pin)
			IO.read(direction_path(software_pin)).chomp!
		end

		def initialize_pin(software_pin, direction)
			unexport!(software_pin) if exported?(software_pin) && direction != get_direction(software_pin)
			export!(software_pin, direction) unless exported?(software_pin)
		end

		def exported?(software_pin)
			File.exists? pin_path(software_pin)
		end
		def export!(software_pin,direction)
			path_write self::EXPORT_PATH, software_pin
			path_write direction_path(software_pin), direction
			exported?(software_pin)
		end
		def unexport!(software_pin)
			path_write self::UNEXPORT_PATH, software_pin
			!exported? software_pin
		end

		def pin_file(software_pin, mode)
			m = case mode.to_s
			when 'in'; 'r'
			when 'out'; 'w+'
			when 'bi'; 'r+'
			end
			File.new value_path(software_pin), m
		end

		def read(software_pin)
			IO.read(value_path(software_pin), 1) == '1'
		end
		def write(software_pin,value)
			raise "This pin is an input." if get_direction(software_pin) == 'in'
			path_write value_path(software_pin), value
		end
		def path_write(path, value)
			File::Stat.new(path).writable? ? IO.write(path, value) : path_write_sudo(path, value)
		end
		def path_write_sudo(path, value)
			`sudo bash -c "echo #{value} > #{path}"`.chomp!
		end

		def pin_path(n)
			"#{self::BASE_PATH}#{self::PIN_PREFIX}#{n}/"
		end
		def direction_path(n)
			"#{pin_path(n)}#{self::DIRECTION_FILE}"
		end
		def value_path(n)
			"#{pin_path(n)}#{self::VALUE_FILE}"
		end

		def valid?
			IO.read(self::VALIDATE_FILE).chomp! == self::VALIDATE_VALUE
		end
	end
end
