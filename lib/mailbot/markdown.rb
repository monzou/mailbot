module Mailbot

  module Markdown

    BLOCK_SYMBOL = :mailbot_markdown_block

    class Renderer < Redcarpet::Render::HTML
      def block_code(code, language)
        CodeRay.scan(code, language.to_sym).div
      end
    end

    class << self

      def render(text)
        block.call text
      end

      def set(&block)
        Thread.current[BLOCK_SYMBOL] = block
      end

      def block
        Thread.current[BLOCK_SYMBOL] || default
      end

      def default
        require "mailgun"
        renderer = Renderer.new :filter_html => true, :hard_wrap => true
        markdown = Redcarpet::Markdown.new renderer, :autolink => true, :space_after_headers => true, :fenced_code_blocks => true
        ->(text) { markdown.render text }
      end

    end

  end

end