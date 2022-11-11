# splitsy
Ruby version: 2.6.6  
OS: macOS  
Names and UNIs:  
Harshini Ramanujam - hr2538  
Yumeng Bai - yb2542  
Federico Tondolo - ft2505  
Giffin Suresh -  gs3219  

Heroku link: https://gentle-springs-10839.herokuapp.com/

# Instructions to run product:
1. Set ruby version to 2.6.6 - `rbenv local 2.6.6`
2. Install dependencies - `bundle install`
3. Run the DB migrations - `bin/rake db:migrate`
4. Seed local data in sqlite3 - `bin/rake db:seed`
5. Start the local instance - `bin/rails server -b 0.0.0.0`
6. To run cucumber tests - `bundle exec cucumber`
7. To run rspec tests - `bundle exec rspec`

# Developer notes:
1. Set the main repo as your upstream `git remote add upstream https://github.com/harshiniwho/splitsy`
2. Before starting a new change do a `git pull --rebase upstream main`
3. Commit all changes
4. Do another `git pull --rebase upstream main` in case there were any commits in the middle of your development
5. Push changes to your fork `git push -f origin main`, most likely you might need the force because of rebasing
6. Then make a pull request to the main repo 
7. If there is a new migration file, run `bin/rake db:migrate` again
8. To run cucumber tests, run 'bundle exec cucumber'