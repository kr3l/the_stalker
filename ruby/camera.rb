require 'rubygems'
require 'serialport'

puts "   ___ "
puts "  |o_o|  "
puts " ___Y___  "
puts "| CAMERA |"
puts "|________|"
puts "==     =="
puts ""

#HELPER FUNCTIONS

def isNumeric(s)
    Float(s) != nil rescue false
end

sensor_name = {
	'A' => "Distance Sensor",
	'S' => "Servo"
}

$connected = false

#END HELPER FUNCTIONS


#create a SerialPort connection, exit on fail
begin
	sp = SerialPort.new "/dev/ttyUSB0", 57600
	#sp = SerialPort.new "/dev/rfcomm0", 115200
#	sp.read_timeout=100
rescue
	puts $!
	puts "Connect your computer to the Robot via Bluetooth before running this script!"
	puts "exiting"
	exit
end

#Thread that listens for keyboard-commands
Thread.abort_on_exception = true
t1 = Thread.new do
	servoAngle = 90;
	while !$connected
		sleep 1
	end
	puts "ENTER COMMAND A,Z,Q,S or D followed by return key"
	while true
		command = gets
		command.upcase!
		puts command[0..0].to_s
		puts " KEYBOARD COMMAND #{command[0..0]}"

		if(command[0..0] == 'C')
                        puts "CAMERA ON!"
			sp.puts("CAMERA_ON")
		end
                if(command[0..0] == 'X')
                        puts "CAMERA REC!"
                        sp.puts("CAMERA_REC")
                end
		


	end
end




def get_line(sp)
        output = ""
        c = nil
        puts "got:"
        while ((c = sp.getc) != nil)
                output += c.chr
                print c.chr
                break if c.chr == "\n"
        end
        puts "break"
        return output
end


#connect to Robot with PING-PONG cycle
answer = ""
puts "TRYING TO CONNECT"
while (answer[0..-3] != "PONG")
	puts "answer:#{answer}"
	puts "sending:PING"
	sp.puts("PING\n")
	answer = get_line(sp)
	puts " -- RUBOT returned #{answer}"
end
$connected = true
#puts "CONNECTED!"



while 1
	#request sensor values
	answer = ""
#	puts "REQUESTING SENSOR VALUES"
#	sp.puts("GET_SENSORS")
	answer = get_line(sp) #sp.gets
	puts " -- RUBOT returned #{answer}"
	sensors = answer.split(";")
	sensor_arr = Array.new
	sensors.each do |sensor_str|
		sensor_tmp = sensor_str.split(",")
		valid = sensor_tmp.length>1
		if valid
			sensor_tmp[1..-1].each do |sensor_val|
				if  !isNumeric(sensor_val)
					valid=false
					break
				end
			 end
			 
			 if valid
				sensor_arr = sensor_tmp.collect {|x| x.to_i}
				puts " -- -- #{sensor_name[sensor_tmp[0]]} has values " + sensor_arr[1..-1].join("-")
			else
				puts " -- -- error, sensor request returned #{sensor_str}"
			end
		end
	end

	#make decision about motor values and other outputs
	if sensor_arr.size>2
		if sensor_arr[1]<200 and sensor_arr[2]<200
			motor_left = -1
			motor_right = -1
		elsif sensor_arr[1]>sensor_arr[2]+100
			motor_left = 1
			motor_right = -1
		elsif sensor_arr[2]>sensor_arr[1]+100
			motor_left = -1
			motor_right = 1
		else
			motor_left = 1
			motor_right = 1
		end
		#puts "SETTING MOTOR VALUES"
		#sp.puts("D,#{motor_left},#{motor_right}")
	end
	
	sleep 2
end

sp.close
