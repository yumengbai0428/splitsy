# splitsy
Ruby version: 2.6.6  
OS: macOS  
Names and UNIs:  
Harshini Ramanujam - hr2538  
Giffin Suresh -  gs3219  
Yumeng Bai - yb2542  
Federico Tondolo - ft2505  

Heroku link: https://gentle-springs-10839.herokuapp.com/

# Instructions to run product:

# Developer notes:
1. Set the main repo as your upstream `git remote add upstream https://github.com/harshiniwho/splitsy`
2. Before starting a new change do a `git pull --rebase upstream main`
3. Commit all changes
4. Do another `git pull --rebase upstream main` in case there were any commits in the middle of your development
5. Push changes to your fork `git push -f origin main`, most likely you might need the force because of rebasing
6. Then make a pull request to the main repo 
7. If there is a new migration file, run `bin/rake db:migrate` again