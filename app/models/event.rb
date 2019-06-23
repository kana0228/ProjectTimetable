class Event < ApplicationRecord
  #belongs_to :category_id, class_name:'Category'
  #timetableの情報が格納されます。
  has_one :category
  belongs_to :user
end
