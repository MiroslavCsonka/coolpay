# frozen_string_literal: true

class CoolPay
  class << self
    def call(argv)
      "Hello, World! #{argv.inspect}"
    end
  end
end
