## Coding Guidelines
* Mainly write logic on app/models/concerns/*.rb; Use "Fat Model, Skinny Controller" principle.
* Prefere "module functions"; where "module SomeModule; class << self; def some_method; end; end; end" style. Use a few instance methods for models.
* Create tests for app/models/concerns/*.rb in test/models/concerns/*.rb
* When adding a new Controller, you must add tests for it.
* View of MVC is written in `app/views/**/*.html.haml` .

## After finished writing codes
* Please add some tests.
  * All comments and test case names should be written in Japanese.
* Always exec $ bundle exec rubocop -A; and $ bundle exec rails test;
  * Metrics/BlockLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/ClassLength can be ignored if necessary. Add "rubocop:disable" comments after the method/class definition line.
  * rubocop can't check the Haml files; for Haml files, please check by bundle exec rails test.
