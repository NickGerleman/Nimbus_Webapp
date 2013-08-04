# Nimbus

This is the source code for Nimbus. Although this wasn't designed to be run as a personal service, there is nothing stoping you from doing that if you want to, as long as you don't run it commercially. Feel free to contribute to this project or fork it, just make sure to provide attribution. More inforamtion is available on the wiki.




## Setting It Up
Setup is pretty standard although there are certain assumptions made. One of which is that the application has only been tested using MRI/YARV 2.0. Just run `bundle install` and let it install everything. Note that you will probbaly want to install it without the test or production group using `bunele install --without test production`, as the test and production groups require several external dependencies. To get the node.js portion running, you need to install the `faye` and 
`faye-redis` packages to the faye directoy. This can be done by going into the directory and running `npm install faye faye-redis`. Additionally, you must define several environmental variables when running this in order for the respective functionality to work. You must also have Redis installed. You can use Foreman to run the entire thing.

###Environmental Variables

Nimbus requires several environmental variables to be run properly. This can be done by editing the user profile or adding a script to `/etc/profile.d/`. It is not reccomended to do this as a Rails initializer as the node.js app relies on some of these as well. An example script is included as `env.example.sh`. Make sure to make it executable after copting it.

 - HOST  

   The being used, for example `nimbuu.us`  
   If none is provided, `127.0.0.1` is used

 - SOCKET_KEY  

   The encryption key useed by HMAC to authenticate Faye messages

 - SOCKET_MASTER

   The random number that can be used as an auth_token to bypass HMAC based veriication

 - REDIS_URL    

  The Redis URL being used, eg `redis://127.0.0.1:6379`  
  If none is provided, the above is assumed

 - SECRET_TOKEN

   The token used for rails cookies  
   If one is not provided, athere is a built in one, this is fine for development but would be insecure for production
   

 - RECAPTCHA\_PUBLIC_KEY  

   The public key used for RECAPTCHA  
   If none is provided RECAPTCHA is disabled
 
 
 - RECAPTCHA\_PRIVATE_KEY  

   The private key used for RECAPTCHA



The following are the Cryptographic keys used for OAuth on the various providers.

 - BOX\_CLIENT_ID
 - BOX\_CLIENT_SECRET
 - DROPBOX\_CLIENT_ID
 - DROPBOX\_CLIENT_SECRET
 - GOOGLE\_CLIENT_ID
 - GOOGLE\_CLIENT_SECRET
 - SKYDRIVE\_CLIENT_ID
 - SKYDRIVE\_CLIENT_SECRET



## Deployment Information
Nimbus is deployed on [Digital Ocean][11] on two servers, each running Centos 6.4. Deployment is handled using Capistrano, but that script is not included as it it deployment specific and also contains sensitive information.  

One runs Clockwork, Redis, Sidekiq, and Nginx as a reverse proxy / load balancer / SSL terminator.  

A second server runs the rails app using Unicorn, as well as the node.js app using Faye.  

Currently Heroku Postgres is used as the databse, although this will probably soon change to a seperate server running Redis and some form of SQL server.


[11]: https://www.digitalocean.com/?refcode=1206d329a7f0




## Technologies Used

 - [Ruby on Rails][2]
 - [Sidekiq][3]
 - [Clockwork][4]
 - [Redis][5]
 - [RSpec][6]/[Capybara][7]
 - [node.js][8]
 - [Faye][9]
 - [Zurb Foundation][10]


  [1]: https://www.digitalocean.com/?refcode=1206d329a7f0
  [2]: http://rubyonrails.org/
  [3]: https://github.com/mperham/sidekiq
  [4]: https://github.com/tomykaira/clockwork
  [5]: http://redis.io/
  [6]: http://rspec.info/
  [7]: http://jnicklas.github.io/capybara/
  [8]: http://nodejs.org/
  [9]: http://faye.jcoglan.com/
  [10]: http://foundation.zurb.com/    