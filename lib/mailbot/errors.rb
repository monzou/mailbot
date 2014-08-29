module Mailbot
  module Errors

    class Base < StandardError
    end

    class CommandNotFoundError < Base
    end

    class CommandPreconditionError < Base
    end

  end
end
