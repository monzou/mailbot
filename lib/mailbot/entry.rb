module Mailbot

  class Entry

    SYNC_MARK = "✓"
    HEADER_LINE_PATTERN = /^#\s+(#{SYNC_MARK}\s*)?(.+)$/

    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def subject
      headers.reject { |header| header =~ /#{SYNC_MARK}/ }.first
    end

    def render_body
      Mailbot::Renderer.render @data.sub(HEADER_LINE_PATTERN, "")
    end

    def synced?
      headers.include? SYNC_MARK
    end

    def sync
      Entry.new(@data.sub HEADER_LINE_PATTERN, "# #{SYNC_MARK} \\2")
    end

    def to_s
      @data
    end

    class Parser

      def initialize
        @entries = []
        @buffer = ""
      end

      def parse(text)
        text.strip.each_line do |line|
          if @buffer.empty?
            @buffer = line
          elsif line =~ HEADER_LINE_PATTERN
            @buffer = line if flush
          else
            @buffer << line
          end
        end
        flush
        @entries
      end

      private

      def flush
        unless @buffer.empty?
          @entries << Entry.new("#{@buffer.strip}\n")
          true
        else
          false
        end
      end

    end

    private

    def headers
      @data.scan(HEADER_LINE_PATTERN).flatten.compact.map(&:strip)
    end

  end

end