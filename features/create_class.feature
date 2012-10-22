Feature: Add class to the session
  
  As an administrator
  So that I can schedule classes for the session
  I want to add classes to the new session
  
Background: populate db with a single class session

  Given the following sessions exist:
  | name        | start_date    | end_date  | lottery_deadline  | registration_deadline | dates_with_no_classes |
  | Fall 2011   | 09/15/2011    | 12/15/2011| 09/09/2011        | 09/14/2011            | 11/13/2011            |

Scenario: Create New Class
  Given I am on the home page
  And I follow "Fall 2011"
  Then I should be on the Session Name Page
  And the "Session Name" field should contain "Fall 2011"
  When I press "Add New"
  Then I should be on the Create Class Page
  When I fill in "Class Name" with "Math"
  And I fill in "Class Description" with "A class about numbers"
  And I check "Monday"
  And I fill in "Start Time Hour" with "2"
  And I fill in "Start Time Minute" with "10"
  And I fill in "End Time Hour" with "3"
  And I fill in "End Time Minute" with "30"
  And I fill in "Class Min" with "0"
  And I fill in "Class Max" with "20"
  And I fill in "Grade Range" with "1-5"
  And I fill in "Fee Per Meeting" with "10"
  And I fill in "Fee For Additional Materials" with "15"
  And I press "Create"
  Then I should be on the Session Name Page
  And I should see "Math"
  
Scenario: Cancel Create New Class
  Given I am on the home page
  And I follow "Fall 2011"
  Then I should be on the Session Name Page
  And the "Session Name" field should contain "Fall 2011"
  When I press "Add New"
  Then I should be on the Create Class Page
  When I fill in "Class Name" with "Math"
  And I press "Cancel"
  Then I should be on the Are You Sure? Page
  When I press "Yes"
  Then I should be on the Session Name Page
  And no new classes should be added

Scenario: Recover From Clicking Cancel
  Given I am on the Create Class Page
  When I fill in "Class Name" with "Math"
  And I press "Cancel"
  Then I should be on the Are You Sure? Page
  When I press "No"
  Then I should be on the Create Class Page
  And the "Class Name" field should contain "Math"
  
Scenario:   
