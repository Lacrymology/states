Installation
============

Manually setup is required after install :doc:`index`. Open the domain define in
:ref:`pillar-piwik-hostnames` in browser and follow the steps display in the
screen, press Next button to go to next step. Instructions:

1. Welcome!

   Just display welcome message, no input is required.

2. System Check

   Check if dependencies packages are installed and required directories are in
   correct states. If not all items mark with a green check, the formula is
   wrong.

3. Database Setup

   Fill following inputs to the form:

     * Database Server: ``127.0.0.1`` (default)

     * Login: ``piwik``

     * Password: the value of :ref:`pillar-piwik-db-password`.

     * Database Name: ``piwik``

     * Table Prefix: ``piwik_`` (default)

     * Adapter: ``PDO\MYSQL`` (default)

4. Creating the Tables

   Display ``Tables created with success!`` if everything goes well. If not
   check the inputs in previous step.

5. Super User

   Fill username and password of administrator account to create.

6. Setup a Website

   Register a website to track.

7. JavaScript Tracking Code

   Display JavaScript code and the instruction to add to your website.

8. Congratulations

   Display congratulations message.
