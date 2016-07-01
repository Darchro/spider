R5000Model::Configuration::DB.setup ActiveRecord::Base.configurations[Rails.env]
R5000Model::Configuration::Log.setup ActiveRecord::Base.logger

# include R5000Model
