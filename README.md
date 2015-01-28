# Stockor::Demo

Extension to the Lanes framework to provide Stockor
with demo login support.

It modifies the login user experience so users can choose what role they
would like to use when testing Stockor.

To do so, it:

 * Seeds the DB with multiple users with different roles
 * Replaces the login form with a selection so the desired role can be chosen
 * Adds routes to Stockor for the login form to log in/out