class CukeExtGenerator < Rails::Generators::Base
  def self.source_root
    File.dirname(__FILE__)
  end

  desc "This creates the basic cucumber dir at 'features/', '.autotest', and the cucumber config at 'config/cucumber.yml'"
  def copy_reqs
    directory "features"
    copy_file ".autotest"
    copy_file "cucumber.yml", "config/cucumber.yml"
  end
end
