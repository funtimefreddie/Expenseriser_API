class UsersController < ApplicationController 


  def welcome
  end

  def expense_stats

    #check logged in with devise
    if current_user
      @start_date = Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      @end_date = Date.civil(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
     
      @expenses  = Expense.where("date between '#{@start_date}' and '#{@end_date}'").group("category").count
      @total = 0
      @expenses.each_value do |exp|
          @total += exp
      end

      @stats = Hash.new
      @expenses.each do |key,value|
          # show % of total expenses
          @stats[key] = (value.to_f/@total.to_f).to_f * 100
      end
      render  :action => "welcome"
      
    else
      return render json: { message: "Invalid Token", status: 400}, status: 400
    end
  end

end
