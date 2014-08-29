module Mailbot
  module Errors

    class Base < StandardError
    end

    class CommandNotFound < Base

    class CommandPreconditionError < Base
    end

  end
end
