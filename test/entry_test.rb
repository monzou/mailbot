require "test_helper"

class EntryTest < Minitest::Unit::TestCase

  def setup
    @subject = Mailbot::Entry::Parser.new
  end

  def test_parse
    entries = @subject.parse <<-"EOS"
# Entry 1

## Entry 1 Sub Header

- foo
- bar

```ruby
puts "foo"
```

# ✓ Entry 2

## Entry 2 Sub Header

- foo
- bar
    EOS
    
    assert_equal 2,         entries.size

    entry1 = entries[0]
    assert_equal false,     entry1.synced?
    assert_equal "Entry 1", entry1.subject
    assert_equal false,     entry1.render_body.include?("<h1>")
    assert_equal true,      entry1.render_body.include?("<h2>")
    assert_equal true,      entry1.render_body.include?("<ul>")
    assert_equal true,      entry1.render_body.include?("<div class=\"CodeRay\">")

    entry2 = entries[1]
    assert_equal true,      entry2.synced?
    assert_equal "Entry 2", entry2.subject
    assert_equal false,     entry2.render_body.include?("<h1>")
    assert_equal true,      entry2.render_body.include?("<h2>")
    assert_equal true,      entry2.render_body.include?("<ul>")
    assert_equal false,     entry2.render_body.include?("<div class=\"CodeRay\">")

  end

end