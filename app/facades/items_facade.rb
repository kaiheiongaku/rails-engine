class ItemsFacade
  class << self
    def paginate(per_page: 20, page: 1)
      per_page = 20 if per_page == nil
      page = 1 if page == nil
      (Item.all.in_groups_of(per_page.to_i)[page.to_i - 1]).compact
    end

    def search(name, min, max)
      if name
        Item.where('name like ?', "%#{name}%").order('name ASC').to_a
      elsif min && max
        Item.where("unit_price > ?", min).where("unit_price < ?", max).to_a
      elsif min
        Item.where("unit_price > ?", min).to_a
      elsif max
        Item.where("unit_price < ?", max).to_a
      else
        nil
      end
    end
  end
end
