require 'rubygems'

@args = ARGV
@name = @args.first.to_s.downcase

if @name.empty?
  puts "USAGE: ruby minime.rb <new_file.css>"
  exit
end

@prefix = "public/stylesheets"
@output = "#{@prefix}/#{@name}"


def minify_file(f)
  css = ""
  puts "Minifying: #{f}"
  file = File.new("#{f}", "r")

  # parse each line into string
  while(line = file.gets)
    css += "#{line}".gsub(/\n/," ")
  end

  # remove comments (single and multiline)
  css.gsub!(/\/\*.*?\*\//m," ")

  # remove tabs (before spaces because I am replacing tabs with spaces)
  css.gsub!(/\t/," ")

  # remove repeating spaces 
  css.gsub!(/ +/," ")

  # remove "; "
  css.gsub!(/; /, ";")

  # remove "{ " and " }"
  css.gsub!(/\{ /,"{")
  css.gsub!(/ \}/,"}")
  
  # remove ", "
  css.gsub!(/, /, ",")
  
  # close
  file.close

  return css
end

def write_css(css)
  file = File.new(@output, "a")
  file.puts css
  file.close
end

def start
  for f in Dir["#{@prefix}/*.css"]
    css = minify_file(f)
    write_css(css)
  end
end


start

puts "Finished: #{@name}"


