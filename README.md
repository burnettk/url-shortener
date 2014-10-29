# URL Shortener

This is some code for a web application that you can deploy to the internet, or, more likely, your company's intranet, so people can create shortcuts for urls they use frequently, and make them available to others.

You might think of it as a cross between [bit.ly](http://bit.ly) (a popular hosted url shortener) and [Firefox keywords](http://support.mozilla.com/en-US/kb/Smart%20keywords) (which allow you to use %s substitutions).

Once you add shortcuts, you--and everyone else with access to the site--will be able to get to them.

If this isn't exactly what you're looking for, others have done similar things, so [take a look around](https://www.google.com/search?q=open+source+url+shortener).

## Installation

### Rails

It's a Ruby on Rails app. Check out the [.ruby-version file](.ruby-version) for the currently-supported version of ruby and the [Gemfile.lock file](Gemfile.lock) for the version of Rails, if that might be a dealbreaker for your environment.

[Follow this](http://railsapps.github.io/installrubyonrails-mac.html) or a similar walkthrough to get ready to run a Rails app and MySQL on a mac.

### Authentication

You will need a working [Central Authentication Service (CAS)](http://en.wikipedia.org/wiki/Central_Authentication_Service) available to use the code as written. You could also update the code to handle any authentication system you wanted. If you write some nice generalized code, or incorporate [devise](https://github.com/plataformatec/devise) or something, please do send a pull request.

### Then do this to set up a development environment:

 * `git clone https://github.com/burnettk/url-shortener.git`
 * `cd url-shortener`
 * `ruby -v` # if this reports anything other than that listed in the [.ruby-version file](.ruby-version), use rvm or rbenv to install the correct version
 * `bundle`
 * `cp config/config.defaults.yml config/config.yml`
 * Take a look at config/config.yml to get an idea what it does. You can change the values in there to suit your fancy.
 * `cp config/cas.defaults.yml config/cas.yml`
 * Update config/cas.yml so the URL Shortener application will be able to talk to your CAS instance.
 * Look in config/database.yml and make sure the configuration in the development stanza is compatible with your local MySQL database (particularly database, username, and password inside the development stanza). The user in question will need permissions to create databases for the next step.
 * `bundle exec rake db:setup`
 * `bundle exec rails server`

 The configs I use when running `bundle exec cap deploy` to deploy the app onto an ubuntu box running passenger are found in config/deploy.rb. Instructions for setting up a production-like deployment environment are beyond the scope of this document, but [google it](https://www.google.com/search?q=deploy+rails+app) or [check out the docs on the Rails site](http://rubyonrails.org/deploy).
