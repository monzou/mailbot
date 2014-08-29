module Mailbot

  class Entry

    SYNC_MARK = "✓"
    HEADER_LINE_PATTERN = /^#\s+(#{SYNC_MARK}\s*)?(.+)$/

    attr_accessor :text

    # @param text [String] The raw text of this entry
    def initialize(text)
      @text = text
    end

    # @return [String] A subject of this entry
    def subject
      headers.reject { |header| header =~ /#{SYNC_MARK}/ }.first
    end

    # @return [String] An HTML representation of this entry
    def render_body
      Mailbot::Renderer.render @text.sub(HEADER_LINE_PATTERN, "")
    end

    # @return [Boolean] True if this entry is already synced to Mailbox
    def synced?
      headers.include? SYNC_MARK
    end

    # @return [Mailbot::Entry] A synced entry
    def sync
      Entry.new(@text.sub HEADER_LINE_PATTERN, "# #{SYNC_MARK} \\2")
    end

    # @note Overridden
    # @return [String] A String representation of this entry
    def to_s
      @text
    end

    class Parser

      def initialize
        @entries = []
        @buffer = ""
      end

      # @param text [String] The raw text to parse to entries
      # @return [Array<Mailbot::Entry>] An Array of parsed entries
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
      @text.scan(HEADER_LINE_PATTERN).flatten.compact.map(&:strip)
    end

  end

end