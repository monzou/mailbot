module Mailbot
  module Commands
    class Sync < Base

      def initialize(argv)
        @argv = argv
      end

      def execute
        Mailbot::Repository.new(file).sync
      end

      def file
        options[:file]
      end

      private

      def options
        @options ||= Slop.parse!(@argv, help: true) do
          banner "Usage: #{$0} sync [options]"
          on "file=", "Path to the markdown file to sync"
        end
      end

    end
  end
end