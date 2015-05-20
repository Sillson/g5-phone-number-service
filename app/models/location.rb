class Location < ActiveRecord::Base
  validates :urn, :name, :default_number, presence: true
  validates :urn, uniqueness: true
  validates_format_of :urn, with: /g5-cl-[A-Za-z0-9]{7,8}-[A-Za-z0-9\-]+/

  belongs_to :client
end
