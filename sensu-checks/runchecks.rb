require 'json'

role = ARGV[0]

puts "Running sensu checks for: #{role}"

check_config_files = Dir.glob("*.json")

check_config_files.each do |check_config_file|
	config = nil
	File.open( check_config_file, "r" ) do |json_file|
    	config = JSON.load( json_file )
	end

	checks_for_this_role = config['checks'].select do |check,check_data| 
		check_data['subscribers'] && check_data['subscribers'].include?(role)
	end

	checks_for_this_role.each do |check_name,check_config|
		puts "Running check: #{check_name}"
		output = `#{check_config['command']}`
		puts output
		returncode = $?.to_i
		if returncode != 0
			puts "Check failed"
		else
			puts "Check passed"
		end
	end
end