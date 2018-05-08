require "socket"
require "zlib"
require "base64"

server = "irc.root-me.org"
port = "6667"
nick = "notabotreal"
channel = "#root-me_challenge"

s = TCPSocket.open(server, port)
print("addr: ", s.addr.join(":"), "\n")
print("peer: ", s.peeraddr.join(":"), "\n")
s.puts "USER testing 0 * Testing"
s.puts "NICK #{nick}"
s.puts "JOIN #{channel}"
payload_sent = false

# Have a thread monitor the output coming from the server
Thread::abort_on_exception = true
Thread.new {
    puts "Connection started..."
    until s.eof? do
        msg = s.gets
        puts msg
        if (msg.respond_to? :include?) && (msg.include? "Candy!Candy@root-me.org") && (!payload_sent)
            puts "Found!"
            matches = /:.*:(.*)/.match(msg)
            if !matches.nil?
                final = Zlib.inflate(Base64.decode64(matches[1]))
                response = "PRIVMSG candy :!ep4 -rep #{final}"
                puts response
                s.puts(response)
                payload_sent = true
            end
        end
    end
    puts "Connection lost..."
}
sleep 5
s.puts "PRIVMSG candy :!ep4"

sleep
