class Expense < ActiveRecord::Base
  belongs_to :user

  scope :after_date, -> (date) {where('date >= ?', date)}
  scope :before_date, -> (date) {where('date <= ?', date)}
  scope :category, -> (category) {where(:category => category)}
  scope :user, -> (user) {where(:user_id => user)}
  
end
