#!/usr/bin/env ruby

require 'socket'

class MyBot
  def initialize(server, port, channel)
    @channel = channel
    @socket = TCPSocket.open(server, port)
    say "NICK TestBot"
    say "USER TestBot 0 * TestBot"
    say "JOIN #{@channel}"
    say_to_chan "#{1.chr}ACTION is here to test#{1.chr}"
  end

  def say(msg)
    puts msg
    @socket.puts msg
  end

  def say_to_chan(msg)
    say "PRIVMSG #{@channel} :#{msg}"
  end
  
  def run
    until @socket.eof? do
      msg = @socket.gets
      puts msg

      if msg.match(/433/)
        abort "Nick is already in use."
      end

      if msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end

      if msg.match(/PRIVMSG #{@channel} :(.*)$/)
        content = $~[1]
	if content.match("hunger")
	  say_to_chan('was wollt ihr essen?')
	end
      end
    end
  end

  def quit
    say "PART #{@channel} byebye"
    say 'QUIT'
  end
end

bot = MyBot.new("irc.space.net", 6667, '#rudeltest')

trap("INT"){ bot.quit }

bot.run
