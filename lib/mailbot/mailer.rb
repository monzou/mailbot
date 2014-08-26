module Mailbot

  module Mailer

    BLOCK_SYMBOL = :mailbot_mailer_block

    class << self

      def deliver(subject: "", body: "")
        block.call subject, body
      end

      def set(&block)
        Thread.current[BLOCK_SYMBOL] = block
      end

      def block
        Thread.current[BLOCK_SYMBOL] || default
      end

      def default
        mailgun = Mailgun::Client.new ENV["MAILBOT_MAILGUN_API_KEY"]
        ->(subject, body) do
          params = {
            :from    => ENV["MAILBOT_MAIL_FROM"],
            :to      => ENV["MAILBOT_MAIL_TO"],
            :subject => subject,
            :html    => body
          }
          mailgun.send_message ENV["MAILBOT_MAILGUN_DOMAIN"], params
        end
      end

    end

  end

end