# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base

	has_and_belongs_to_many :items

  def recommended_items

    Item.find_by_sql("SELECT
        items.*
              FROM categories_items a
              INNER JOIN categories_items b
               ON a.category_id = b.category_id
        LEFT JOIN items ON items.id = b.item_id
        WHERE
          a.item_id IN (#{items.map(&:id).join(',')})
          AND b.item_id NOT IN (#{items.map(&:id).join(',')})
          AND items.id iS NOT NULL
        GROUP BY b.item_id
        ORDER BY COUNT(*)  DESC
  ")

  end

end
