# frozen_string_literal: true

require 'spec_helper'
require 'lib/coolpay'

RSpec.describe Coolpay do
  let(:stdout) { instance_spy(IO, puts: nil) }
  let(:stderr) { instance_spy(IO, puts: nil) }

  describe '#call' do
    context 'when logging in' do
      subject(:login) { described_class.new(command, stdout, stderr).call }

      context 'when no params are provided' do
        let(:command) { ['login'] }

        specify do
          expect(login).to eq(1)
          expect(stderr).to have_received(:puts).with('Please provide username and apikey')
        end
      end

      context 'when only apikey is provided' do
        let(:command) { %w[login --apikey=some_apikey] }

        it 'raises an error' do
          expect(login).to eq(1)
          expect(stderr).to have_received(:puts).with('Please provide username and apikey')
        end
      end

      context 'when only username is provided' do
        let(:command) { %w[login --username=some_username] }

        it 'raises an error' do
          expect(login).to eq(1)
          expect(stderr).to have_received(:puts).with('Please provide username and apikey')
        end
      end

      context 'when all params are provided' do
        before do
          response = Typhoeus::Response.new(code: 200, body: '{"token": "definitively_not_a_token"}')
          Typhoeus.stub(LOGIN_URL).and_return(response)
        end

        let(:command) { %w[login --username=some_username --apikey=some_apikey] }

        it 'notifies the user about the success' do
          login

          expect(stdout).to have_received(:puts).with('You have been successful signed in')
        end

        it 'returns successful exit code' do
          expect(login).to eq(0)
        end

        it 'creates a credentials file' do
          login

          expect(File.read(CREDENTIALS_CACHE_PATH)).to include('definitively_not_a_token')
        end
      end
    end
  end
end
