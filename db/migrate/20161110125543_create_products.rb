class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name

      t.timestamps null: false
    end
    Product.create name: 'MegaTrader'
    Product.create name: 'MegaTrader (Quik)'
    Product.create name: 'MegaTrader (Forex)'
    Product.create name: 'MegaTrader (Complex)'
    Product.create name: 'MegaClicker'
  end
end
