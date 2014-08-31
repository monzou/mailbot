module Mailbot

  class Repository

    # @param path [String] The path to the text file to sync
    def initialize(path)
      @path = path
    end

    def sync
      write(entries.map do |entry|
        if entry.synced?
          entry
        else
          begin
            Mailbot::Mailer.deliver subject: entry.subject, body: entry.render_body
            Mailbot::LOGGER.info "Succeeded to sync an entry: #{entry.subject}"
            entry.sync
          rescue => e
            Mailbot::LOGGER.warn "Failed to sync an entry: #{entry.subject}\n#{e.backtrace.join("\n")}"
            entry
          end
        end
      end.map(&:text).join("\n"))
    end

    # @return [Array<Mailbot::Entry>] An array of all entries in this repository
    def entries
      Mailbot::Entry::Parser.new.parse read
    end

    private

    def write(text)
      open(@path, "w:UTF-8").write text
    end

    def read
      open(@path, "r:UTF-8").read
    end

  end

end