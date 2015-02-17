class Api::V1::ExpensesController < Api::V1::ApiController
  def index
    @expenses = current_user.expenses
  end

end
