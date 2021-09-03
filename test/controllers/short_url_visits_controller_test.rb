require "test_helper"

class ShortUrlVisitsControllerTest < ActionDispatch::IntegrationTest

  test "should get accurate statistics" do
    # create a short link
    post "/urls", params: { url: { long_url: "https://verylongurl.com/sjjsgjsgsgsgj", custom_back_half: nil } }
    assert_response :success

    back_half = JSON.parse(@response.body)['short_url'].split('/').last

    # make a couple of requests to that link
    get "/#{back_half}"
    get "/#{back_half}"

    # get the data on that link
    get "/stats/#{back_half}"
    
    body = JSON.parse(@response.body)
    
    assert_equal 2, body['visited_today']
    assert_equal 2, body['visited_total']
  end

end
