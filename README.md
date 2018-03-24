topiary
=======

[![Build Status](https://travis-ci.org/pjungwir/topiary.svg?branch=master)](https://travis-ci.org/pjungwir/topiary)

Topiary provides a topological sort function for a Directed Acyclic Graph (DAG), in Ruby.
It uses [Kahn's Algorithm](https://en.wikipedia.org/wiki/Directed_acyclic_graph#Topological_sorting_and_recognition)
which is linear on the number of nodes.
Ruby 1.9 and up are supported.

![Topologically distinct directed acyclic graphs with four vertices](/marshmallows.jpg)


Usage
-----

First create some nodes as `Topiary::Node` objects,
including a custom `data` attribute on each node if you want.
Set up edges by calling `n1.feeds! n2` or `n2.needs! n1`.
Then when you're ready, pass a list of all the nodes to `Topiary.sort`.
You'll get back an array containing every node in topological order.
If you have any questions about using it, take a look at the tests.


Tests
-----

There are lots of RSpec tests.
Say `rake` to run them plus Rubocop,
or `rspec spec` to run just the tests.

I tried to test all possible DAGs up to four nodes,
although since I couldn't find a comprehensive list I just did my best with toothpicks and marshmallows.
If you find that I skipped something, let me know!
Anyway, after all these marshmallows I'm pretty sure the sort works. :-)


Contributing to topiary
-----------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone hasn't already requested and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make be sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, that is fine, but please isolate that change to its own commit so I can cherry-pick around it.

Commands for building/releasing/installing:

* `rake build`
* `rake install`
* `rake release`

Copyright
---------

Copyright (c) 2018 Paul A. Jungwirth.
See LICENSE.txt for further details.

