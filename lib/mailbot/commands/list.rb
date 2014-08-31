module Mailbot
  module Commands
    class List < Base

      DEFAULT_MARKDOWN_FILE = "index.md"

      # @param argv [Array] ARGV
      def initialize(argv)
        @argv = argv
      end

      # List all entries of the specified file
      def execute
        puts Mailbot::Repository.new(file).entries.map { |entry| colorized_subject entry }.map(&:strip).join("\n")
      end

      private

      def colorized_subject(entry)
        subject = entry.subject
        subject = "\033[32m#{subject}\033[0m" unless entry.synced?
        subject
      end

      def file
        options[:file] || DEFAULT_MARKDOWN_FILE
      end

      def options
        @options ||= Slop.parse!(@argv, help: true) do
          banner "Usage: #{$0} list [options]"
          on "file=", "Path to the markdown file to list"
        end
      end

    end
  end
end