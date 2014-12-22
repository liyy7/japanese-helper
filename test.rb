#!/usr/bin/env ruby
# encoding: UTF-8

require 'bundler/setup'

require 'rjb'
require 'romankana'

module JavaIterator
  def each
    i = self.iterator
    while i.has_next
      yield i.next
    end
  end
end

Dir['lib/*'].each {|f| Rjb::load File.absolute_path(f)}

Tokenizer = Rjb::import 'org.atilika.kuromoji.Tokenizer'

@tknizer = Tokenizer.builder.build

def tokenize sentence
  ret = ''

  begin
    list = @tknizer.tokenize sentence
    list.extend JavaIterator
    list.each do |x|
      ret += RomanKana.kanaroman x.reading
    end
  rescue
    STDERR.puts "wrong: #{sentence}"
  end

  ret.empty? ? sentence : ret.capitalize
end

require 'csv'

puts CSV.read('data.csv').each_with_index.map {|row, i|
  # skip title row
  if i == 0
    row.join(',')
  else
    row.map {|col|
      case col
      when String then (col.size == 0 || col == '0' || col.to_i > 0 ? col : "#{col} (#{tokenize(col)})")
      else col
      end
    }.join(',')
  end
}.join("\n")
