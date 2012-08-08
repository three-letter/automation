class Demand < ActiveRecord::Base
  attr_accessible :host, :interface_id, :title
  validates_presence_of :host, :title
end
