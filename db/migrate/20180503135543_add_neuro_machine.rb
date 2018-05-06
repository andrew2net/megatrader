class AddNeuroMachine < ActiveRecord::Migration
  def change
    Product.find_or_create_by name: 'NeuroMachine'
  end
end
