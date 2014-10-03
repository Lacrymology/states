import datetime
import logging

import nagiosplugin as nap
import yaml

import pysc
import pysc.nrpe as bfe


log = logging.getLogger('nagiosplugin.salt.minion.last_success')
timestamps_path = '/var/cache/salt/minion/returner_timestamps'


class LastSuccess(nap.Resource):
    def probe(self):
        try:
            with open(timestamps_path) as f:
                ts = yaml.load(f)
                try:
                    hours = (datetime.datetime.now() -
                             datetime.datetime.strptime(ts['last_success'],
                             "%Y-%m-%dT%H:%M:%S.%f")).total_seconds() / 3600
                    ret = [nap.Metric('last_success', hours, min=0,
                                      context='hours')]
                    return ret
                except Exception:
                    log.critical('Not found timestamps of last success')
                    raise
        except IOError:
            log.critical('%s does not exist, looks like ``timestamps``'
                         ' returner has never been called')
            raise


@nap.guarded
@pysc.profile(log=log)
def main():
    argp = bfe.ArgumentParser()
    args = argp.parse_args()
    check = bfe.Check(LastSuccess(),
                      nap.ScalarContext('hours', '0:48',
                                        '0:48',
                                        fmt_metric='{value} hours ago'))
    check.main(args)

if __name__ == "__main__":
    main()
