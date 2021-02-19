class MerchantRevenuesSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  attribute :total_revenue do |object|
    object.find_revenue(object.id)
  end
end
