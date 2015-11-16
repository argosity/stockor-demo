require 'skr'
require_relative 'demo_data/model_collection'
require_relative 'demo_data/gl_accounts'
require_relative 'demo_data/terms'
# require_relative 'demo_data/payment_processor'
# require_relative 'demo_data/shipping_setting'
require_relative 'demo_data/locations'
require_relative 'demo_data/vendors'
require_relative 'demo_data/customers'
require_relative 'demo_data/skus'
require_relative 'demo_data/customer_projects'
require_relative 'demo_data/time_entries'

# require_relative 'demo_data/item_categories'
# require_relative 'demo_data/items'
# require_relative 'demo_data/purchase_orders'
# require_relative 'demo_data/inventory_adjustments'
# require_relative 'demo_data/sales_orders'
# require_relative 'stockor_client'
require 'active_support/core_ext/module/attribute_accessors'
require 'faker'
require 'hashie'

module StockorDemo
    module DemoData

        UOMS = [['PALLET',1000],['CASE',100],['BOX',20],['EA',1]].map{|code,size| Hashie::Mash.new(code:code,number:size)}

        (FI, FA, FP, FC, FN, FS, FL, FCD) = [
          Faker::Internet, Faker::Address, Faker::PhoneNumber, Faker::Company,
          Faker::Name,  Faker::Commerce, Faker::Lorem, Faker::Code
        ]

        def self.make_address( name = FN.name )
            Skr::Address.new({   :name=>name, :email=>FI.email, :phone=>FP.phone_number,
              :line1=>FA.street_address, :city=>FA.city, :state=>FA.state_abbr, :postal_code=>FA.zip_code })
        end

        mattr_accessor :terms, :payment_processor, :shipping_setting, :locations, :vendors,
                       :skus, :projects, :item_categories, :items, :purchase_orders, :customers,
                       :sales_orders, :adjustment, :time_entries

        def self.log( str, *args )
            STDOUT.puts str % args
        end

        def self.run
            Kernel.srand()
            Lanes::DB.establish_connection
            ActiveRecord::Base.transaction do

                self.terms             = Terms.new
                self.locations         = Locations.new( 3 )
                self.customers         = Customers.new( 15 )
                self.vendors           = Vendors.new( 12 )
                self.skus              = Skus.new( 35 )
                self.projects          = CustomerProjects.new( 15 )
                self.time_entries      = TimeEntries.new( 30 )

                # self.payment_processor = PaymentProcessor.new
                # self.shipping_setting  = ShippingSetting.new
                # self.vendors           = Vendors.new( 120 )

                # self.customers         = Customers.new( 220 )
                # self.purchase_orders   = PurchaseOrders.new
                # self.sales_orders      = SalesOrders.new( 200 )
                # self.item_categories   = ItemCategories.new( 6 )
                # self.items             = Items.new( 90 )
                # self.adjustment        = InventoryAdjustments.new

            end
        end

    end # DemoData
end # StockorDemo
