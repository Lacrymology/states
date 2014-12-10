import collections
import pickle
import logging

from salt.modules import pillar

DATA_KEY = 'pillar.get'

logger = logging.getLogger('pillar_common')


def __virtual__():
    # HACK: load the core pillar module with the variables injected by salt
    try:
        pillar.__salt__ = __salt__
        pillar.__pillar__ = __pillar__
        pillar.__opts__ = __opts__
        pillar.__grains__ = __grains__
        pillar.__context__ = __context__
        logger.debug("Pillar Common Proxy Initialized")
        return 'pillar'
    except NameError:
        logger.debug("Pillar Common Proxy can't load at this point, try again"
                     "later")
        return False


# copy the core pillar context
__proxyenabled__ = pillar.__proxyenabled__
for name in dir(pillar):
    if not name.startswith("_"):
        globals()[name] = getattr(pillar, name)


_cached_calls = None


def reset():
    '''
    Reset data kept on pillar usage.
    '''
    global _cached_calls
    __salt__['data.update'](DATA_KEY, None)
    _cached_calls = None


def get(key, default=KeyError, *args, **kwargs):
    DEBUG = pillar.get('__test__', False)

    if DEBUG:
        calls = __salt__['pillar.get_calls']()
        if default not in calls[key]:
            calls[key].append(default)
            __salt__['pillar.get_calls'](value=calls)

    ret = pillar.get(key, default)
    if ret is KeyError:
        raise KeyError("Pillar key does not exist: %s" % key)
    return ret


def get_calls(value=Exception, *args, **kwargs):
    """
    Returs the calls collected with _save_calls

    if `value` is not `None`, it sets it as well (returns the value before
    changing it)
    """
    global _cached_calls

    if _cached_calls is None:
        _cached_calls = __salt__['data.getval'](DATA_KEY)
        if _cached_calls is None:
            _cached_calls = collections.defaultdict(list)
        else:
            _cached_calls = pickle.loads(_cached_calls)

    if value != Exception:
        _cached_calls = value
        __salt__['data.update'](DATA_KEY, value=pickle.dumps(value))

    return _cached_calls

def get_call_desc():
    return ["{}: {}".format(key, "|".join(map(str, val)))
            for key, val in __salt__['pillar.get_calls']().iteritems()]
