class Project < ActiveRecord::Base
  validates :name, length: {minimum: 5}, uniqueness: true
  validates :description, length: {minimum: 200}
  validates :goal, presence: true

  def exp_date_calculator(days)
    (Time.now + (days*24*60*60)).strftime("%Y-%m-%d %H:%M:%S")
  end
end
