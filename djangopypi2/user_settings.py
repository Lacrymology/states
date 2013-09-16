import os
import json

AVAILABLE_SETTINGS = [
    dict(name='ADMINS'       , default=[]               , type='names_and_emails'),
    dict(name='DEBUG'        , default=False            , type='bool'),
    dict(name='TIME_ZONE'    , default='America/Chicago', type='timezone'),
    dict(name='WEB_ROOT'     , default='/'              , type='str'),
    dict(name='LANGUAGE_CODE', default='en-us'          , type='str'),
    dict(name='ALLOW_VERSION_OVERWRITE', default=''     , type='str'),
    dict(name='USE_HTTPS'    , default=False            , type='bool'),

    dict(name='EMAIL_SERVER' , default='smtp://localhost:1025/', type='str'),
    dict(name='EMAIL_USE_TLS', default=False            , type='bool'),
    dict(name='EMAIL_DEFAULT_SENDER', default='sender@example.com', type='str'),
]

def _filename(project_root):
    return os.path.join(project_root, 'settings.json')

def load(project_root):
    filename = _filename(project_root)
    if not os.path.exists(filename):
        save(project_root, dict((setting['name'], setting['default']) for setting in AVAILABLE_SETTINGS))
    return json.loads(open(filename, 'r').read())

def save(project_root, user_settings):
    fo = open(_filename(project_root), 'w')
    fo.write(json.dumps(user_settings, indent=4))
    fo.close()
