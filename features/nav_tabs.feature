@navigation
Feature: navigate tabs
As a user of the site,
I want to navigate from page to page without having to return to the home page
So that it is easy for me to navigate the entire site

  Scenario Outline: navigate all tabs
    Given user is on <page> page
    When user clicks to go to the <newpage> page
    Then user should see that they are on the <next> page
	
	Examples:
	|             page |    newpage |       next |
	|       logic/home |     primer |     Primer |
	|       logic/home |     daemon |     Daemon |
	|       logic/home | quizmaster | Quizmaster |
	|       logic/home |   checkers |    Checker |
	|     logic/primer |       home |       Home |
	|     logic/primer |     daemon |     Daemon |
	|     logic/primer | quizmaster | Quizmaster |
	|     logic/primer |   checkers |    Checker |
	|     logic/daemon |       home |       Home |
	|     logic/daemon |     primer |     Primer |
	|     logic/daemon | quizmaster | Quizmaster |
	|     logic/daemon |   checkers |    Checker |
	| logic/quizmaster |       home |       Home |
	| logic/quizmaster |     primer |     Primer |
	| logic/quizmaster |     daemon |     Daemon |
	| logic/quizmaster |   checkers |    Checker |
	|   logic/checkers |       home |       Home |
	|   logic/checkers |     primer |     Primer |
	|   logic/checkers |     daemon |     Daemon |
	|   logic/checkers | quizmaster | Quizmaster |
