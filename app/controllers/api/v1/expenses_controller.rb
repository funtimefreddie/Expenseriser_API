class Api::V1::ExpensesController < Api::V1::ApiController

  # authenticate user - check if we can find their token
  def auth_user
    token = request.headers["token"]
    @api_found = ApiKey.find_by_token(token)
    if @api_found
      @user = User.find(@api_found.user_id)
    else
      false
    end
  end


  # request to display expenses
  def index

    # authenticate request
    if auth_user

      # check user has data to show
      if Expense.user(@user).count ==0
        render json: { message: "You have no data - please submit date via a POST request" }, status: 401
      else

        # retrieve paramaters
        # set start and end date to data min/max if not provided        
        start_date = params[:start_date].respond_to?(:to_date) ? params[:start_date].to_date : Expense.user(@user).min_by(&:date).date
        end_date = params[:end_date].respond_to?(:to_date) ? params[:end_date].to_date : Expense.user(@user).max_by(&:date).date
        category = params[:category]

        # request category if provided (uses scopes defined in Expense model)
        if category == nil
          @expenses = Expense.user(@user).after_date(start_date).before_date(end_date)
        else
          @expenses = Expense.user(@user).after_date(start_date).before_date(end_date).category(category)
        end
      end

    else
      # request not authenticated
      return render json: { message: "Invalid Token", status: 400}, status: 400
    end
  end



  # request to provide / submit expenses
  def create

    # authenticate request
    if auth_user

      #check we have everything we need!
      if params[:date] && params[:amount] && params[:category] && valid_date? && valid_amount?
        @new_expense = Expense.create(category: params[:category], date: params[:date], amount: params[:amount], user_id: @user.id)
        render json: { message: "Good going! You made an expense for $#{params[:amount]}", object: @new_expense }, status: 200
      else
      # tell user what they haven't provided correctly
        whats_not_supplied(params)     
      end

    else
      # request not authenticated
      return render json: { message: "Invalid Token", status: 400}, status: 400
    end

  end
 
  private

  # check if date in the right format.  Note - dates stored as strings as testing using postman!
  def valid_date?
    !!(params[:date].match(/\d{4}-(0[1-9]|1[0-2])-\d{2}/)) && Date.parse(params[:date]) rescue false 
  end

  # check if amount is a valid number
  def valid_amount?
    Float(params[:amount]) rescue false
  end

  # give user message to inform them what data is missing from the request
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
  
  def expense_params
    params.require(:team).permit(:user_id, :date, :amount, :category)
  end

end
