require "socket"

class String
    def rot13
        tr("a-zA-Z", "n-za-mN-ZA-M")
    end
end

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
Thread.new {
    puts "Connection started..."
    until s.eof? do
        msg = s.gets
        puts msg
        if msg.include? "Candy!Candy@root-me.org" && !payload_sent
            puts "Found!"
            matches = /:.*:(.*)/.match(msg)
            if !matches.nil?
                response = "PRIVMSG candy :!ep3 -rep #{matches[1].rot13}"
                puts response
                s.puts(response)
                payload_sent = true
            end
        end
    end
}
sleep 5
s.puts "PRIVMSG candy :!ep3"

sleep
