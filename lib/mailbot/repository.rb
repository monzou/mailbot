module Mailbot
  class Repository

    def initialize(path)
      @path = path
    end

    def sync
      write(entries.map do |entry|
        if entry.synced?
          entry
        else
          begin
            Mailbot::Mailer.deliver subject: entry.subject, body: entry.markdown
            entry.sync
          rescue => e
            p e
            entry
          end
        end
      end.map(&:data).join("\n"))
    end

    private

    def write(data)
      open(@path, "w:UTF-8").write data
    end

    def read
      open(@path, "r:UTF-8").read
    end

    def entries
      Mailbot::Entries.from read
    end

  end
end