Feature: Sign in
  As a user of the logic daemon
  I want to be able to log into quizmaster
  So that I can be logged for my time

    Scenario: User signs in successfully
      Given user is not logged in
      When user signs in with valid credentials
      Then user should see a successful sign in message
        And user should be signed in

    Scenario: User enters invalid input
      Given user is not logged in
      When user signs in with invalid credentials
      Then user should see an invalid login message
        And user should be signed out
        
    Scenario: User signs in as anonymous
      Given user is not logged in
      When user signs in with anonymous
      Then user should see a successful sign in message
        And user should be signed in
        
    Scenario: User attempts to sign in again
      Given user is logged in
      When user signs in with valid credentials
      Then user should see an invalid login message
        And user should be signed in