class Demand < ActiveRecord::Base
  attr_accessible :host, :interface_id, :title

  has_one  :interface
  has_many :param

end
