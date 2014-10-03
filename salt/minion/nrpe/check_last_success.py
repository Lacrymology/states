import datetime
import logging

import salt.config
import salt.loader
import nagiosplugin as nap

import pysc
import pysc.nrpe as bfe

log = logging.getLogger('nagiosplugin.salt.minion.last_success')
TS_KEY = 'returner_timestamps_last_success'


class LastSuccess(nap.Resource):
    def probe(self):
        try:
            __opts__ = salt.config.minion_config('/etc/salt/minion')
            datamod = salt.loader.raw_mod(__opts__, 'data', None)
            ts = datamod['data.getval'](TS_KEY)
        except Exception as e:
            log.critical('Cannot get value of %s. Error: %s',
                         TS_KEY, e, exc_info=True)
            raise
        else:
            try:
                hours = (datetime.datetime.now() -
                         datetime.datetime.strptime(ts,
                         "%Y-%m-%dT%H:%M:%S.%f")).total_seconds() / 3600
                ret = [nap.Metric('last_success', hours, min=0,
                                  context='hours')]
                return ret
            except Exception:
                log.critical(('Expected a string presents time in ISO format, '
                              'got %r. If it is None, probably timestamps '
                              'returner has never returned.'),
                             ts)
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
