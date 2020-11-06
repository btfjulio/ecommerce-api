Shoulda::Matchers.configure do |config|
  config.integrate to |with|
    with.test_framework :rspec
    with.libray :rails
  end
end