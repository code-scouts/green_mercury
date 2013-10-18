Changing the User Definition
============================

Green Mercury uses [Janrain Capture](http://janrain.com/products/capture/) to manage its user database. Rather than storing user information in our own database, we store it in the Capture database and fetch user data using the API. This has various advantages, but one of the disadvantages is that schema changes to the users table are somewhat awkward.

Let's use [issue 21: "Profile Types And Applications"](https://github.com/code-scouts/green_mercury/issues/21) as an example. Under a normal "users in the database" paradigm, you'd probably add `is_mentor` and `is_admin` columns to the Users table and create an Applications table with a foreign key into the Users table. You can't do that in Green Mercury, though.

Instead you need to alter the entityType in the Janrain Capture database. The entityType is analogous to a database table definition. See [the Janrain documentation](http://developers.janrain.com/documentation/api-methods/entitytype/) for information about changing entityTypes. For our example issue, you'd use `entityType.addAttribute` to add `is_admin` and `is_mentor` attributes to the `user` entityType.

The entityType api calls require a `client_id` and `client_secret`. Naturally, the `client_secret` isn't committed to source control, but the `client_id` you should use for development is `uxufbdmf4n9htrm6z7t8kmgwy3r5faa5`.

Code Scouts has two Capture "Apps": production and development (An app consists of one or more entityTypes, plus a collection of settings and credentials). The dev App is shared by all developers, which means you need to use caution when changing the entityType. Ask yourself, "is this backwards-compatible, or will it hose anyone who doesn't have the associated code?" For example, removing an attribute, or adding a non-nullable attribute, would mean anyone who has a copy of the code that doesn't know about those columns would be unable to interact with the development App.

Associating Other Tables With A User Record
===========================================

Coming back to our "Profile Types And Applications" example, the natural move is to have an `applications` table with a `user_id` column. In reality, though, you need a `user_uuid` column. This column should be type "text" and contain the uuid of the associated Capture entity. There's no way to enforce a foreign key relationship at the database level.

Migrations
==========

Since we are not able to use ActiveRecord migrations for changes to the user entityType, we need to create our own migration system. At the moment, we use something fairly rudimentary: create a file called `user_migrations/XXXXXXXXX_do_something_to_users.sh` that contains curl calls that will interact with the Janrain API and alter the entity type and secret. Make the `XXXXXXXX` be the date and time that you created the file; this will "document" the order in which migrations need to happen (in case they have interdependencies). You can use the unix command `date -u '+%Y%m%d%H%M%S'` to print a datetime. So for our example task, you might have a file called `20131013200041_add_profile_types.sh`, with two commands in it:

```Bash
#! /bin/bash

curl -X POST -d client_id=$CLIENT_ID -d client_secret=$CLIENT_SECRET -d type_name=user --data-urlencode attr_def='{"name":"is_mentor","type":"boolean"}' https://codescouts$DEV.janraincapture.com/entityType.addAttribute
curl -X POST -d client_id=$CLIENT_ID -d client_secret=$CLIENT_SECRET -d type_name=user --data-urlencode attr_def='{"name":"is_admin","type":"boolean"}' https://codescouts$DEV.janraincapture.com/entityType.addAttribute
```

then to apply the migration you would execute the migration file:
```Bash
CLIENT_ID=uxufbdmf4n9htrm6z7t8kmgwy3r5faa5 CLIENT_SECRET=xxxxxxxxxxx DEV=-dev bash user_migrations/20131013200041_add_profile_types.sh
```
And to apply the migration to production I would run it with the production client id and secret, and with no DEV env var.

Be sure not to commit the client secret to version control!
