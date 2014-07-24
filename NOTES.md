#So you wanna roll this on staging?

This is working, it converges, all the tests pass. I have no reason to believe it won't just work on a real node. However, note ye well:

* `action :force_deploy` is still set. This wants to be `action :deploy` before it goes into the wild
* It will need a wrapper cookbook, which it should be possible to construct from `.kitchen.yml`
* Look in the test data_bags here and compare to the actual data_bags and fill in as appropriate
* I've changed to using the name _certificates_ throughout
* To set up the database,

You know what? Leave this, we'll do it first thing Monday
