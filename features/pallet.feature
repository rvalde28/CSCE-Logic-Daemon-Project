Feature: Logic Char Pallet
  As a user of the logic daemon
  I want to be able to click graphical buttons to enter input
  So that I can easily and quickly enter input variables without learning a new syntax

    Scenario Outline: User clicks a graphical logic square
      Given user is on <page> page
      When user clicks on the <button> button
      Then user should see <input> in the input area
        
      Examples:
      |             page |      button |    input |
      |     logic/daemon |         and |        & |
      |     logic/daemon |     implies |       -> |
      |     logic/daemon |   universal |        @ |
      |     logic/daemon | disjunction |        v |
      |     logic/daemon |         iff |      <-> |
      |     logic/daemon | existential |        $ |
      |     logic/daemon |         not |        ~ |
      |     logic/daemon |       equal |        = |
      | logic/quizmaster |         and |        & |
      | logic/quizmaster |     implies |       -> |
      | logic/quizmaster |   universal |        @ |
      | logic/quizmaster | disjunction |        v |
      | logic/quizmaster |         iff |      <-> |
      | logic/quizmaster | existential |        $ |
      | logic/quizmaster |         not |        ~ |
      | logic/quizmaster |       equal |        = |
      |   logic/checkers |         and |        & |
      |   logic/checkers |     implies |       -> |
      |   logic/checkers |   universal |        @ |
      |   logic/checkers | disjunction |        v |
      |   logic/checkers |         iff |      <-> |
      |   logic/checkers | existential |        $ |
      |   logic/checkers |         not |        ~ |
      |   logic/checkers |       equal |        = |


    Scenario Outline: User clicks the clear square
      Given user is on <page> page
      When user clicks on the <button> button
      Then user should see <input> in the input area
      
      Examples:
      |             page |      button |    input |
      |     logic/daemon |         val |        A |
      | logic/quizmaster |         val |        A |
      |   logic/checkers |         val |        A |


    Scenario Outline: User clicks the clear square
      Given user is on <page> page
        And there is something in the input area
      When user clicks on the <button> button
      Then user should see that the input area is cleared
        
      Examples:
      |             page | button |
      |     logic/daemon |  clear |
      | logic/quizmaster |  clear |
      |   logic/checkers |  clear |
    
    
    Scenario Outline: User clicks the delete square
      Given user is on <page> page
        And there is something in the input area
      When user clicks on the <button> button
      Then user should see 1 less character in the input area
        
      Examples:
      |             page | button |
      |     logic/daemon | delete |
      | logic/quizmaster | delete |
      |   logic/checkers | delete |
    
