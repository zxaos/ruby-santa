ruby-santa
==========

Generates secret-santa pairings and email participants the details

Usage:
* Add the list of participants to the PEOPLE hash at the top of the file. Some example entries are included. Names included in the "restrictions" key are participants whom the current participant should *not* send a gift to (useful for ensuring participants get different people each year, or splitting up partners etc.)
* Configure the email content by setting MAIL_SENDER, MAIL_SUBJECT, and modifying the body string in the mail loop as needed.
* Configure the email sending service on line 45
* Invoke the script from the command line

Notes:
* This was hacked together quite quickly and I don't think it's a great example of Ruby code. Suggested improvements are always welcome.
