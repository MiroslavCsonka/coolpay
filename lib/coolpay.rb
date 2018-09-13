# frozen_string_literal: true

require 'active_support/core_ext/string'
require 'gli'
require 'json'
require 'typhoeus'

BASE_URL = 'https://coolpay.herokuapp.com/api'
LOGIN_URL = BASE_URL + '/login'

PROJECT_ROOT = File.join(__dir__, '..')
CREDENTIALS_CACHE_PATH = PROJECT_ROOT + '/.coolpay_cache.json'

class Coolpay
  include GLI::App

  def initialize(argv, stdout, stderr)
    @argv = argv
    @stdout = stdout
    @stderr = stderr
  end

  # rubocop:disable Metrics/MethodLength
  def call
    program_desc 'A client for the Coolpay api to manage your money'

    command :login do |c|
      c.desc 'Log in in order to access the Coolpay application'
      c.flag %i[u username]
      c.flag %i[a apikey]

      c.action do |_global_options, options, _args|
        process_login(options[:apikey], options[:username])
      end
    end

    on_error do |exception|
      stderr.puts(exception.message)
      false
    end

    run(argv)
  end
  # rubocop:enable Metrics/MethodLength

  private

  # rubocop:disable Metrics/AbcSize
  def process_login(apikey, username)
    exit_now!('Please provide username and apikey') unless username.present? && apikey.present?

    response = Typhoeus.post(LOGIN_URL, body: { username: username, apikey: apikey })
    exit_now!("API returned: #{response.body}") unless response.success?

    File.write(CREDENTIALS_CACHE_PATH, { token: JSON.parse(response.body).slice('token') }.to_json)
    stdout.puts('You have been successful signed in')
  rescue JSON::ParserError => e
    exit_now!("Problem processing response from the API: #{e.message}")
  end
  # rubocop:enable Metrics/AbcSize

  attr_reader :argv, :stdout, :stderr
end
