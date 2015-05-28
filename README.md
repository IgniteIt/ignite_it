#Ignite

[Use Ignite on Heroku](https://igniteit.herokuapp.com/)

####Brief:

To create a crowdfunding platform for local community projects.

####Technologies:

Ruby, Rails, JQuery, Capybara, Selenium, RSpec, Stripe, Mailgun, Google APIs, Youtube API incl. other gems.

###User Stories:

As a first time user:
```
    I want to be able to sign up and create an account
    I want to be able to sing in with facebook
    I want to be able to sign out
    I want to be able to reset my password if forgotten
    I want the ability to edit my profile
```

As a signed in user:

```
    I want the ability to view projects on the homepage ordered by projects nearest to me, by those i have donated to and by those I am following
    I want the ability to follow and unfollow projects displayed on the tabs
    I want the ability to add a new project using a title, goal, sector, location, description, picture, youtube url and expiration date
    I want the ability to search for projects by name, location or sector
    I want the ability to donate to projects that have not expired
```

As a user on the projects page:
```
    I want to be able to view the title, sector, location, description, video, expiration date, progress bar, submitters's profile picture and name
    I want to be able to click on a tab to see a Q&A forum for each project
    I want to be able to click on a tab to see a list of users who have donated to the project
```

As somebody who has donated:
```
    I want to get an email which notifies me that the project has funded and/or expired
    I want to be able to pay via stripe using my credit/debit card once a project has expired and funded
```

####Tests:

#####140 tests, 97.12% test coverage
```
blogs
  Projects and their blogs
    Owner creates a blog
    who is not the owner cannot create a blog
    Owner has to be signed in to create blog
    When owner makes a blog, all donors are notified
    Owner can edit a blog
    Owner can delete a blog
    Only owner can edit and delete blogs

stripe
  if the user can pay
    fills in and submits stripe form
    it change donation status to true
  if the user can't pay
    because he hasn't donated
    because the time is not expired
    because he has already paid
    because the goal was not reached

Commenting
  users can comment on a blog post
  only logged in users can comment
  users can delete their own comments
  users can edit their own comments
  only users who made comments can delete or edit them

Donations
  as a user I want to be able to donate money
    I can donate money to a project and it is visible on the project page
    Must be logged in to donate
    Can list users who donated
    if the project has expired
      and the user has not donated
        can't donate
        can't visit new donation page
        can't donate in any case
      the user has donated and the goal was reached
        show a pay link if user has donated
      the user has donated but the goal was not reached
        show a project expired message

user follows a project
  user not logged in
    cannot follow projects
  user logged in
    cannot follow projects twice
    can unfollow projects
    a user can follow a project, which updates the project follow count
    if follow is not saved, then user is redirected to the projects page

projects crud
  creating projects
    prompts user to fill out a form, then displays a new project
    after creating a project the list in the home page self update
    creating an invalid project
      does not let you submit a name that is too short
      does not let you submit a description that is too short
      does not let you submit a project without a unique name
      does not let you submit a project without a goal
      does not let you submit a project without an expiration date
      does not let you submit a project without a sector
      does not let you submit a project without an address
  Editing and deleting a project
    lets a user edit a project
    lets a user delete a project
    only users who made a project can delete them
    only users who made a project can edit them
    when a project you donated to is edited, you are sent an email

projects
  no projects have been added
    page should have a title
    should display a prompt to add a project
  projects have been added
    display projects
    lets a user view a project
    on the show page
      there is a project with a name
      there is a project with a goal
      there is a project with a expiration date
      there is a project with a remaning amount
      there is a project with a completed goal
      there is a project with a non completed goal
      there is a project with a map
      Project is over and the goal was reached
        it shows a goal reached message
  project has been created with media
    on the show page
      there is a project with an image
      there is a project with a video
  User can navigate the app
    project view page has a return to homepage link

Project search
  when a search is not performed
    doesn't show the search
    it populates the sector search trough database values
  performing a search
    it paginate the query
    it can search for a project by location
    it can search for a project by his name
    it can search for a project by his sector
    it can perform a combined search

timer
  when a project is running
    it calculates 30 days from now in weeks and days
    it calculates 60 days from now in months and weeks
    it calculates 10 days from now in weeks and days
    it calculates 6 days from now in days and hours
    it calculates 1 day from now in hours and minutes
    it calculates 1 hour from now in minutes and seconds
  when a projects expires
    when a user arrives on the page status is already changed

user not signed in and on the homepage
  should see a 'sign in' link and a 'sign up' link
  should not see 'sign out' link
  when facebook credentials are invalid, will show an error
  when facebook credentials are valid, it will make a user
  on sign up, the user is sent an email

user signed in on the homepage
  should see 'sign out' link
  should not see a 'sign in' link and a 'sign up' link
  can log in with a username instead of an email

user can upload an avatar
  should be able to upload an avatar

user can edit their profile
  user can edit their profile

user can add a username
  can add a username

user is associated with a project they made
  can create a project and see their username

Blog
  should belong to project
  should have many comments

Comment
  should belong to blog
  should belong to user

Donation
  should belong to user
  is not valid without an amount
  has a false paid status when created
  can calculate the amount with pence
  can calculate the amount without pence

Follower
  should belong to project
  should belong to user

Project
  should belong to user
  is not valid with a name of less than five characters
  is not valid with a description of less than 200 characters
  is not valid unless it has an unique name
  is not valid without a goal
  is not valid without an expiration date
  is not valid without a sector
  is not valid without an address
  is not valid with an invalid video url
  can calculate the expiration date
  knows if he has no pic
  knows if he has no video
  knows the total of the donations
  knows the remaining
  knows if the goal was reached
  knows if the goal was not reached
  prints a message with how much left to reach the goal
  print a message when the goal is reached
  print a message when the goal is not reached
  knows if a project has expired
  knows if a project is not expired
  knows if a project has succeded
  knows if a project has not succeded
  knows if a project was paid
  knows if a project was not paid
  can get sector values
  knows if a user has donated
  knows if a user has not donated
  knows if a project is payable by a user
  knows if a project is not payable by a user because it is already paid
  knows if a project is not payable by a user because the time has not expired
  knows if a project is not payable by a user because he hasn't donated
  knows if a user is the owner
  knows if a user is not the owner
  knows the percentage of the goal completed for each project

User
  should have many projects
  is not valid without a username
  should have many donations
  should have many donations dependent => destroy
  should have many comments
  should have many comments dependent => destroy
```
