# SubPub

SubPub is a thin wrapper around ActiveSupport::Notifications, which provides an implementation of the Publish/Subscribe pattern.

http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html

The goal was to be able to create more loosly coupled models by pulling side effects of our models into their own class.  We wanted this behavior for Active Record classes as well as non-Active Record classes.

The result was a library that was:
* easy to test
* easy to disable (when using the console, during unit tests, etc.)
* easy to understand (b/c of AS::Notifications syncronous publishing queue)

## Installation

Add this line to your application's Gemfile:

    gem 'sub_pub'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sub_pub

## Usage

### Configuration

    SubPub.disable # disables publishing
    SubPub.enable  # enables publishing

    By default, SubPub looks for subscribers in app/models/pub_sub/* 


### Within a plain ruby project

    SubPub::Subscriber => provides an interface to subscribe to a topic

    #
    # Subscribe to the 'user_created' topic.
    #
    class SendWelcomeEmailToUser < SubPub::Subscriber
      subscribe_to("user_created")

      def on_publish
        write_user_to_file(options[:user])
      end

      private

      def write_user_to_file(user)
        File.open("/tmp/users.txt", "w+") do |file|
          file << user.name
        end
      end
    end


    #
    # Publish a message to the 'user_created' topic
    #
    SubPub.publish("user_created", user:
      User.new(name: 'John Doe')
    )


### Within a Rails project

    SubPub::ActiveRecord::Subscriber => provide an interface to subscribe to an ActiveRecord callback topic

    #
    # Subscribe to the after_create callback of User
    #
    # currently, SubPub loads all subscribers in app/models/pub_sub/*
    #
    class SendWelcomeEmailToUser < SubPub::ActiveRecord::Subscriber
      subscribe_to(User, 'after_create')

      def on_publish
        ApplicationMailer.send_welcome_email(record)
      end
    end
    => SubPub.subscribe("active_record::user::after_create")


    #
    #  inside your application (controller, model, etc)
    #
    User.create(name: 'John Doe')
    => SubPub.publish("active_record::user::after_create")


## Supported Active Record Callbacks

* before_create
* after_create
* after_commit


## Backlog / To Do

http://www.pivotaltracker.com/projects/705655

Feel free to take a look.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Contributors

* Brent Wheeldon
* Cathy O'Connell
* Nick Monje
* Evan Goodberry
* Ben Moss
* Chien Kuo
* Edwin Chong
* Adam Berlin
* Rasheed Abdul-Aziz
* Ryan McGarvey
* Geoffrey Ducharme
* Alex Kramer
