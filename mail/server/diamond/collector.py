# coding=utf-8

"""
Collects the number of emails for each user, and an aggregate.

#### Example configuration

```
[MailCollector]
spool_path = /var/mail/vhosts
```

This will publish metrics with the following pattern:

<hostname>.mail.example_com.<user>.count
"""
import os
import mailbox

import diamond.collector


class MailCollector(diamond.collector.Collector):

    def get_default_config_help(self):
        """
        Returns the default collector help text
        """
        config_help = super(MailCollector, self).get_default_config_help()
        config_help.update({
            'spool_path': ('Path to mail spool that contains files to be '
                           'analyzed.'),
            'mailbox_prefix': ('Prefix to add to the metric name. Use in case '
                               'you are monitoring more than one domain.'),
            'path': 'mail',
        })
        return config_help

    def get_default_config(self):
        """
        Returns the default collector settings
        """
        config = super(MailCollector, self).get_default_config()
        config.update({
            'spool_path': '/var/mail/',
            'mailbox_prefix': '',
            'path': 'mail',
            'prefixes': {}
        })
        return config

    def collect(self):
        metrics = {}
        metrics['total'] = 0

        base_paths = self.config['spool_path']
        if isinstance(base_paths, basestring):
            base_paths = [base_paths]

        for base_path in base_paths:
            for topdir in os.listdir(base_path):
                dirpath = os.path.join(base_path, topdir)

                prefix = '{0}.'.format(topdir.replace('.', '_'))
                for uname in os.listdir(dirpath):
                    fpath = os.path.join(dirpath, uname)
                    if os.path.isfile(fpath):
                        mbox = mailbox.mbox(fpath)
                        mname = "{0}{1}.count".format(prefix, uname)
                        metrics[mname] = len(mbox)
                        metrics['total'] += metrics[mname]

        self.publish_metrics(metrics)

        return True

    def publish_metrics(self, metrics):
        for name, value in metrics.iteritems():
            self.publish(name, value)
