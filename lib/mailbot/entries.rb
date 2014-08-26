module Mailbot

  class Entries

    include Enumerable

    def self.from(data)
      entries = Entries.new
      data.strip.each_line { |line| entries.append line }
      entries.flush
      entries
    end

    def initialize
      @entries = []
      @buffer = ""
    end

    def each
      @entries.each { |entry| yield entry }
    end

    def append(line)
      if @buffer.empty?
        @buffer = line
      elsif line =~ Mailbot::Entry::HEADER_LINE_PATTERN
        @buffer = line if flush
      else
        @buffer << line
      end
    end

    def flush
      unless @buffer.empty?
        @entries << Mailbot::Entry.new("#{@buffer.strip}\n")
        true
      else
        false
      end
    end

  end
  
end