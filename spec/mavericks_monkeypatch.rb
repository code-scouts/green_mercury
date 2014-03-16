require 'capybara/poltergeist'
require 'phantomjs'

# drawn from https://gist.github.com/ericboehs/7125105

module Capybara::Poltergeist
  class Client
    private
    def redirect_stdout
      prev_out = STDOUT.dup
      prev_out.autoclose = false
      $stdout = @write_io
      STDOUT.reopen(@write_io)

      prev_err = STDERR.dup
      prev_err.autoclose = false
      $stderr = @write_io
      STDERR.reopen(@write_io)
      yield
    ensure
      STDOUT.reopen(prev_out)
      $stdout = STDOUT
      STDERR.reopen(prev_err)
      $stderr = STDERR
    end
  end
end

class WarningSuppressor
  class << self
    def write(message)
      if [/QFont::setPixelSize/, /CoreText/].any? {|err| message =~ err}
        0
      else
        puts(message)
        1
      end
    end
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
                                    phantomjs_logger: WarningSuppressor,
                                    phantomjs: Phantomjs.path)
end

Capybara.javascript_driver = :poltergeist
