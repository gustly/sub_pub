module SubPub
  class Railtie < Rails::Railtie
    initializer "pub sub configuration of active record extensions" do
      class ::ActiveRecord::Base
        include SubPub::ActiveRecordExtensions
      end

      config.after_initialize do
        Dir[
          File.expand_path("app/sub_pubs/*.rb", Rails.root)
        ].each { |file| require file }
      end
    end
  end
end
