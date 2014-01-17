How to upload new files
-----------------------

First, your Salt Archive server need to be a "master" server. It don't have to
act solely as a mirror and rsync to a source.

If a server got the pillar key ``salt_archive:source`` set to ``True``, any
new files will be erased on next synchronization with the said source.

If your server don't have a source, an incoming folder is created for any
authorized users to upload new file.

To upload you have to copy the new file in ``incoming/pip`` (if it's a Python
package) or ``incoming/mirror`` directory on the server using SFTP with the
username ``salt_archive``.

The access to this user is granted using SSH keys, you have your public key in
``salt_archive:keys`` pillar key.

Once your file is uploaded, after a while, a cron job run and if the same file
don't exists in ``pip/`` and ``mirror/`` it will move it if the file don't
already exists to avoid the same filename with different content.

If file exists, it get removed.
