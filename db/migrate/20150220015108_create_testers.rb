class CreateTesters < ActiveRecord::Migration[4.2]
    def change
        create_table :testers do |t|
            t.string :name
            t.string :email
            t.text   :visits, array: true, default: []
            t.timestamps null: false
        end
    end
end
