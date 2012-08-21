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

    cb_path = "/home/msf/hack/whisk/%s"
    github = "git://github.com/cookbooks/%s.git"

    bowl "production" do
      path cb_path % name

      ingredient "ntp" do
        source github % "ntp"
        ref '1.1.2'
      end
    end

# Commands #

##  whisk prepare ##

The prepare subcommand allows you to clone your ingredients and optional
checkout a specified ref.

    $ whisk prepare
    Creating bowl 'production' with path /home/msf/hack/whisk/production
    Preparing bowl 'production' with path /home/msf/hack/whisk/production
    Cloning ingredient ntp, from git url git://github.com/cookbooks/ntp.git
    Cloning into 'ntp'...
    Checking out ref '1.1.2' for ingredient ntp

You can also use specify an optional filter to run prepare on a subset of
cookbooks using ruby regexes.

    # prepare the 'development' bowl
    $ whisk prepare dev

    # prepare the ntp cookbook in all configured bowls'
    $ whisk prepare '.*' 'ntp'

    # prepare a list of cookbooks
    $ whisk prepare 'dev' '(ssh|ntp)'

## whisk status ##

Whisk status calls 'git status' on the specified set of ingredients.

You can use the same filter mechanisms as described in 'whisk prepare'
to run update on a subset of ingredients

    # show status for all configured bowls
    $ whisk status
    Status for ingredient 'production/ntp'
    # On branch master
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
