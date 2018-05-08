require "socket"

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
            msg = msg[1..-1]
            matches = /:(.*)\/(.*)/.match(msg)
            num1 = Math.sqrt matches[1].to_i
            num2 = num1 * matches[2].to_i
            response = "PRIVMSG candy :!ep1 -rep #{num2.round(2)}"
            puts response
            s.puts(response)
        end
    end
}
sleep 5
s.puts "PRIVMSG candy :!ep1"

sleep
