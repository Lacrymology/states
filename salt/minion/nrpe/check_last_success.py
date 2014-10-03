import logging
import datetime

import nagiosplugin as nap
import yaml

import pysc


log = logging.getLogger('nagiosplugin.salt.minion.last_success')
timestamps_path = '/var/cache/salt/minion/returner_timestamps'


class LastSuccess(nap.Resource):
    def probe(self):
        try:
            with open(timestamps_path) as f:
                ts = yaml.load(f)
                try:
                    minutes = (datetime.datetime.now() -
                               datetime.datetime.strptime(ts['last_success'],
                               "%Y-%m-%dT%H:%M:%S.%f")).total_seconds() / 60
                    ret = [nap.Metric('last_success', minutes, min=0,
                                      context='minutes')]
                    return ret
                except Exception:
                    log.critical('Not found timestamps of last success')
                    raise
        except IOError:
            log.critical('%s does not exist, looks like ``timestamps``'
                         ' returner has never been called')
            raise


@nap.guarded
def main():
    check = nap.Check(LastSuccess(),
                      nap.ScalarContext('minutes', '0:48',
                                        '0:48',
                                        fmt_metric='{value} minutes ago'))
    check.main()

if __name__ == "__main__":
    main()
