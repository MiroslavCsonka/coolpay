# frozen_string_literal: true

require 'spec_helper'
require 'lib/coolpay'

RSpec.describe CoolPay do
  describe '#call' do
    it 'returns hello world' do
      expect(described_class.call(nil)).to eq('Hello, World! nil')
    end
  end
end
