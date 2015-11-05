# -*- coding: utf-8 -*-
'''
A salt module for SSL/TLS.
Can create a Certificate Authority (CA)
or use Self-Signed certificates.

:depends:   - PyOpenSSL Python module
:configuration: Add the following values in /etc/salt/minion for the CA module
    to function properly::

        ca.cert_base_path: '/etc/pki'
'''

# pylint: disable=C0103

# Import python libs
import os
import time
import logging
import hashlib
from datetime import datetime
import re

HAS_SSL = False
try:
    import OpenSSL
    HAS_SSL = True
except ImportError:
    pass

# Import salt libs
import salt.utils
from salt._compat import string_types


log = logging.getLogger(__name__)

two_digit_year_fmt = "%y%m%d%H%M%SZ"
four_digit_year_fmt = "%Y%m%d%H%M%SZ"


def __virtual__():
    '''
    Only load this module if the ca config options are set
    '''
    if HAS_SSL:
        return True
    return False


def _cert_base_path():
    '''
    Return the base path for certs
    '''
    return __salt__['config.option']('ca.cert_base_path')


def _new_serial(ca_name, CN):
    '''
    Return a serial number in hex using md5sum, based upon the ca_name and
    CN values

    ca_name
        name of the CA
    CN
        common name in the request
    '''
    hashnum = int(
            hashlib.md5(
                '{0}_{1}_{2}'.format(
                    ca_name,
                    CN,
                    int(time.time()))
                ).hexdigest(),
            16
            )
    log.debug('Hashnum: {0}'.format(hashnum))

    # record the hash somewhere
    cachedir = __opts__['cachedir']
    log.debug('cachedir: {0}'.format(cachedir))
    serial_file = '{0}/{1}.serial'.format(cachedir, ca_name)
    with salt.utils.fopen(serial_file, 'a+') as ofile:
        ofile.write(str(hashnum))

    return hashnum


def _four_digit_year_to_two_digit(datetimeObj):
    return datetimeObj.strftime(two_digit_year_fmt)


def _get_basic_info(ca_name, cert, ca_dir=None):
    '''
    Get basic info to write out to the index.txt
    '''
    if ca_dir is None:
        ca_dir = '{0}/{1}'.format(_cert_base_path(), ca_name)

    index_file = "{0}/index.txt".format(ca_dir)

    expire_date = _four_digit_year_to_two_digit(
            datetime.strptime(
                cert.get_notAfter(),
                four_digit_year_fmt)
            )
    serial_number = format(cert.get_serial_number(), 'X')

    #gotta prepend a /
    subject = '/'

    # then we can add the rest of the subject
    subject += '/'.join(
            ['{0}={1}'.format(
                x, y
                ) for x, y in cert.get_subject().get_components()]
            )
    subject += '\n'

    return (index_file, expire_date, serial_number, subject)


def _write_cert_to_database(ca_name, cert, ca_dir=None, status='V'):
    '''
    write out the index.txt database file in the appropriate directory to
    track certificates

    ca_name
        name of the CA
    cert
        certificate to be recorded
    '''
    if ca_dir is None:
        ca_dir = '{0}/{1}'.format(_cert_base_path(), ca_name)

    index_file, expire_date, serial_number, subject = _get_basic_info(ca_name, cert, ca_dir)

    index_data = '{0}\t{1}\t\t{2}\tunknown\t{3}'.format(
            status,
            expire_date,
            serial_number,
            subject
            )

    with salt.utils.fopen(index_file, 'a+') as ofile:
        ofile.write(index_data)


def _ca_exists(ca_name, ca_dir=None, ca_filename=None):
    '''
    Verify whether a Certificate Authority (CA) already exists

    ca_name
        name of the CA
    '''

    if ca_dir is None:
        ca_dir = '{0}/{1}'.format(_cert_base_path(), ca_name)

    if ca_filename is None:
        ca_filename = '{0}_ca_cert'.format(ca_name)

    if os.path.exists('{0}/{1}.crt'.format(ca_dir, ca_filename)):
        return True
    return False


def _check_onlyif_unless(onlyif, unless):
    ret = None
    retcode = __salt__['cmd.retcode']
    if onlyif is not None:
        if not isinstance(onlyif, string_types):
            if not onlyif:
                ret = {'comment': 'onlyif execution failed',
                        'result': True}
        elif isinstance(onlyif, string_types):
            if retcode(onlyif) != 0:
                ret = {'comment': 'onlyif execution failed',
                        'result': True}
                log.debug('onlyif execution failed')
    if unless is not None:
        if not isinstance(unless, string_types):
            if unless:
                ret = {'comment': 'unless execution succeeded',
                        'result': True}
        elif isinstance(unless, string_types):
            if retcode(unless) == 0:
                ret = {'comment': 'unless execution succeeded',
                        'result': True}
                log.debug('unless execution succeeded')
    return ret


def create_ca(
        ca_name,
        bits=2048,
        days=365,
        CN='localhost',
        C='US',
        ST='Utah',
        L='Salt Lake City',
        O='SaltStack',
        OU=None,
        emailAddress='xyz@pdq.net',
        ca_dir=None,
        ca_filename=None,
        onlyif=None,
        unless=None):
    '''
    Create a Certificate Authority (CA)

    ca_name
        name of the CA
    bits
        number of RSA key bits, default is 2048
    days
        number of days the CA will be valid, default is 365
    CN
        common name in the request, default is "localhost"
    C
        country, default is "US"
    ST
        state, default is "Utah"
    L
        locality, default is "Centerville", the city where SaltStack originated
    O
        organization, default is "SaltStack"
    OU
        organizational unit, default is None
    emailAddress
        email address for the CA owner, default is 'xyz@pdq.net'

    Writes out a CA certificate based upon defined config values. If the file
    already exists, the function just returns assuming the CA certificate
    already exists.

    If the following values were set::

        ca.cert_base_path='/etc/pki'
        ca_name='koji'

    the resulting CA, and corresponding key, would be written in the following location::

        /etc/pki/koji/koji_ca_cert.crt
        /etc/pki/koji/koji_ca_cert.key

    CLI Example:

    .. code-block:: bash

        salt '*' tls.create_ca test_ca
    '''
    status = _check_onlyif_unless(onlyif, unless)
    if status is not None:
        return None

    if ca_dir is None:
        ca_dir = '{0}/{1}'.format(_cert_base_path(), ca_name)

    if ca_filename is None:
        ca_filename = '{0}_ca_cert'.format(ca_name)

    if _ca_exists(ca_name, ca_dir, ca_filename):
        return 'Certificate for CA named "{0}" already exists'.format(ca_name)

    if not os.path.exists('{0}'.format(ca_dir)):
        os.makedirs('{0}'.format(ca_dir))

    key = OpenSSL.crypto.PKey()
    key.generate_key(OpenSSL.crypto.TYPE_RSA, bits)

    ca = OpenSSL.crypto.X509()
    ca.set_version(3)
    ca.set_serial_number(_new_serial(ca_name, CN))
    ca.get_subject().C = C
    ca.get_subject().ST = ST
    ca.get_subject().L = L
    ca.get_subject().O = O
    if OU:
        ca.get_subject().OU = OU
    ca.get_subject().CN = CN
    ca.get_subject().emailAddress = emailAddress

    ca.gmtime_adj_notBefore(0)
    ca.gmtime_adj_notAfter(int(days) * 24 * 60 * 60)
    ca.set_issuer(ca.get_subject())
    ca.set_pubkey(key)

    ca.add_extensions([
        OpenSSL.crypto.X509Extension('basicConstraints', True,
                                     'CA:TRUE, pathlen:0'),
        OpenSSL.crypto.X509Extension('keyUsage', True,
                                     'keyCertSign, cRLSign'),
        OpenSSL.crypto.X509Extension('subjectKeyIdentifier', False, 'hash',
                                     subject=ca)
      ])

    ca.add_extensions([
        OpenSSL.crypto.X509Extension(
            'authorityKeyIdentifier',
            False,
            'issuer:always,keyid:always',
            issuer=ca
        )
    ])
    ca.sign(key, 'sha1')

    if ca_dir is None:
        ca_dir = '{0}/{1}'.format(_cert_base_path(), ca_name)

    if ca_filename is None:
        ca_filename = '{0}_ca_cert'.format(ca_name)

    ca_key = salt.utils.fopen(
            '{0}/{1}.key'.format(
                ca_dir,
                ca_filename
                ),
            'w'
            )
    ca_key.write(
            OpenSSL.crypto.dump_privatekey(OpenSSL.crypto.FILETYPE_PEM, key)
            )
    ca_key.close()

    ca_crt = salt.utils.fopen(
            '{0}/{1}.crt'.format(
                ca_dir,
                ca_filename
                ),
            'w'
            )
    ca_crt.write(
            OpenSSL.crypto.dump_certificate(OpenSSL.crypto.FILETYPE_PEM, ca)
            )
    ca_crt.close()

    _write_cert_to_database(ca_name, ca, ca_dir)

    ret = ('Created Private Key "{0}": "{1}/{2}.key." ').format(
                    ca_name,
                    ca_dir,
                    ca_filename
                    )
    ret += ('Created CA "{0}": "{1}/{2}.crt."').format(
                    ca_name,
                    ca_dir,
                    ca_filename
                    )

    return ret


def create_csr(
        ca_name,
        ca_dir=None,
        ca_filename=None,
        bits=2048,
        CN='localhost',
        C='US',
        ST='Utah',
        L='Salt Lake City',
        O='SaltStack',
        OU=None,
        emailAddress='xyz@pdq.net',
        cert_dir=None,
        cert_filename=None,
        onlyif=None,
        unless=None):
    '''
    Create a Certificate Signing Request (CSR) for a
    particular Certificate Authority (CA)

    ca_name
        name of the CA
    bits
        number of RSA key bits, default is 2048
    CN
        common name in the request, default is "localhost"
    C
        country, default is "US"
    ST
        state, default is "Utah"
    L
        locality, default is "Centerville", the city where SaltStack originated
    O
        organization, default is "SaltStack"
        NOTE: Must the same as CA certificate or an error will be raised
    OU
        organizational unit, default is None
    emailAddress
        email address for the request, default is 'xyz@pdq.net'

    Writes out a Certificate Signing Request (CSR) If the file already
    exists, the function just returns assuming the CSR already exists.

    If the following values were set::

        ca.cert_base_path='/etc/pki'
        ca_name='koji'
        CN='test.egavas.org'

    the resulting CSR, and corresponding key, would be written in the
    following location::

        /etc/pki/koji/certs/test.egavas.org.csr
        /etc/pki/koji/certs/test.egavas.org.key

    CLI Example:

    .. code-block:: bash

        salt '*' tls.create_csr test
    '''
    status = _check_onlyif_unless(onlyif, unless)
    if status is not None:
        return None

    if ca_dir is None:
        ca_dir = '{0}/{1}'.format(_cert_base_path(), ca_name)

    if ca_filename is None:
        ca_filename = '{0}_ca_cert'.format(ca_name)

    if cert_dir is None:
        cert_dir = '{0}/{1}/certs'.format(_cert_base_path(), ca_name)

    if cert_filename is None:
        cert_filename = '{0}'.format(CN)

    if not _ca_exists(ca_name, ca_dir, ca_filename):
        return ('Certificate for CA named "{0}" does not exist, please create '
                'it first.').format(ca_name)

    if not os.path.exists('{0}'.format(cert_dir)):
        os.makedirs("{0}".format(cert_dir))

    if os.path.exists('{0}/{1}.csr'.format(cert_dir, cert_filename)):
        return 'Certificate Request "{0}" already exists'.format(CN)

    key = OpenSSL.crypto.PKey()
    key.generate_key(OpenSSL.crypto.TYPE_RSA, bits)

    req = OpenSSL.crypto.X509Req()

    req.get_subject().C = C
    req.get_subject().ST = ST
    req.get_subject().L = L
    req.get_subject().O = O
    if OU:
        req.get_subject().OU = OU
    req.get_subject().CN = CN
    req.get_subject().emailAddress = emailAddress
    req.set_pubkey(key)
    req.sign(key, 'sha1')

    # Write private key and request
    priv_key = salt.utils.fopen(
            '{0}/{1}.key'.format(cert_dir, cert_filename),
            'w+'
            )
    priv_key.write(
            OpenSSL.crypto.dump_privatekey(OpenSSL.crypto.FILETYPE_PEM, key)
            )
    priv_key.close()

    csr = salt.utils.fopen(
            '{0}/{1}.csr'.format(cert_dir, cert_filename),
            'w+'
            )
    csr.write(
            OpenSSL.crypto.dump_certificate_request(
                OpenSSL.crypto.FILETYPE_PEM,
                req
                )
            )
    csr.close()

    ret = 'Created Private Key: "{0}/{1}.key." '.format(
        cert_dir,
        cert_filename
        )
    ret += 'Created CSR for "{0}": "{1}/{2}.csr."'.format(
        CN,
        cert_dir,
        cert_filename
        )

    return ret


def create_self_signed_cert(
        tls_dir='tls',
        bits=2048,
        days=365,
        CN='localhost',
        C='US',
        ST='Utah',
        L='Salt Lake City',
        O='SaltStack',
        OU=None,
        emailAddress='xyz@pdq.net'):

    '''
    Create a Self-Signed Certificate (CERT)

    tls_dir
        location appended to the ca.cert_base_path, default is 'tls'
    bits
        number of RSA key bits, default is 2048
    CN
        common name in the request, default is "localhost"
    C
        country, default is "US"
    ST
        state, default is "Utah"
    L
        locality, default is "Centerville", the city where SaltStack originated
    O
        organization, default is "SaltStack"
        NOTE: Must the same as CA certificate or an error will be raised
    OU
        organizational unit, default is None
    emailAddress
        email address for the request, default is 'xyz@pdq.net'

    Writes out a Self-Signed Certificate (CERT). If the file already
    exists, the function just returns.

    If the following values were set::

        ca.cert_base_path='/etc/pki'
        tls_dir='koji'
        CN='test.egavas.org'

    the resulting CERT, and corresponding key, would be written in the
    following location::

        /etc/pki/koji/certs/test.egavas.org.crt
        /etc/pki/koji/certs/test.egavas.org.key

    CLI Example:

    .. code-block:: bash

        salt '*' tls.create_self_signed_cert

    Passing options from the command line:

    .. code-block:: bash

        salt 'minion' tls.create_self_signed_cert CN='test.mysite.org'
    '''

    if not os.path.exists('{0}/{1}/certs/'.format(_cert_base_path(), tls_dir)):
        os.makedirs("{0}/{1}/certs/".format(_cert_base_path(), tls_dir))

    if os.path.exists(
            '{0}/{1}/certs/{2}.crt'.format(_cert_base_path(), tls_dir, CN)
            ):
        return 'Certificate "{0}" already exists'.format(CN)

    key = OpenSSL.crypto.PKey()
    key.generate_key(OpenSSL.crypto.TYPE_RSA, bits)

    # create certificate
    cert = OpenSSL.crypto.X509()
    cert.set_version(3)

    cert.gmtime_adj_notBefore(0)
    cert.gmtime_adj_notAfter(int(days) * 24 * 60 * 60)

    cert.get_subject().C = C
    cert.get_subject().ST = ST
    cert.get_subject().L = L
    cert.get_subject().O = O
    if OU:
        cert.get_subject().OU = OU
    cert.get_subject().CN = CN
    cert.get_subject().emailAddress = emailAddress

    cert.set_serial_number(_new_serial(tls_dir, CN))
    cert.set_issuer(cert.get_subject())
    cert.set_pubkey(key)
    cert.sign(key, 'sha1')

    # Write private key and cert
    priv_key = salt.utils.fopen(
            '{0}/{1}/certs/{2}.key'.format(_cert_base_path(), tls_dir, CN),
            'w+'
            )
    priv_key.write(
            OpenSSL.crypto.dump_privatekey(OpenSSL.crypto.FILETYPE_PEM, key)
            )
    priv_key.close()

    crt = salt.utils.fopen('{0}/{1}/certs/{2}.crt'.format(
        _cert_base_path(),
        tls_dir,
        CN
        ), 'w+')
    crt.write(
            OpenSSL.crypto.dump_certificate(
                OpenSSL.crypto.FILETYPE_PEM,
                cert
                )
            )
    crt.close()

    _write_cert_to_database(tls_dir, cert)

    ret = 'Created Private Key: "{0}/{1}/certs/{2}.key." '.format(
                    _cert_base_path(),
                    tls_dir,
                    CN
                    )
    ret += 'Created Certificate: "{0}/{1}/certs/{2}.crt."'.format(
                    _cert_base_path(),
                    tls_dir,
                    CN
                    )

    return ret


def create_ca_signed_cert(
        ca_name,
        CN,
        days=365,
        ca_dir=None,
        ca_filename=None,
        cert_dir=None,
        cert_filename=None,
        **extensions):
    '''
    Create a Certificate (CERT) signed by a
    named Certificate Authority (CA)

    ca_name
        name of the CA
    CN
        common name matching the certificate signing request
    days
        number of days certificate is valid, default is 365 (1 year)

    Writes out a Certificate (CERT) If the file already
    exists, the function just returns assuming the CERT already exists.

    The CN *must* match an existing CSR generated by create_csr. If it
    does not, this method does nothing.

    If the following values were set::

        ca.cert_base_path='/etc/pki'
        ca_name='koji'
        CN='test.egavas.org'

    the resulting signed certificate would be written in the
    following location::

        /etc/pki/koji/certs/test.egavas.org.crt

    CLI Example:

    .. code-block:: bash

        salt '*' tls.create_ca_signed_cert test localhost
    '''
    if ca_dir is None:
        ca_dir = '{0}/{1}'.format(_cert_base_path(), ca_name)

    if ca_filename is None:
        ca_filename = '{0}_ca_cert'.format(ca_name)

    if cert_dir is None:
        cert_dir = '{0}/{1}/certs'.format(_cert_base_path(), ca_name)

    if cert_filename is None:
        cert_filename = '{0}'.format(CN)

    if os.path.exists(
            '{0}/{1}.crt'.format(cert_dir, cert_filename)
            ):
        return 'Certificate "{0}" already exists'.format(CN)

    try:
        ca_cert = OpenSSL.crypto.load_certificate(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}.crt'.format(
                    ca_dir,
                    ca_filename
                    )).read()
                )
        ca_key = OpenSSL.crypto.load_privatekey(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}.key'.format(
                    ca_dir,
                    ca_filename
                    )).read()
                )
    except IOError:
        return 'There is no CA named "{0}"'.format(ca_name)

    try:
        req = OpenSSL.crypto.load_certificate_request(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}.csr'.format(
                    cert_dir,
                    cert_filename
                    )).read()
                )
    except IOError:
        return 'There is no CSR that matches the CN "{0}"'.format(CN)

    cert = OpenSSL.crypto.X509()
    cert.set_subject(req.get_subject())
    cert.gmtime_adj_notBefore(0)
    cert.gmtime_adj_notAfter(int(days) * 24 * 60 * 60)
    cert.set_serial_number(_new_serial(ca_name, CN))
    cert.set_issuer(ca_cert.get_subject())
    cert.set_pubkey(req.get_pubkey())
    extensions_list = []
    for name in extensions:
        log.debug("name: {0}, critical: {1}, options: {2}".format(
            name, extensions[name]['critical'], extensions[name]['options']))
        extensions_list.append(OpenSSL.crypto.X509Extension(
            name,
            extensions[name]['critical'],
            extensions[name]['options']))
    cert.add_extensions(extensions_list)
    cert.sign(ca_key, 'sha1')

    crt = salt.utils.fopen('{0}/{1}.crt'.format(
        cert_dir,
        cert_filename
        ), 'w+')
    crt.write(
            OpenSSL.crypto.dump_certificate(
                OpenSSL.crypto.FILETYPE_PEM,
                cert
                )
            )
    crt.close()

    _write_cert_to_database(ca_name, cert, ca_dir)

    return ('Created Certificate for "{0}": '
            '"{1}/{2}.crt"').format(
                    CN,
                    cert_dir,
                    cert_filename
                    )


def create_empty_crl(
        ca_name,
        ca_dir=None,
        ca_filename=None,
        crl_file=None,
        onlyif=None,
        unless=None):

    status = _check_onlyif_unless(onlyif, unless)
    if status is not None:
        return None

    if ca_dir is None:
        ca_dir = '{0}/{1}'.format(_cert_base_path(), ca_name)

    if ca_filename is None:
        ca_filename = '{0}_ca_cert'.format(ca_name)

    if crl_file is None:
        crl_file = '{0}/{1}/crl.pem'.format(
                _cert_base_path(),
                ca_name
                )

    if os.path.exists('{0}'.format(crl_file)):
        return 'CRL "{0}" already exists'.format(crl_file)

    try:
        ca_cert = OpenSSL.crypto.load_certificate(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}.crt'.format(
                    ca_dir,
                    ca_filename
                    )).read()
                )
        ca_key = OpenSSL.crypto.load_privatekey(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}.key'.format(
                    ca_dir,
                    ca_filename)).read()
                )
    except IOError:
        return 'There is no CA named "{0}"'.format(ca_name)

    crl = OpenSSL.crypto.CRL()
    crl_text = crl.export(ca_cert, ca_key)

    with salt.utils.fopen(crl_file, 'w') as f:
        f.write(crl_text)

    return ('Created empty CRL: "{0}"'.format(crl_file))


def revoke_cert(
        ca_name,
        CN,
        ca_dir=None,
        ca_filename=None,
        cert_dir=None,
        cert_filename=None,
        crl_file=None,
        onlyif=None,
        unless=None):

    status = _check_onlyif_unless(onlyif, unless)
    if status is not None:
        return None

    if ca_dir is None:
        ca_dir = '{0}/{1}'.format(_cert_base_path(), ca_name)

    if ca_filename is None:
        ca_filename = '{0}_ca_cert'.format(ca_name)

    if cert_dir is None:
        cert_dir = '{0}/{1}/certs'.format(_cert_base_path(), ca_name)

    if cert_filename is None:
        cert_filename = '{0}'.format(CN)

    try:
        ca_cert = OpenSSL.crypto.load_certificate(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}.crt'.format(
                    ca_dir,
                    ca_filename
                    )).read()
                )
        ca_key = OpenSSL.crypto.load_privatekey(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}.key'.format(
                    ca_dir,
                    ca_filename)).read()
                )
    except IOError:
        return 'There is no CA named "{0}"'.format(ca_name)

    try:
        client_cert = OpenSSL.crypto.load_certificate(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}.crt'.format(
                    cert_dir,
                    cert_filename)).read()
                )
    except IOError:
        return 'There is no client certificate named "{0}"'.format(CN)

    index_file, expire_date, serial_number, subject = _get_basic_info(
            ca_name,
            client_cert,
            ca_dir)

    index_serial_subject = '{0}\tunknown\t{1}'.format(
            serial_number,
            subject)
    index_v_data = 'V\t{0}\t\t{1}'.format(
            expire_date,
            index_serial_subject)
    index_r_data_pattern = re.compile(
            r"R\t" +
            expire_date +
            r"\t\d{12}Z\t" +
            re.escape(index_serial_subject))
    index_r_data = 'R\t{0}\t{1}\t{2}'.format(
            expire_date,
            _four_digit_year_to_two_digit(datetime.now()),
            index_serial_subject)

    ret = {}
    with salt.utils.fopen(index_file) as f:
        for line in f:
            if index_r_data_pattern.match(line):
                revoke_date = line.split('\t')[2]
                try:
                    datetime.strptime(revoke_date, two_digit_year_fmt)
                    return ('"{0}/{1}.crt" was already revoked, '
                            'serial number: {2}').format(
                                    cert_dir,
                                    cert_filename,
                                    serial_number
                                    )
                except ValueError:
                    ret['retcode'] = 1
                    ret['comment'] = ("Revocation date '{0}' does not match"
                                     " format '{1}'").format(
                                             revoke_date,
                                             two_digit_year_fmt)
                    return ret
            elif index_serial_subject in line:
                __salt__['file.replace'](
                        index_file,
                        index_v_data,
                        index_r_data,
                        backup=False)
                break

    crl = OpenSSL.crypto.CRL()

    with salt.utils.fopen(index_file) as f:
        for line in f:
            if line.startswith('R'):
                fields = line.split('\t')
                revoked = OpenSSL.crypto.Revoked()
                revoked.set_serial(fields[3])
                revoke_date_2_digit = datetime.strptime(fields[2], two_digit_year_fmt)
                revoked.set_rev_date(revoke_date_2_digit.strftime(four_digit_year_fmt))
                crl.add_revoked(revoked)

    crl_text = crl.export(ca_cert, ca_key)

    if crl_file is None:
        crl_file = '{0}/{1}/crl.pem'.format(
                _cert_base_path(),
                ca_name
                )

    if os.path.isdir('{0}'.format(crl_file)):
        ret['retcode'] = 1
        ret['comment'] = 'crl_file "{0}" is an existing directory'.format(crl_file)
        return ret

    with salt.utils.fopen(crl_file, 'w') as f:
        f.write(crl_text)

    return ('Revoked Certificate: "{0}/{1}.crt", '
            'serial number: {2}').format(
                    cert_dir,
                    cert_filename,
                    serial_number
                    )


def create_pkcs12(ca_name, CN, passphrase=''):
    '''
    Create a PKCS#12 browser certificate for a particular Certificate (CN)

    ca_name
        name of the CA
    CN
        common name matching the certificate signing request
    passphrase
        used to unlock the PKCS#12 certificate when loaded into the browser

    If the following values were set::

        ca.cert_base_path='/etc/pki'
        ca_name='koji'
        CN='test.egavas.org'

    the resulting signed certificate would be written in the
    following location::

        /etc/pki/koji/certs/test.egavas.org.p12

    CLI Example:

    .. code-block:: bash

        salt '*' tls.create_pkcs12 test localhost
    '''
    if os.path.exists(
            '{0}/{1}/certs/{2}.p12'.format(
                _cert_base_path(),
                ca_name,
                CN)
            ):
        return 'Certificate "{0}" already exists'.format(CN)

    try:
        ca_cert = OpenSSL.crypto.load_certificate(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}/{2}_ca_cert.crt'.format(
                    _cert_base_path(),
                    ca_name,
                    ca_name
                    )).read()
                )
    except IOError:
        return 'There is no CA named "{0}"'.format(ca_name)

    try:
        cert = OpenSSL.crypto.load_certificate(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}/certs/{2}.crt'.format(
                    _cert_base_path(),
                    ca_name,
                    CN
                    )).read()
                )
        key = OpenSSL.crypto.load_privatekey(
                OpenSSL.crypto.FILETYPE_PEM,
                salt.utils.fopen('{0}/{1}/certs/{2}.key'.format(
                    _cert_base_path(),
                    ca_name,
                    CN
                    )).read()
                )
    except IOError:
        return 'There is no certificate that matches the CN "{0}"'.format(CN)

    pkcs12 = OpenSSL.crypto.PKCS12()

    pkcs12.set_certificate(cert)
    pkcs12.set_ca_certificates([ca_cert])
    pkcs12.set_privatekey(key)

    with salt.utils.fopen('{0}/{1}/certs/{2}.p12'.format(
        _cert_base_path(),
        ca_name,
        CN
        ), 'w') as ofile:
        ofile.write(pkcs12.export(passphrase=passphrase))

    return ('Created PKCS#12 Certificate for "{0}": '
            '"{1}/{2}/certs/{3}.p12"').format(
                    CN,
                    _cert_base_path(),
                    ca_name,
                    CN
                    )

if __name__ == '__main__':
    #create_ca('koji', days=365, **cert_sample_meta)
    create_csr(
            'koji',
            CN='test_system',
            C="US",
            ST="Utah",
            L="Centerville",
            O="SaltStack",
            OU=None,
            emailAddress='test_system@saltstack.org'
            )
    create_ca_signed_cert('koji', 'test_system')
    create_pkcs12('koji', 'test_system', passphrase='test')
