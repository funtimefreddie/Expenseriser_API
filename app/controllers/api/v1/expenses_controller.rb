class Api::V1::ExpensesController < Api::V1::ApiController

  before_action :authenticate

  def index  

    if authenticate    

        start_date = params[:start_date].respond_to?(:to_date) ? params[:start_date].to_date : @user.expenses.min_by(&:date).date
        end_date = params[:end_date].respond_to?(:to_date) ? params[:end_date].to_date : @user.expenses.max_by(&:date).date
        @expenses = @user.expenses_between_dates(start_date, end_date) 

    else

      render json: { message: "Invalid token"}, status: 401


    end  

  end

end
