class IRC
	require 'socket'
	def connect(server,port,nick,name,host)
		@con=TCPSocket.new(server,port)
		set_details(nick,name,host)
	end
	
	def set_details(nick,name,host)
		send "USER #{nick} #{host} bla :#{name}"
		set_nickname nick		
	end

	def recv
		m = @con.recv(512)
		if m =~ /^PING :/ then
			server = m.scan(/^PING :(.*)/).join
			send("PONG #{server}")
			return recv
		else
			return m
		end
	end

	private

	def send(s)
		s=s.gsub(/\n/,'').gsub(/\r/,'')
		@con.send(s + "\n", 0)
	end

	def set_nickname(nick)
		send("NICK #{nick}")
		r=@con.recv(512)
		while r !~ /^:.* 001.*/
			if r =~ /Nickname is already in use/
				nick=nick + "_"
				send("NICK #{nick}")
			end
			r=@con.recv(512)
		end
		nick
	end
end
