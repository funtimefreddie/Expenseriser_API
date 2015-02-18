class Api::V1::ExpensesController < Api::V1::ApiController

  before_action :authenticate

  def index  

    if authenticate    
        #byebug
        start_date = params[:start_date].respond_to?(:to_date) ? params[:start_date].to_date : @user.expenses.min_by(&:date).date
        end_date = params[:end_date].respond_to?(:to_date) ? params[:end_date].to_date : @user.expenses.max_by(&:date).date
        @expenses = @user.expenses_between_dates(start_date, end_date) 

    else

      render json: { message: "Invalid token"}, status: 401


    end  

  end

  def create
    @valid_date = valid_date?
    @valid_amount = valid_amount?
    #byebug
    # makes sure both a date and amount parameters are supplied
    if params[:date] && params[:amount] && @valid_date && @valid_amount# && Date.parse(params[:date]) rescue ArgumentError != ArgumentError
      
      Expense.create(date: params[:date], amount: params[:amount], user_id: @user.id)
      render json: { message: "Good going! You made an expense for $#{params[:amount]}"}, status: 200
    else
      whats_not_supplied(params)     
    end
  end

  private

  def valid_date?
    Date.parse(params[:date]) rescue false
  end

  def valid_amount?
    Float(params[:amount]) rescue false
  end

  def whats_not_supplied(params)
    if !params[:date]
        render json: { message: "You didn't supply a date. Expense not created"}
      elsif !params[:amount]
        render json: { message: "You didn't supply an amount. Expense not created"}
      elsif !@valid_date
        render json: { message: "Incorrect form for Date. YYYY-MM-DD"}
      else
        render json: { message: "Incorrect format for Amount. Be sure to check that your Amount does not contain any letters."}
      end
  end
  # def auth
  #   return authenticate
  # end



end
