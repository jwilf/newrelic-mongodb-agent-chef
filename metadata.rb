name             "newrelic_mongodb_agent"
maintainer       "James Wilford"
maintainer_email "james.wilford@gmail.com"
license          "Apache 2"
description      "Installs newrelic-mongodb-agent from MongoHQ and configures runit service"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"
%w(rvm application_ruby runit).each do |cookbook|
  depends cookbook
end