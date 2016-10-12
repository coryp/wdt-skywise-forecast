require 'test_helper'

class Wdt::Skywise::ForecastTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Wdt::Skywise::Forecast::VERSION
  end

  def test_client_should_be_of_right_type
    client = Wdt::Skywise::Forecast::Client.new
    assert_kind_of Wdt::Skywise::Forecast::Client, client
  end

  def test_class_config_should_be_settable
    app_id = "aajhjhd878"
    Wdt::Skywise::Forecast::Client.app_id = app_id
    assert_equal app_id, Wdt::Skywise::Forecast::Client.app_id

    app_key = "kljlksjdlksdsdsdsklkjsd87878"
    Wdt::Skywise::Forecast::Client.app_key = app_key
    assert_equal app_key, Wdt::Skywise::Forecast::Client.app_key

    format = "json"
    Wdt::Skywise::Forecast::Client.format = format
    assert_equal format, Wdt::Skywise::Forecast::Client.format

    units = "us"
    Wdt::Skywise::Forecast::Client.units = units
    assert_equal units, Wdt::Skywise::Forecast::Client.units
  end

  def test_base_url_should_be_valid
    assert_match /^http/, Wdt::Skywise::Forecast::Client.base_url
  end

  def test_unauthorized_response
    stub_request(:any, /#{Wdt::Skywise::Forecast::Client.base_url}/).to_return(status: 403)

    Wdt::Skywise::Forecast::Client.app_id="abcd"
    Wdt::Skywise::Forecast::Client.app_key="efghijklmnop"

    client = Wdt::Skywise::Forecast::Client.new
    response = client.search(ZIP: '32128')
    assert_equal false, response.success
    assert_equal "Not Authorized", response.error
    assert_nil response.response
  end

  def test_search
    stub_request(:any, /#{Wdt::Skywise::Forecast::Client.base_url}/).to_return(status: 200, body: "{}")

    Wdt::Skywise::Forecast::Client.app_id="abcd"
    Wdt::Skywise::Forecast::Client.app_key="efghijklmnop"

    client = Wdt::Skywise::Forecast::Client.new
    response = client.search(ZIP: '32128')
    assert_equal true, response.success
    assert_kind_of OpenStruct, response.response
    assert_nil response.error
  end

  def test_search_without_parameters
    stub_request(:any, /#{Wdt::Skywise::Forecast::Client.base_url}/).to_return(status: 200, body: "{}")
    client = Wdt::Skywise::Forecast::Client.new
    response = client.search({})
    assert_equal false, response.success
    assert_equal "No search parameters specified", response.error
    assert_nil response.response
  end

  def test_search_by_incomplete_lat_no_long
    stub_request(:any, /#{Wdt::Skywise::Forecast::Client.base_url}/).to_return(status: 200, body: "{}")
    client = Wdt::Skywise::Forecast::Client.new
    response = client.search(LAT: '32128')
    assert_equal false, response.success
    assert_equal "LONG must be provided with LAT", response.error
    assert_nil response.response
  end

  def test_search_by_incomplete_long_no_lat
    stub_request(:any, /#{Wdt::Skywise::Forecast::Client.base_url}/).to_return(status: 200, body: "{}")
    client = Wdt::Skywise::Forecast::Client.new
    response = client.search(LONG: '32128')
    assert_equal false, response.success
    assert_equal "LAT must be provided with LONG", response.error
    assert_nil response.response
  end

  def test_search_by_city_with_no_state_or_country
    stub_request(:any, /#{Wdt::Skywise::Forecast::Client.base_url}/).to_return(status: 200, body: "{}")
    client = Wdt::Skywise::Forecast::Client.new
    response = client.search(CITY: '32128')
    assert_equal false, response.success
    assert_equal "STATE or COUNTRY must be provided with CITY", response.error
    assert_nil response.response
  end

end
