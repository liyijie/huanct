class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :member
      t.string :name
      t.integer :gongxian
      t.integer :dianping
      t.integer :qiandao
      t.string :reg_time
      t.string :last_time

      t.timestamps
    end
  end
end
