# CukeExt Gem

***

# Reqs

* Requires javaruntime on mac, but running the tests will provide the prompt to install. You can also install it as described here: http://rics.partners.org/show_article.php?id=245
* Requires memcached to be running

***

# Running Tests

Before running tests, make sure you have memcached (maybe use homebrew: [http://www.google.com/search?q=brew+install+memcached](http://www.google.com/search?q=brew+install+memcached)) installed and running, or you will run into this issue: [https://github.com/Nerian/akephalos2/issues/29](https://github.com/Nerian/akephalos2/issues/29)

### Autotest (preferred)

from the command line:

1. `export AUTOFEATURE=true` only once to set the env variable
2. `autotest` (from the app dir) to run the start running all the tests
3. press `control + c` once to rerun all tests again
4. press `control + c` twice to stop

notes:

* at first autotest will run all tests, then only the failing tests
* after after all failing tests are passing auto test will run all the tests
* more info here: https://github.com/cucumber/cucumber/wiki/Autotest-Integration

### Running All tests

`cucumber` (from the app dir)

### Running Individual Files

`cucumber FILENAME` (from the app dir)

***

# Writing Tests


wms_svc_listing has defined two custom 'steps':

### 1. Calling API with Path and Query-String
```
Given the following path and params:
  | path | YOUR_API_ENDPOINT_PATH | # required row
  | field_1 | value_1 | # optional row
  | field_2 | value_2 | # optional row
  | field_3 | | # optional row
```
the above will call your app with GET `/YOUR_API_ENDPOINT_PATH?field_1=value_1&field_2=value_2&field_3=`, which is the same as:
```
Given the following path and params:
  | path | /YOUR_API_ENDPOINT_PATH?field_1=value_1&field_2=value_2&field_3= |
```

### 2-A. Parsing Response JSON with Hash Structure in External File
```
Then the response JSON should have the following:
  | file | YOUR_YAML_OR_JSON_FILE | # required row; place files in 'features/files'
  | JSON_SPEC_PATH | VALUE_OR_TYPE | # optional row
```
* place a hash structure as a `YAML` or `JSON` file in `features/files` then specify the filename for `YOUR_YAML_OR_JSON_FILE` (do not include path) 
* by default using `file` in the first cell will only assert keys (in the response JSON) regardless if a value is specified in the hash structure (in `YOUR_YAML_OR_JSON_FILE`)
* using `file val` in the first cell will assert keys and assert equal on the values (both in response JSON) using the keys value pairs in `YOUR_YAML_OR_JSON_FILE`:
```
Then the response JSON should have the following:
  | file val | YOUR_YAML_OR_JSON_FILE | # required row; place files in 'features/files'
  | JSON_SPEC_PATH | VALUE_OR_TYPE | # optional row
```
* `JSON_SPEC_PATH` description of 'paths' from http://rubygems.org/gems/json_spec :

> Each of json_spec's matchers deal with JSON "paths." These are simple strings of "/" separated hash keys and array indexes. For instance, with the following JSON:
```
{
  "first_name": "Steve",
  "last_name": "Richert",
  "friends": [
    {
      "first_name": "Catie",
      "last_name": "Richert"
    }
  ]
}
```
> We could access the first friend's first name with the path "friends/0/first_name".

* `VALUE_OR_TYPE` use the actual value (assert_equal) or the matchers for type, for example:
```
status: success        # => RESPONSE_HASH['status'] == 'success'
status: be a string    # => RESPONSE_HASH['status'].is_a?(String)
status: not be a hash  # => !RESPONSE_HASH['status'].is_a?(Hash)
```

### 2-B. Parsing Response JSON with Inline Table
```
Then the response JSON should have the following:
  | JSON_SPEC_PATH_1 | VALUE_OR_TYPE | # required row
  | JSON_SPEC_PATH_2 | VALUE_OR_TYPE | # optional row
  | JSON_SPEC_PATH_2 | VALUE_OR_TYPE | # optional row
```

## Example

in `features/search.feature`:

```
Scenario: search API bounds (success)
  Given the following path and params:
    | path | /search |
    | bounds_north | 47.85676114359615 |
    | bounds_south | 47.79948386508142 |
    | bounds_east | -122.23118118200682 |
    | bounds_west | -122.37280181799315 |
    | pgsize | 1 |
  And the response JSON should have the following: 
    | file | search_listing.json |
    | status | "success" |
    | data | be a hash |
    | data/result_list | be an Array |
    | data/result_list | have 1 entry |
    | data/result_geo/0/geojson/coordinates/0/0/0/0 | -122.37280181799315 |
    | data/result_geo/0/geojson/coordinates/0/0/0/0 | be a float |
``` 

***

## Additional Info
* Autotest: https://github.com/seattlerb/autotest-rails
* Cucumber: https://github.com/cucumber/cucumber
* JsonSpec: https://github.com/collectiveidea/json_spec
* Akephalos (for headless test driver): https://github.com/awesome/akephalos2
