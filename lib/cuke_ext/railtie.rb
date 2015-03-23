module CukeExt
  class Railtie < Rails::Railtie
    rake_tasks do
      load "#{File.dirname(__FILE__)}/tasks/cuke_ext.rake"
    end

    generators do
      load "#{File.dirname(__FILE__)}/generators/cuke_ext_generator.rb"
    end
  end
end
