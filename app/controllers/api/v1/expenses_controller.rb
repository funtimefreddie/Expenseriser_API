class Api::V1::ExpensesController < Api::V1::ApiController

  before_action :authenticate

  def index
    byebug
    
    @expenses = @user.expenses
  end

end
