#!/usr/bin/env ruby

require 'socket'

class MyBot
  def initialize(server, port, channel, nick, login, username)
    @channel = channel
    @socket = TCPSocket.open(server, port)
    say "NICK #{nick}"
    say "USER #{login} 8 * :#{username}"
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
      if msg.match(/004/)
        break
      elsif msg.match(/433/)
        abort "Nick is already in use."
      end
    end

    until @socket.eof? do
      msg = @socket.gets
      puts msg

      if msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end

      if msg.match(/PRIVMSG #{@channel} :(.*)$/)
        content = $~[1]
	if content.match(/\+help"/)
	  say_to_chan('+orte     - gibt eine Liste aller Orte aus, die ich kenne.')
	  say_to_chan('+1 ort    - stimmt fuer den Ort.')
	  say_to_chan('+stand    - gibt den aktuellen Punketstand aus.')
	  say_to_chan('+wasgibts - schickt den aktuellen Intra-Link.')
	  say_to_chan('+werfehlt - zeigt alle an, die noch nicht gevotet haben.')
	end
      end
    end
  end

  def quit
    say "PART #{@channel} byebye"
    say 'QUIT'
  end
end

bot = MyBot.new("irc.space.net", 6667, '#rudeltest', "MahlzeitT", "MahlzeitT", "MahlzeitBot")

trap("INT"){ bot.quit }

bot.run
