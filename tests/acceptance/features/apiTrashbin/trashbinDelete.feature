@api @TestAlsoOnExternalUserBackend @files_trashbin-app-required @skipOnOcis @issue-ocis-reva-52
Feature: files and folders can be deleted from the trashbin
  As a user
  I want to delete files and folders from the trashbin
  So that I can control my trashbin space and which files are kept in that space

  Background:
    Given the administrator has enabled DAV tech_preview
    And user "user0" has been created with default attributes and without skeleton files
    And user "user0" has uploaded file with content "to delete" to "/textfile0.txt"
    And user "user0" has uploaded file with content "to delete" to "/textfile1.txt"
    And user "user0" has created folder "PARENT"
    And user "user0" has created folder "PARENT/CHILD"
    And user "user0" has uploaded file with content "to delete" to "/PARENT/parent.txt"
    And user "user0" has uploaded file with content "to delete" to "/PARENT/CHILD/child.txt"

  @smokeTest
  Scenario Outline: Trashbin can be emptied
    Given using <dav-path> DAV path
    And user "user0" has deleted file "/textfile0.txt"
    And user "user0" has deleted file "/textfile1.txt"
    And as "user0" file "/textfile0.txt" should exist in the trashbin
    And as "user0" file "/textfile1.txt" should exist in the trashbin
    When user "user0" empties the trashbin using the trashbin API
    Then as "user0" the file with original path "/textfile0.txt" should not exist in the trashbin
    And as "user0" the file with original path "/textfile1.txt" should not exist in the trashbin
    Examples:
      | dav-path |
      | old      |
      | new      |

  @smokeTest
  Scenario: delete a single file from the trashbin
    Given user "user0" has deleted file "/textfile0.txt"
    And user "user0" has deleted file "/textfile1.txt"
    And user "user0" has deleted file "/PARENT/parent.txt"
    And user "user0" has deleted file "/PARENT/CHILD/child.txt"
    When user "user0" deletes the file with original path "textfile1.txt" from the trashbin using the trashbin API
    Then the HTTP status code should be "204"
    And as "user0" the file with original path "/textfile1.txt" should not exist in the trashbin
    But as "user0" the file with original path "/textfile0.txt" should exist in the trashbin
    And as "user0" the file with original path "/PARENT/parent.txt" should exist in the trashbin
    And as "user0" the file with original path "/PARENT/CHILD/child.txt" should exist in the trashbin

  @smokeTest
  Scenario: delete multiple files from the trashbin and make sure the correct ones are gone
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/PARENT/textfile0.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/PARENT/child.txt"
    And user "user0" has deleted file "/textfile0.txt"
    And user "user0" has deleted file "/textfile1.txt"
    And user "user0" has deleted file "/PARENT/parent.txt"
    And user "user0" has deleted file "/PARENT/child.txt"
    And user "user0" has deleted file "/PARENT/textfile0.txt"
    And user "user0" has deleted file "/PARENT/CHILD/child.txt"
    When user "user0" deletes the file with original path "/PARENT/textfile0.txt" from the trashbin using the trashbin API
    And user "user0" deletes the file with original path "/PARENT/CHILD/child.txt" from the trashbin using the trashbin API
    Then as "user0" the file with original path "/PARENT/textfile0.txt" should not exist in the trashbin
    And as "user0" the file with original path "/PARENT/CHILD/child.txt" should not exist in the trashbin
    But as "user0" the file with original path "/textfile0.txt" should exist in the trashbin
    And as "user0" the file with original path "/PARENT/child.txt" should exist in the trashbin

  @skipOnOcV10.3
  Scenario: User tries to delete another user's trashbin
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has deleted file "/textfile0.txt"
    And user "user0" has deleted file "/textfile1.txt"
    And user "user0" has deleted file "/PARENT/parent.txt"
    And user "user0" has deleted file "/PARENT/CHILD/child.txt"
    When user "user1" tries to delete the file with original path "textfile1.txt" from the trashbin of user "user0" using the trashbin API
    Then the HTTP status code should be "401"
    And as "user0" the file with original path "/textfile1.txt" should exist in the trashbin
    And as "user0" the file with original path "/textfile0.txt" should exist in the trashbin
    And as "user0" the file with original path "/PARENT/parent.txt" should exist in the trashbin
    And as "user0" the file with original path "/PARENT/CHILD/child.txt" should exist in the trashbin

  Scenario: User tries to delete trashbin file using invalid password
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has deleted file "/textfile0.txt"
    And user "user0" has deleted file "/textfile1.txt"
    And user "user0" has deleted file "/PARENT/parent.txt"
    And user "user0" has deleted file "/PARENT/CHILD/child.txt"
    When user "user1" tries to delete the file with original path "textfile1.txt" from the trashbin of user "user0" using the password "invalid" and the trashbin API
    Then the HTTP status code should be "401"
    And as "user0" the file with original path "/textfile1.txt" should exist in the trashbin
    And as "user0" the file with original path "/textfile0.txt" should exist in the trashbin
    And as "user0" the file with original path "/PARENT/parent.txt" should exist in the trashbin
    And as "user0" the file with original path "/PARENT/CHILD/child.txt" should exist in the trashbin

  Scenario: User tries to delete trashbin file using no password
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has deleted file "/textfile0.txt"
    And user "user0" has deleted file "/textfile1.txt"
    And user "user0" has deleted file "/PARENT/parent.txt"
    And user "user0" has deleted file "/PARENT/CHILD/child.txt"
    When user "user1" tries to delete the file with original path "textfile1.txt" from the trashbin of user "user0" using the password "" and the trashbin API
    Then the HTTP status code should be "401"
    And as "user0" the file with original path "/textfile1.txt" should exist in the trashbin
    And as "user0" the file with original path "/textfile0.txt" should exist in the trashbin
    And as "user0" the file with original path "/PARENT/parent.txt" should exist in the trashbin
    And as "user0" the file with original path "/PARENT/CHILD/child.txt" should exist in the trashbin
