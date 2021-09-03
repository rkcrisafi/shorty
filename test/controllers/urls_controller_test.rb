require "test_helper"

class UrlsControllerTest < ActionDispatch::IntegrationTest

  test "should create a basic short link" do
    post "/urls", params: { url: { long_url: "https://verylongurl.com/sjjsgjsgsgsgj", custom_back_half: nil } }
    assert_response :success
    short_url = JSON.parse(@response.body)['short_url']
    persisted_url = Url.last.short_url
    assert_equal short_url, persisted_url
  end

  test "should not create multiple short link for basic urls" do
    long_url = "https://verylongurl.com/sjjsgjsgsgsgj"
    post "/urls", params: { url: { long_url: long_url, custom_back_half: nil } }
    assert_response :success

    post "/urls", params: { url: { long_url: long_url, custom_back_half: nil } }
    assert_response :success

    assert_equal 1, Url.where(long_url: long_url).count

  end

  test "should create a custom short link" do
    custom_half = 'my_custom_link'
    post "/urls", params: { url: { long_url: "https://verylongurl.com/sjjsgjsgsgsgj", custom_back_half: custom_half } }
    assert_response :success
    short_url = JSON.parse(@response.body)['short_url']
    persisted_url = Url.last.short_url
    assert_equal short_url, persisted_url
    assert_equal short_url.split('/').last, custom_half
  end

  test "should create multiple custom links for the same long url" do
    long_url = "https://verylongurl.com/sjjsgjsgsgsgj"
    post "/urls", params: { url: { long_url: long_url, custom_back_half: "first_custom" } }
    assert_response :success

    post "/urls", params: { url: { long_url: long_url, custom_back_half: "second_custom" } }
    assert_response :success

    post "/urls", params: { url: { long_url: long_url, custom_back_half: 'third_custom' } }
    assert_response :success

    assert_equal 3, Url.where(long_url: long_url).count
  end

  test "should not create a duplicate custom short link" do
    custom_half = 'my_custom_link'

    post "/urls", params: { url: { long_url: "https://verylongurl.com/first-long-url", custom_back_half: custom_half } }
    assert_response :success

    post "/urls", params: { url: { long_url: "https://verylongurl.com/second-long-url", custom_back_half: custom_half } }
    assert_response :conflict

    assert_includes @response.body, "This URL has already been claimed for https://verylongurl.com/first-long-url"
  end

  test "should redirect short link to the original url" do
    long_url = "https://verylongurl.com/sjjsgjsgsgsgj"
    post "/urls", params: { url: { long_url: long_url, custom_back_half: nil } }
    assert_response :success
    back_half = JSON.parse(@response.body)['short_url'].split('/').last

    get "/#{back_half}"
    assert_response :redirect
    assert_equal long_url, @response.location
  end

  test "should not redirect non-exisiting short link" do
    get "/i-do-not-exist"
    assert_response :not_found
  end

end
