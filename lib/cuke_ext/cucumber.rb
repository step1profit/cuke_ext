#
# authentication
#
Given /^user is logs in with username "(.*?)" and password "(.*?)"$/ do |username, password|

  # IMPORTANT! URL needs to be updated with config variable here!
  visit "http://example.com/login"

  page.fill_in "username", :with => username
  page.fill_in "password", :with => password
  page.click_button "login-submit"
  page.should have_content("You have successfully signed in.")
end

Then /^the user is logged in$/ do

  # IMPORTANT! URL needs to be updated with config variable here!
  visit "http://api.example.com/v1/users/current.json"

  page.source.should be_json_eql("true").at_path("success")
end

Then /^the user logs out$/ do

  # IMPORTANT! URL needs to be updated with config variable here!
  visit "http://example.com/logout"
end

Then /^the user is logged out$/ do

  # IMPORTANT! URL needs to be updated with config variable here!
  visit "http://api.example.com/v1/users/current.json"

  page.source.should be_json_eql("false").at_path("success")
end

#
#
#
Then /^the reponse status is (\d+)$/ do |status|
  page.response_code.should be(status.to_i)
end

Then /^the response body should be:/ do |str|
  page.body.should == str
end

Then /^the response body should match (.*)/ do |regexp|
  regexp.gsub!(/(^\/|\/$)/, "")
  page.body.should =~ /#{regexp}/
end

When /^(I|the user) gets? "([^"]*)"$/ do |_, path|
  visit path
end

#
#
#
Given /^the following path and params:$/ do |table|
  tr = table.raw

  # error unless key is "path"
  raise "does not specify \"path\" key" unless table.raw.first.first == "path"
  # error if val is nil and assign path var
  raise "does not specify \"path\" value" unless path = table.raw.first.last

  # remove first row
  tr.shift

  array = []
  tr.each {|k,v| array << "#{k}=#{v}"}

  puts path = "#{path}?#{array.join("&")}"
  visit path
end

Then /^the response JSON should have the following:$/ do |table|
  tr = table.raw

  # the first row/column == "file"
  if parse_file = tr.first.first =~ /^file(.*)$/i
    check_keys = true # => default true
    check_vals = (Regexp.last_match(1) =~ /val/i) ? true : false
    # make sure file is specified
    raise "no file specified" unless file_name = table.raw.first.last

    file_name = "#{File.dirname(__FILE__)}/../files/#{file_name}"

    # make sure file exists
    raise "file needs to be placed in \"features/files\" directory" unless File.exist? file_name

    # load file to hash
    case File.extname(file_name)
    when /jso?n/i
      hash = JSON.parse(IO.read(file_name))
    when /ya?ml/i
      hash = YAML.load_file(file_name)
    when // then raise "no extension on file_name"
    else; raise "invalid extension on file_name"
    end

    # convert hash to flat-hash
    fhash = CukeExt::FlatHash.flat_hash(hash)

    # check for each key in fhash to be in JSON
    #fhash.keys.each {|k| JsonSpec::Helpers.parse_json(last_json, k.join("/"))}
    case
    when check_keys && check_vals
      fhash.each do |k,v|
        path = k.join("/")
        puts path if @verbose
        if v =~ /(not\s)?be an? (.*)/
          if Regexp.last_match(1)
            last_json.should_not have_json_type(Regexp.last_match(2)).at_path(path)
          else
            last_json.should have_json_type(Regexp.last_match(2)).at_path(path)
          end
        else
          step %(the JSON should have "#{path}")
        end
      end
    when check_keys then fhash.keys.each {|k| puts k.join("/") if @verbose; step %(the JSON should have "#{k.join("/")}")}
    else; end

    # remove first row
    tr.shift
  end

  # use the first row to load addresses from yaml (only checking for keys NOT values)
  if tr.flatten.length > 0
    # use the table to check addresses and values
    tr.each do |path, value|
      if value
        case
        when value =~ /(not\s{1,})?be\s{1,}an?\s{1,}([^\s]*)/
          if Regexp.last_match(1)
            last_json.should_not have_json_type(Regexp.last_match(2)).at_path(path)
          else
            last_json.should have_json_type(Regexp.last_match(2)).at_path(path)
          end
        when value =~ /(not\s{1,})?ha(s|ve)\s{1,}(\d{1,})/
          if Regexp.last_match(1)
            last_json.should_not have_json_size(Regexp.last_match(3).to_i).at_path(path)
          else
            last_json.should have_json_size(Regexp.last_match(3).to_i).at_path(path)
          end
        else
          step %(the JSON at "#{path}" should be:), value
        end
      else
        step %(the JSON should have "#{path}")
      end
    end
  end
end
