Dir.glob(File.expand_path("../test/**/*.rb", __FILE__), &method(:require))

module ServiceRegistry
  module Test
  end
end
