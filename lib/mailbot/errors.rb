module Mailbot
  module Errors

    class Base < StandardError
    end

    class CommandNotFound < Base
    end

  end
end
