class Logger
	def initialize(output)
		@output = output
		log "** session start #{Time.now}"
	end
	
	def log(s)
		if @output == "STDOUT"
			puts s
		else
			store s
		end
	end

	def close
		log "** session end #{Time.now}\n\n"
		@file.close
	end

	private

	def store(s)
		file_name = "log/#{Time.now.strftime("%d-%m-%y")}.log"
		if @file then
			if @file.path != file_name then
				@file.close
				@file=File.new(file_name,"a+")
				store s
			end
			@file.write("#{Time.now.strftime("%H:%M:%S")} - #{s}\n")
		else
			@file=File.new(file_name,"a+")
			store s
		end
	end
end
