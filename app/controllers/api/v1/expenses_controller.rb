class Api::V1::ExpensesController < Api::V1::ApiController

  before_action :authenticate

  def index  

  byebug  
    

    if @test
      # they have submitted the right key
      if defined? params[:date]
        #they want a specific date
        
        date = params[:date].to_date
        @expenses = @user.expenses.where(date: date)

      else
        #they want everything
        @expenses = @user.expenses
      end

    else 
      # they have submitted an incorrect key
      render json: {message: 'Invalid API Token'}, status: 401
    end

  end

end
