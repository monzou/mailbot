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

    def markdown
      Mailbot::Markdown.render @data.sub(HEADER_LINE_PATTERN, "")
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

    private

    def headers
      @data.scan(HEADER_LINE_PATTERN).flatten.compact.map(&:strip)
    end

  end

end