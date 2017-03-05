class CreateWebinars < ActiveRecord::Migration
  def change
    create_table :webinars do |t|
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Webinar.create_translation_table! name: :string
        w = Webinar.new name: 'Forex Arbitrage. Truth and Fiction.', locale: :en
        w.attributes = {name: 'Арбитраж на форекс. Правда и вымысел.', locale: :ru}
        w.save

        w = Webinar.new name: 'Pair trading. Trading Strategy Building.', locale: :en
        w.attributes = {name: 'Парный трейдинг. Построение торговой системы.', locale: :ru}
        w.save

        w = Webinar.new name: 'Binary options arbitrage.', locale: :en
        w.attributes = {name: 'Арбитраж бинарных опционов.', locale: :ru}
        w.save
      end

      dir.down do
        Webinar.drop_translation_table!
      end
    end
  end
end
