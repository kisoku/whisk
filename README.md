Whisk
=====

Whisk is a simple cookbook manager for Chef, inspired by librarian.
Unlike librarian, Whisk only concerns itself with fetching and preparing
exactly what you tell it. 

Whisk currently does not support any direct interaction with the Chef Server.

Currently Whisk only supports fetching cookbooks directly from git, 
although there are plans to include support for community cookbooks in the
future.

Whisk will prepare one or multiple 'bowls' of cookbooks as specified in your
whisk.rb file. 

    cb_path = "/home/msf/hack/whisk/%s"
    github = "git://github.com/cookbooks/%s.git"

    bowl "production" do
      path cb_path % name
      ingredient "ntp", :source github % "ntp"
    end 


