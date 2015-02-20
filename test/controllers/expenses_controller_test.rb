require 'test_helper'
#  require 'app/controllers/api/v1/api_controller'

class Api::V1::ExpensesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "create method should properly perform" do
    @request.env['name'] = 'Fuckthatderp'
    @request.env['token'] = 'also Fuckthatderp'

    post :create, { category: 1, date: "2015-02-13", amount: 2000, user_id: 1}
    response = JSON.parse(@response.body)
    assert_response :success
  end

end
