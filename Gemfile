source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.0.3', '>= 6.0.3.3'

# basic
gem 'pg', '>= 0.18', '< 2.0' #db
gem 'puma', '~> 4.1' #server
gem 'bootsnap', '>= 1.4.2', require: false #cache optimization
 
#Auth
gem 'devise_token_auth', '~> 1.1.4' #api authentication

#CORS
gem 'rack-cors', '~> 1.1.1'

# styles
gem 'foundation-rails' #mail css
gem 'autoprefixer-rails' #add vendor prefixes
gem 'inky-rb', require: 'inky' #mail DSN design templates
gem 'premailer-rails' #provides inline css
gem 'sassc-rails', '~> 2.1', '>= 2.1.2' #add sass to rails

# api interface
gem 'jbuilder', '~> 2.10.1'


group :development, :test do
  gem 'pry'
  gem 'rubocop'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'shoulda-matchers', '~> 4.0'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]