Welcome to the RedPanda gem! This is a CLI tool packaged in the form of a rubygem to perform actions related to RedPanda, such as creating a new project from the template provided by RedPanda and customizing it to kickstart your iOS application in a blink.

## Installation (Waiting for v1.0 to be released)

    $ gem install redpanda

## Usage

Run RedPanda from the command line and answer a number of prompted questions to get started:

```
$ redpanda
1. create
2. exit
Actions:
1
Starting Project Creation Process
What project/application name should be used ?
demo
What bundle id should be used for the project ?
com.redpanda.demo
Creating new project with name: demo
...

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
