class MerchantsFacade
  class << self
    def paginate(per_page: 20, page: 1)
      per_page = 20 if per_page == nil
      page = 1 if page == nil
      (Merchant.all.in_groups_of(per_page.to_i)[page.to_i - 1]).compact
    end

    def search(search_query)
      Merchant.where('name like ?', "%#{search_query}%").order('name ASC').first
    end

    def richest_merchants(number_returned)
      Merchant.richest_merchants(number_returned)
    end
  end
end
