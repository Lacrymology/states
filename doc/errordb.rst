Development errors
==================

This is a collection of errors may happen when developing salt-formula with
salt-common and solutions to fix them.

unused documented pillars
-------------------------

- file contains the pillar is not managed, maybe it is wrapped by a condition.
- file is not rendered, missing argument: ``template: jinja``
