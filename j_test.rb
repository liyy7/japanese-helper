#!/usr/bin/env ruby
# encoding: UTF-8

Dir['lib/*'].each {|f| require File.absolute_path(f)}

import 'org.atilika.kuromoji.Tokenizer'

@tknizer = Tokenizer.builder.build

def tokenize sentence
  list = @tknizer.tokenize sentence
  list.each do |x|
    puts "#{x.surface_form}: #{x.all_features}"
  end
end

str = '東京'

puts tokenize str
