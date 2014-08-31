module Mailbot
  module Commands
    class Sync < Base

      DEFAULT_MARKDOWN_FILE = "index.md"
      DEFAULT_ENV_FILE = ".env"

      # @param argv [Array] ARGV
      def initialize(argv)
        @argv = argv
      end

      # Sync the specified file to Mailbox
      def execute
        load_env!
        Mailbot::Repository.new(file).sync
      end

      private

      def load_env!
        Dotenv.load! env
      end

      def file
        options[:file] || DEFAULT_MARKDOWN_FILE
      end

      def env
        options[:env] || DEFAULT_ENV_FILE
      end

      def options
        @options ||= Slop.parse!(@argv, help: true) do
          banner "Usage: #{$0} sync [options]"
          on "file=", "Path to the markdown file to sync"
          on "env=", "Path to the env file to sync"
        end
      end

    end
  end
end