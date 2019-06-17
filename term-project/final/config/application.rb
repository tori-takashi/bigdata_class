require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AnonJournal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.paths.add 'lib', eager_load: true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    require_relative "../lib/deepq_client"
    deepq_client = DeepqClient.new

    config_file_path = __dir__ + "/../server_directoryID"
    config.server_info_directoryID = ""

    if File.exist?(config_file_path)
      puts "loading settings file..."
      server_info_directoryID = File.read(config_file_path).chomp

      puts "receiving users and article list directoryID..."

      users_result             = deepq_client.get_data_entry_by_data_certificate(server_info_directoryID,\
        "users_directoryID")
      article_summaries_result = deepq_client.get_data_entry_by_data_certificate(server_info_directoryID,\
        "article_summaries_directoryID")

      puts "setting directoryIDs..."
      config.users_directoryID             = users_result["dataDescription"]
      config.article_summaries_directoryID = article_summaries_result["dataDescription"]
    else
      server_password = ""

      puts "***** Initialize environment *****"
      puts "type new server password here."
      server_password = gets.chomp

      puts "\n"
      puts "creating essential directory IDs now..."
      puts "creating users_directoryID..."
      users_directoryID             = deepq_client.create_directory
      puts "creating summaries_directoryID..."
      article_summaries_directoryID = deepq_client.create_directory
      puts "creating server_info_directoryID..."
      server_info_directoryID       = deepq_client.create_directory
      puts "done\n"
      
      puts "establishing the relationship..."
      deepq_client.create_user(server_info_directoryID, "provider", server_info_directoryID, server_password)

      deepq_client.create_data_entry(server_info_directoryID, server_info_directoryID,\
        server_password, "0", "0", "users_directoryID", users_directoryID, users_directoryID, "AnonJournal")
      deepq_client.create_data_entry(server_info_directoryID, server_info_directoryID,\
        server_password, "0", "0", "article_summaries_directoryID", article_summaries_directoryID,\
        article_summaries_directoryID, "AnonJournal")
      
      puts "creating the config file #{config_file_path} ..."
      File.open(config_file_path, "w") do |file|
        file.puts server_info_directoryID
      end

      puts "applying the configurations..."
      config.users_directoryID             = users_directoryID
      config.article_summaries_directoryID = article_summaries_directoryID
    end

    puts "***** initialize completed !!! *****"
    puts "starting server..."

  end
end
