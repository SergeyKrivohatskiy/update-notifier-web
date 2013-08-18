class Tag
  include ActiveRecord::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :id, :user_id, :name

  validates :name, presence: true

  def initialize(args = {})
    args.each_pair do |key, value|
      update_attribute(key, value)
    end
  end

  def update_attribute(key, value)
    #begin
    send "#{key}=", value
    #rescue NoMethodError => e
    #  p e
    #end
  end

  def new_record?
    @new_record
  end

end