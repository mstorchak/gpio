module GPIO
	module RaspberryPiRevision2
	include RaspberryPi
	extend Device
	PIN_MAP.merge!({
		3   => 2,
		5   => 3,
		13  => 27,
		103 => 28,
		104 => 29,
		105 => 30,
		106 => 31
	})
	end
end
