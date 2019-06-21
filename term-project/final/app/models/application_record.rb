class ApplicationRecord < ActiveRecord::Base
  @@users_directoryID = AnonJournal::Application.config.users_directoryID
  @@article_summaries_directoryID = AnonJournal::Application.config.article_summaries_directoryID
  @@deepq_client = DeepqClient.new

  self.abstract_class = true
end
