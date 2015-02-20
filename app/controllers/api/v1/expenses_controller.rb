class Api::V1::ExpensesController < Api::V1::ApiController

  # before_action :authenticate

  def index
    if auth_user
      if Expense.user(@user).count ==0
        render json: { message: "You have no data - please submit date via a POST request" }, status: 401
      else
        
        start_date = params[:start_date].respond_to?(:to_date) ? params[:start_date].to_date : Expense.user(@user).min_by(&:date).date
        end_date = params[:end_date].respond_to?(:to_date) ? params[:end_date].to_date : Expense.user(@user).max_by(&:date).date
        category = params[:category]

        if category == nil
          @expenses = Expense.user(@user).after_date(start_date).before_date(end_date)
        else
          @expenses = Expense.user(@user).after_date(start_date).before_date(end_date).category(category)
        end
      end

    else
      return render json: { message: "Invalid Token", status: 400}, status: 400
    end
  end

  def auth_user
    token = request.headers["token"]
    @api_found = ApiKey.find_by_token(token)
    if @api_found
      @user = User.find(@api_found.user_id)
    else
      false
    end
  end

  def create

    token = request.headers["token"]
    # BROKEN IF API KEY IS NOT VALID.....
    @api_found = ApiKey.find_by_token(token)
    if @api_found
      @user = User.find(@api_found.user_id)
    else
      return render json: { message: "Invalid Token", status: 400}, status: 400
    end
    if !(token = request.headers["token"])
      return render json: { message: "Missing Token", status: 400}
    elsif !params[:amount]
      return render json: { message: "No Amount Amount Supplied", status: 400}
    elsif !params[:date]
      return render json: { message: "No Date Supplied", status: 400} 
    end
    # always pass the token through as a header request...
    


    
    #byebug
    if params[:date] && params[:amount] && params[:category] && valid_date? && valid_amount?
      @new_expense = Expense.create(category: params[:category], date: params[:date], amount: params[:amount], user_id: @user.id)
      render json: { message: "Good going! You made an expense for $#{params[:amount]}", object: @new_expense }, status: 200
    else
      whats_not_supplied(params)     
    end
  end
  # you know the hardest part about breaking up with a Japanese girl? You have to drop the bomb twice before she gets it

  private

  def valid_date?
    !!(params[:date].match(/\d{4}-(0[1-9]|1[0-2])-\d{2}/)) && Date.parse(params[:date]) rescue false 
  end

  def valid_amount?
    Float(params[:amount]) rescue false
  end

  def whats_not_supplied(params)
    if !params[:date]
      return render json: { message: "You didn't supply a date. Expense not created", status: 400}
      elsif !params[:amount]
        return render json: { message: "You didn't supply an amount. Expense not created", status: 400}
      elsif !params[:category]
        return render json: { message: "You didn't supply a category. Expense not created", status: 400}
      elsif !@valid_date
        return render json: { message: "Incorrect form for Date. YYYY-MM-DD", status: 400}
      else
        return render json: { message: "Incorrect format for Amount. Be sure to check that your Amount does not contain any letters.", status: 400}
      end
  end
  # def auth
  #   return authenticate
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:team).permit(:user_id, :date, :amount, :category)
    end



end
