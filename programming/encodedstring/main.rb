require "socket"
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

# Have a thread monitor the output coming from the server
Thread.new {
    puts "Connection started..."
    until s.eof? do
        msg = s.gets
        puts msg
        if msg.include? "Candy!Candy@root-me.org"
            puts "Found!"
            matches = /:.*:(.*)/.match(msg)
            if !matches.nil?
                response = "PRIVMSG candy :!ep2 -rep #{Base64.decode64(matches[1])}"
                puts response
                s.puts(response)
            end
        end
    end
}
sleep 5
s.puts "PRIVMSG candy :!ep2"

sleep
