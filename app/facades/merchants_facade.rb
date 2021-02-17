class MerchantsFacade
  class << self
    def paginate(per_page: 20, page: 1)
      Merchant.all.in_groups_of(per_page)[page - 1]
    end


  end
end
