class CreateTesters < ActiveRecord::Migration
    def change
        create_table :testers do |t|
            t.string :name
            t.string :email
            t.text   :visits, array: true, default: []
            t.timestamps null: false
        end
    end
end
