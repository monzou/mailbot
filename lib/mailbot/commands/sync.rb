module Mailbot
  module Commands
    class Sync < Base

      # @param argv [Array] ARGV
      def initialize(argv)
        @argv = argv
      end

      # Sync given file to Mailbox
      def execute
        load_env!
        Mailbot::Repository.new(file).sync
      end

      private

      def load_env!
        Dotenv.load! env
      end

      def file
        option = options[:file]
        raise Errors::CommandPreconditionError.new "option `file` must be specified" unless option
        option
      end

      def env
        options[:env] || ".env"
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