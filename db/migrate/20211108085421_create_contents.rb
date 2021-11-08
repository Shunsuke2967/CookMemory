class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents do |t|
      t.string     :title
      t.string     :post_content
      t.string     :imgfile
      t.references :account, foreign_key: true
    end
  end
end
