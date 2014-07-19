#!/usr/bin/env ruby

require 'socket'
require 'yaml'

class MyBot
  def initialize(server, port, channel, nick, cache, wasgibts)
    @channel = channel
    @nick = nick
    @cache = cache
    @wasgibts = wasgibts
    @socket = TCPSocket.open(server, port)
    say "NICK #{@nick}"
    say "USER #{@nick} 8 * :#{@nick}"
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

  def check
    until @socket.eof? do
      msg = @socket.gets
      puts msg

      if msg.match(/004/)
        break
      elsif msg.match(/433/)
        abort "Nick is already in use."
      end
    end
  end
  
  def run
    check

    until @socket.eof? do
      msg = @socket.gets
      puts msg

      if msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end

      if msg.match(/^:(.*)!(.*) PRIVMSG #{@channel} :(.*)$/)
	nick = $~[1]
	login = $~[2]
        content = $~[3]

	if nick == @nick
	  next
	end

	if content.match(/\+help/)
	  help
	end

	if content.match(/\+([0-9]*) (.*)/)
	  votes = $~[1]
	  voted_loc = $~[2].chop
	end

	if content.match(/\+orte/)
	  orte
	end

	if content.match(/\+stand/)
	end

	if content.match(/\+wasgibts/)
	  wasgibts(nick)
	end

	if content.match(/\+werfehlt/)
	end

	if content.match(/\+add (.*)/)
	  loc = $~[1].chop

	  add_loc loc
	end

	if content.match(/\+del (.*)/)
	  loc = $~[1].chop
	end

	if content.match(/\+reset/)
	end
      end
    end
  end

  def help
    say_to_chan "+orte     - gibt eine Liste aller Orte aus, die ich kenne."
    say_to_chan "+1 ORT    - stimmt fuer den Ort."
    say_to_chan "+stand    - gibt den aktuellen Punktestand aus."
    say_to_chan "+wasgibts - schickt den aktuellen Intra-Link."
    say_to_chan "+werfehlt - zeigt alle an, die noch nicht gevotet haben."
    say_to_chan "+add ORT  - fuegt einen Ort hinzu."
    say_to_chan "+del ORT  - entfernt einen Ort."
    say_to_chan "+reset    - setzt alle Votes zurueck."
  end

  def orte
    file = YAML.load_file(@cache)
    file_keys = []

    file["locations"].each do |k|
      file_keys << k
    end

    say_to_chan(file_keys.join(", "))
  end

  def add_loc(loc)
    file = YAML.load_file(@cache)

    if file["locations"].map { |k, v| k.downcase }.include?(loc.downcase)
      say_to_chan "#{loc} kenne ich bereits."
    else
      file["locations"]["#{loc}"] = ""
    
      File.open(@cache, "w") do |f|
        f.write file.to_yaml
      end

      say_to_chan "#{loc} hinzugefuegt."
    end
  end

  def wasgibts(nick)
    say_to_chan("#{nick}, schau bitte hier: #{@wasgibts}")
  end

  def quit
    say "PART #{@channel} byebye"
    say 'QUIT'
  end
end


config = YAML.load_file("mahlzeitbot.yml")
bot = MyBot.new(config["irc"]["server"], config["irc"]["port"], config["irc"]["channel"], config["irc"]["nick"], config["cache", config["wasgibts"]])

trap("INT"){ bot.quit }

bot.run
