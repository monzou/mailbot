module Mailbot

  class CommandFactory

    # @return [Mailbot::Commands::Base]
    def self.create(*args)
      new(*args).create
    end

    # @param argv [Array] ARGV
    def initialize(argv)
      @argv = argv
    end

    # @return [Mailbot::Commands::Base]
    def create
      command_class.new @argv
    rescue Errors::CommandNotFound
      terminate
    end

    private

    def command_class
      case command_name
      when "sync"
        Commands::Sync
      else
        raise Errors::CommandNotFound
      end
    end

    def command_name
      @argv[0]
    end

    def usage
      "Usage: #{$0} <command> [options]"
    end

    def terminate
      warn usage
      exit 1
    end

  end

end