Whisk
=====

Whisk is a simple cookbook manager for Chef, inspired by librarian and
berkshelf.

Unlike these tools, Whisk only concerns itself with fetching and preparing
exactly what you tell it, and will not resolve dependencies for you or make any
decisions about which code gets downloaded for you.

Whisk has been designed to work with git only and tries to help automating
the more tedious aspects of working with the 'single git repository per
cookbook' model.

# Configuration #

Whisk will prepare one or multiple 'bowls' of cookbooks as specified in your
Whiskfile.

## Example Whiskfile ##

    whisk_dir = "#{ENV['HOME']}/whisk"
    github = "git://github.com/opscode-cookbooks/%s.git"

    bowl "testing" do
      path File.join(whisk_dir, "testing")
      ingredient 'openssh' do
        source github % 'openssh'
      end

      ingredient 'ntp' do
        source github % 'ntp'
      end
    end

    bowl "production" do
      path File.join(whisk_dir, "production")
      ingredient 'openssh' do
        source github % 'openssh'
        ref '1.0.0'
      end
    end

# Commands #

##  whisk list ##

The list subcommand will list the short name of all of the configured
ingredients. This short name consists of the bowl and ingredient names
separated by a forward slash. These short names maybe be used as filters for
most other subcommands

    $ whisk list
    testing/openssh
    testing/ntp
    production/openssh

##  whisk prepare ##

The prepare subcommand allows you to clone your ingredients and optional
checkout a specified ref.

    $ whisk prepare
    Creating bowl 'testing' with path /home/msf/whisk/testing
    Preparing bowl 'testing' with path /home/msf/whisk/testing
    Cloning ingredient 'openssh', from url
    git://github.com/opscode-cookbooks/openssh.git
    Cloning into 'openssh'...
    Cloning ingredient 'ntp', from url
    git://github.com/opscode-cookbooks/ntp.git
    Cloning into 'ntp'...
    Creating bowl 'production' with path /home/msf/whisk/production
    Preparing bowl 'production' with path /home/msf/whisk/production
    Cloning ingredient 'openssh', from url
    git://github.com/opscode-cookbooks/openssh.git
    Cloning into 'openssh'...
    Checking out ref '1.0.0' for ingredient 'openssh'

You can also use specify a filter to run whisk subcommands on a subset of
cookbooks by specifying the bowl and ingredient separated by a forward slash.
Wildcards or optional matches can be specified by using ruby syntax.

    # Given the Whiskfile as described earlier in the documentation
    # prepare the 'development' bowl
    $ whisk prepare 'dev.*'

    # prepare the ntp cookbook in all configured bowls'
    $ whisk prepare '.*/ntp'

    # prepare a list of cookbooks
    $ whisk prepare 'dev/(ssh|ntp)'

## whisk status ##

Whisk status calls 'git status' on the specified set of ingredients.

You can use the same filter mechanisms as described in 'whisk prepare'
to run update on a subset of ingredients

    # show status for all configured bowls
    $ whisk status
    Status for bowl 'testing' with path /home/msf/whisk/testing
    Status for ingredient 'openssh'
    # On branch master
    nothing to commit (working directory clean)
    Status for ingredient 'ntp'
    # On branch master
    nothing to commit (working directory clean)
    Status for bowl 'production' with path /home/msf/whisk/production
    Status for ingredient 'openssh'
    # Not currently on any branch.
    nothing to commit (working directory clean)


## whisk update ##

Whisk update calls 'git remote update' on the specified set of ingredients
on them. It does not attempt to merge any code from your remotes.

You can use the same filter mechanisms as described in 'whisk prepare'
to run update on a subset of ingredients

    # update all ingredients, in all bowls
    $ whisk update

    # only update the 'development bowl'
    $ whisk update dev
