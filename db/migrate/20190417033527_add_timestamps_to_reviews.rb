class AddTimestampsToReviews < ActiveRecord::Migration[5.1]
  def change
    add_timestamps(:reviews)
  end
end
