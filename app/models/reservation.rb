class Reservation < ActiveRecord::Base
  belongs_to :order
  belongs_to :rental

  #validates_numericality_of :travellers, greater_than: 0, allow_blank: true
end
