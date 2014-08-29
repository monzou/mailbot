module Mailbot
  module Commands
    class Sync < Base

      # @param argv [Array] ARGV
      def initialize(argv)
        @argv = argv
      end

      # Sync given file to Mailbox
      def execute
        Mailbot::Repository.new(file).sync
      end

      private

      def file
        options[:file]
      end

      def options
        @options ||= Slop.parse!(@argv, help: true) do
          banner "Usage: #{$0} sync [options]"
          on "file=", "Path to the markdown file to sync"
        end
      end

    end
  end
end