class AddForeignKeyToCoupon < ActiveRecord::Migration[5.1]
  def change
    add_reference :coupons, :user, foreign_key: true

  end
end
